const BumToken = artifacts.require('./BumToken.sol')

module.exports = function(deployer){
  deployer.deploy(BumToken, 100000000000, 'BUM', 'BUM')
  // Get address of contract.
  .then(() => console.log('Address is ' + BumToken.address));
  // Another way:
  // .then(() => BumToken.deployed())
  // .then(_instance => console.log('Address is ' + _instance.address));
}
