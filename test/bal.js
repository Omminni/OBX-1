var Coin = artifacts.require("./OBXCoin.sol");

contract('Coin', function(accounts) {
    console.log(accounts[0]);
    return Coin.deployed().then(function(instance) {
        return instance.balanceOf.call(accounts[0]);
      }).then(function(balance) {
        console.log(balance);
      });
    });

