//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAO {
    enum Side {Yes, No}
    enum Status {Undecided, Approved, Rejected}

    struct Proposal {
        address author;
        bytes32 hash; //Hash of the proposal
        uint createdAt;
        uint votesYes;// How many votes for Yes
        uint votesNo;// How many votes for Yes
        Status status;
    }
    
    //Store all proposals indexed by their hashes
    mapping(bytes32 => Proposal) public proposals;
    //Map who voted for who avoid double vote
    mapping(address => mapping(bytes32=>bool)) public votes;
    //Map investor to amount of shares
    mapping(address => uint) public shares;

    uint public totalShares;
    IERC20 public token;
    uint constant CREATE_PROPOSAL_MIN_SHARE = 1000*10**18;
    uint constant VOTING_PERIOD = 7 days;


    constructor (address _governanceToken){
        token = IERC20(_governanceToken);
    }

   
    //Deposit Governance Token
    function deposit(uint _amount) external{
        //Increment shares mapping
        shares[msg.sender] += _amount;
        //Increment Total number of Share
        totalShares += _amount;
        //Allow transfer
        token.approve(address(this), _amount);
        //Transfer the token
        token.transferFrom(msg.sender,address(this), _amount);
    }//end function deposit

    //Withdraw Function
    function withdraw(uint _amount) external{
        require(shares[msg.sender] >= _amount, "Not enough shares");        
        shares[msg.sender] -= _amount;
        totalShares -= _amount;
        token.transfer(msg.sender, _amount);

    }//end function Withdraw

    // Create Proposal
    function createProposal(bytes32 proposalHash) external{
        require(
            shares[msg.sender] >= CREATE_PROPOSAL_MIN_SHARE,
            "Not enough shares to create a proposal"
        );

        require( proposals[proposalHash].hash == bytes32(0), "Proposal Already Exists" );


        proposals[proposalHash] = Proposal(
            msg.sender,
            proposalHash,
            block.timestamp,
            0,
            0,
            Status.Undecided
        );
    }//end function create proposal

    function vote(bytes32 _proposalHash, Side side)external{
        Proposal storage proposal = proposals[_proposalHash];
        require( proposals[_proposalHash].hash != bytes32(0), "Proposal Already Exists" );
        require(votes[msg.sender][_proposalHash] == false, "Already voted");
        require(block.timestamp <= proposal.createdAt + VOTING_PERIOD, "Voting period over");

        votes[msg.sender][_proposalHash] = true;
        //Case of vote YES
        if(side == Side.Yes){
            proposal.votesYes += shares[msg.sender];
            // Solidity cannot work on decimals so proposal.votesYes is multiplied by 100 
            // as the 0.50 also is multiplied by 100, Hence, we compare with number 50
            if(((proposal.votesYes * 100) / totalShares) > 50){
                proposal.status = Status.Approved;
            } 
        } 
        // Case of vote NO
        else {
            if(side == Side.No){
                proposal.votesNo += shares[msg.sender];
                // Solidity cannot work on decimals so proposal.votesNo is multiplied by 100 
                // as the 0.50 also is multiplied by 100, Hence, we compare with number 50
                if(((proposal.votesNo * 100) / totalShares) > 50){
                    proposal.status = Status.Rejected;
                } 
            }
        }  
    }//end function vote


    //Get balance
    function getBalance() external view returns(uint){
       uint balance = address(this).balance;
       return balance;
    }

}
