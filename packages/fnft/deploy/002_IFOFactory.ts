import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  const ifoFactory = await deploy("IFOFactory", { from: deployer });
  console.log("IFOFactory", ifoFactory.address);
};

func.tags = ["mainnet", "testnet"];

export default func;
