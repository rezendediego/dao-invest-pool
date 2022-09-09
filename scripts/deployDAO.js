const { ethers } = require("hardhat")
const BONUS_COIN_ADDRESS = "0x6523703779545f428D15FA8Ba3bfD759Ae8EBdE2";

//npx hardhat run scripts/deployDAO.js --network ropsten
//DAO deployed to:  0x82A784F2E32f561bd787Fa9AaBae21B7915315af
async function main(){
    const [deployer] = await ethers.getSigners();

    const DAO = await ethers.getContractFactory("DAO", deployer);
    const dao = await DAO.deploy(BONUS_COIN_ADDRESS);

    console.log("DAO deployed to: ", dao.address);

}


main()
.then(() => process.exit(0))
.catch((error)=>{
    console.error(error);
    process.exit(1);
});
