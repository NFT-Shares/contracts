import { HardhatUserConfig } from "hardhat/config";

import "hardhat-deploy";
import "@openzeppelin/hardhat-upgrades";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "@nomiclabs/hardhat-ethers";

require("hardhat-contract-sizer");

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.6.12",
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
      chainId: 1440002,
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
