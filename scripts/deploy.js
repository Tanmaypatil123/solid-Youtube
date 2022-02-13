
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {

  let accounts = await ethers.getSigners();
  let deployer = accounts[0];
  let video_owner = accounts[1];
  let user = accounts[2];
  const Videos = await ethers.getContractFactory("VideoContract");
  const YouToken = await ethers.getContractFactory("YOUTOKEN");
  youtoken = await YouToken.deploy();
  tx = await youtoken.deployed();

  videos = await Videos.deploy(youtoken.address,{
    from:deployer
  });
  await videos.deployed();
  console.log(`Contract is deployed at ${videos.address}`)
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
