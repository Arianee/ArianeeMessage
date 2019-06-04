const ArianeeWhitelist = artifacts.require('ArianeeWhitelist');

contract('ArianeeWhitelist', (accounts) => {
  let whitelist;
  beforeEach(async () => {
    whitelist = await ArianeeWhitelist.new();
  });

  it('should autorized an abitited account to add an address in whitelist', async () => {

    whitelist.grantAbilities(accounts[1], 2,{from:accounts[0]});

    whitelist.addWhitelistedAddress(1, accounts[2],{from:accounts[1]});

    const isAble = await whitelist.isAuthorized(1 , accounts[2], accounts[3]);
    assert.equal(isAble, true);
  });

  it('should send as unauthorized an accounts blacklisted by token owner', async()=>{
    whitelist.grantAbilities(accounts[1], 2,{from:accounts[0]});
    whitelist.addWhitelistedAddress(1, accounts[2],{from:accounts[1]});

    whitelist.addBlacklistedAddress(accounts[2], 1, true, {from:accounts[3]});

    const isAble = await whitelist.isAuthorized(1 , accounts[2], accounts[3]);
    assert.equal(isAble, false);
  })

});