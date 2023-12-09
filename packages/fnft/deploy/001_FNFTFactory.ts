import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const fnftFactory = await deploy("FNFTFactory", { from: deployer });
  console.log("FNFTFactory", fnftFactory.address);
};

func.tags = ["mainnet", "testnet"];

export default func;
