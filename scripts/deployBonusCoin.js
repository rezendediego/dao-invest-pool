const { ethers } = require("hardhat")

//npx hardhat run scripts/deployBonusCoin.js --network ropsten
//Bonus Coin deployed to:  0x6523703779545f428D15FA8Ba3bfD759Ae8EBdE2
async function main(){
    const [deployer] = await ethers.getSigners();

    const BonusCoin = await ethers.getContractFactory("BonusCoin", deployer);
    const bonusCoin = await BonusCoin.deploy(5000);

    console.log("Bonus Coin deployed to: ", bonusCoin.address);

}


main()
.then(() => process.exit(0))
.catch((error)=>{
    console.error(error);
    process.exit(1);
});
