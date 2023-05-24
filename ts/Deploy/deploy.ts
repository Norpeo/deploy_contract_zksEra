import { Wallet, utils } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import account  from "../config.ts"
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`开始部署合约`);

  const wallet = new Wallet(account.privateKey);

  const deployer = new Deployer(hre, wallet);
  //换自己合约的名字
  const artifact = await deployer.loadArtifact("Easycontract");

  const deploymentFee = await deployer.estimateDeployFee(artifact,[]);

  const parsedFee = ethers.utils.formatEther(deploymentFee.toString());
  console.log(`部署合约预估花费 ${parsedFee} ETH`);

  const greeterContract = await deployer.deploy(artifact,[]);

  const contractAddress = greeterContract.address;
  console.log(`${artifact.contractName} 合约部署的地址为： ${contractAddress}`);
}
