import dotenv from "dotenv";
dotenv.config();

export const hardhatBaseConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.9",
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
    tssUpdater: 0,
  },
};
