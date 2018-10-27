var Migrations = artifacts.require("./Migrations.sol");
var Coin = artifacts.require("./OBXCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Coin,10000);

};
