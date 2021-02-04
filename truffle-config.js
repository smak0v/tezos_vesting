const { accounts, accountsMap } = require("./scripts/sandbox/accounts");

module.exports = {
  networks: {
    development: {
      host: "http://localhost",
      port: 8732,
      network_id: "*",
      secretKey: accountsMap.get(accounts[0]),
      type: "tezos",
    },
    carthagenet: {
      host: "https://carthagenet.smartpy.io",
      port: 443,
      network_id: "*",
      type: "tezos",
    },
    mainnet: {
      host: "https://mainnet.smartpy.io",
      port: 443,
      network_id: "*",
      type: "tezos",
    },
    zeronet: {
      host: "https://zeronet.smartpy.io",
      port: 443,
      network_id: "*",
      type: "tezos",
    },
  },
};
