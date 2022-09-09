const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DAO functions", function () {
    this.timeout(20000); // Increases the timeout !
    let DAO;
    let dao;
    let BonusCoin;
    let bonusCoin;
    let amountCoins;
    let BONUS_COIN_ADDRESS;
    
    beforeEach(async function () {
        const [deployer] = await ethers.getSigners();
        amountCoins = 20000;
        BonusCoin = await ethers.getContractFactory("BonusCoin", deployer);
        bonusCoin =  await  BonusCoin.deploy(amountCoins);
        await bonusCoin.deployed();
        BONUS_COIN_ADDRESS = bonusCoin.getAddress();
    
        DAO = await ethers.getContractFactory("DAO", deployer);
        dao = await  DAO.deploy(BONUS_COIN_ADDRESS);
        await dao.deployed();
    });

    it("Should deposit", async function () {
        await dao.deposit(1000);
        const balance = await dao.getBalance();
        console.log(balance);
        const expectedValue = 1000*10**18;
        
        expect(await balance.toString()).to.equal(expectedValue.toString());
    });
});