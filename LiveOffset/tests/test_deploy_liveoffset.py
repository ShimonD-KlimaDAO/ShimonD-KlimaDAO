from brownie import BCT, LiveOffset, accounts

def test_deploy_liveoffset():

    deployer = accounts[0]
    stranger = accounts[1]
    amount = 100000000000000000000   # 100 tokens, 18 decimal precision

    bct = BCT.deploy(amount, {"from":deployer})
    live = LiveOffset.deploy({"from":deployer})

    my_balance = bct.balanceOf(deployer)

    assert my_balance == amount

    bct.transfer(live, (amount*0.5), {"from":deployer}) # 50 tokens each

    assert bct.balanceOf(live) == amount*0.5

    tx = live.changeEventParams(bct, deployer, 
        1000000000000000000, False, bct)

    print(tx.events) # fail the test below to see print results in pytest

    assert  live.offsetter() == live.owner() == deployer

    live.singleOffset("testing event name", "long live planet earth", {"from":deployer}) # change to 'stranger' fails test 

    #2. uncomment approval and KI calls and deploy to main, change event params, and try offsetting normal and retirement with BCT and selective project.

    live.transferOffsetter(stranger, {"from":deployer})

    live.singleOffset("testing event name2", "long live planet earth2", {"from":stranger}) # change to 'deployer' fails test

    #live.transferOwnership(stranger, {"from":deployer}) 

    live.withdrawBalanceOwner({"from":deployer})
    
    assert bct.balanceOf(live) == 0 and bct.balanceOf(deployer) == amount

    
