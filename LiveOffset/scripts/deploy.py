from brownie import LiveOffset, accounts

def main():

    deployer = accounts.load('deployment_private')

    live = LiveOffset.deploy({'from': deployer}, publish_source = True)
    BCT = '0x2F800Db0fdb5223b3C3f354886d907A671414A7F'

    live.changeEventParams(BCT, deployer, 10000000000000000, True, '0x899b75bc5298784355cA6a265b79B839e6d02BC0') 