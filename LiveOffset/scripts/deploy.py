from brownie import LiveOffset, accounts

def main():

    deployer = accounts.load('deployment_private')

    live = LiveOffset.deploy({'from': deployer}, publish_source = True)
    BCT = '0x2F800Db0fdb5223b3C3f354886d907A671414A7F'

    live.changeEventParams(BCT, deployer, 
        1000000000000000000, False, BCT)
    
