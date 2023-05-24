require("@matterlabs/hardhat-zksync-deploy")
require("@matterlabs/hardhat-zksync-solc")

module.exports = {
  zksolc: {
    version: "1.3.10",
    compilerSource: "binary",
    settings: {},
  },
  defaultNetwork: "zkSyncMainnet",

  networks: {
    zkSyncMainnet: {
      url: "https://mainnet.era.zksync.io",
      ethNetwork: "mainnet", 
      zksync: true,
    },
  },
  solidity: {
    version: "0.8.8",
  },
};
