const Vesting = artifacts.require("Vesting");

const { accounts } = require("../scripts/sandbox/accounts");

module.exports = async (deployer, _network) => {
  const fiveDays = 432000;
  const now = new Date((await tezos.rpc.getBlockHeader()).timestamp);
  const startTimestamp = new Date(now.setSeconds(now.getSeconds() + fiveDays));

  await deployer.deploy(Vesting, {
    vestedAmount: "0",
    vestingAddress: accounts[0],
    adminAddress: accounts[0],
    vestingParams: {
      startTimestamp: startTimestamp,
      secondsPerTick: "5",
      tokensPerTick: "1",
    },
  });
};
