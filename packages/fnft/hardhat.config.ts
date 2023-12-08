import { HardhatUserConfig } from "hardhat/config";
import "hardhat-deploy";
import "@openzeppelin/hardhat-upgrades";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "@nomiclabs/hardhat-ethers";
import dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    xrpl_devnet: {
      url: "https://rpc-evm-sidechain.xrpl.org",
      chainId: 1440001,
      accounts: require("./secrets.json").privateKey,
      gas: 30000001,
      saveDeployments: true,
    },
  },
  namedAccounts: {
    deployer: 0,
  },
};

export default config;
