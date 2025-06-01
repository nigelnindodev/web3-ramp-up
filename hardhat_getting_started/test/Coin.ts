import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("Coin", function() {
  async function coinMintFixture() {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const Coin = await hre.ethers.getContractFactory("Coin");
    const coin = await Coin.deploy();

    return { coin, owner, otherAccount };
  }

  describe("Deployment", function() {
    it("Should set the deployer as the minter", async function() {
      const { coin, owner } = await loadFixture(coinMintFixture);
      expect(await coin.minter()).to.equal(owner.address);
    });
  });

  describe("Minting", function() {
    it("Should allow owner to mint coins to their own address", async function() {
      const { coin, owner } = await loadFixture(coinMintFixture);
      expect(await coin.balances(owner.address)).to.equal(0);

      // owner coins to themself 
      await coin.connect(owner).mint(owner.address, 100);

      //expect their balance to reflect the same
      expect(await coin.balances(owner.address)).to.equal(100);
    });

    it("Should allow owner to mint coints to other addresses", async function() {
      const { coin, owner, otherAccount } = await loadFixture(coinMintFixture);
      expect(await coin.balances(owner.address)).to.equal(0);
      expect(await coin.balances(otherAccount.address)).to.equal(0);

      // owner mints coin to other account
      await coin.connect(owner).mint(otherAccount.address, 100);

      expect(await coin.balances(owner.address)).to.equal(0);
      //other account balance should reflect the same
      expect(await coin.balances(otherAccount.address)).to.equal(100);
    });

    it("Should prevent other addresses from minting other than the owner", async function() {
      const { coin, otherAccount } = await loadFixture(coinMintFixture);

      await expect(
        coin.connect(otherAccount).mint(otherAccount.address, 100)
      ).to.be.reverted;

      // balance should still be 0
      expect(await coin.balances(otherAccount.address)).to.equal(0);
    });
  });
});
