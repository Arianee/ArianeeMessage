var arianeeWhitelist = artifacts.require('ArianeeWhitelist');
var arianeeMessage = artifacts.require('ArianeeMessage');

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(arianeeWhitelist);
  deployer.deploy(arianeeMessage);
};