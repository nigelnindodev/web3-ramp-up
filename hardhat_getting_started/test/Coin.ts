import { expect } from "chai";
import hre from "hardhat";

describe("Coin", function() {
  async function coinMintFixture() {
    const [owner, otherAccount] = await hre.ethers.getSigners();

    const Coin = await hre.ethers.getContractFactory("Coin");
    const coin = await Coin.deploy();

    return { coin, owner, otherAccount };
  }

  describe("Minting", function() {
    it("Should allow owner to mint coins to their own address", async function() { });

    it("Should allow owner to mint coints to other addresses", async function() { });

    it("Should prevent other addresses from minting other than the owner", async function() { });
  });
});
