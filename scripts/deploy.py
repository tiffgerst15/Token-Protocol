from scripts.helpful import get_account, get_contract
from brownie import accounts,config, network,Registry,TokenPool, TokenPoolFactory,TRSYERC20,Treasury, Contract, MockERC20, MockV3Aggregator, log
from web3 import Web3

TOKENS = ["DAI", "AAVE", "ETH"]
CONCENTRATION = [50e4, 30e4, 20e4]
DEPLOYER = get_account()
USER_A = accounts[1]
USER_B = accounts[2]
USERS = [USER_A, USER_B]
tokens = []
feeds = []
pools = []
log = []


def deploy_all():
    registry = Registry.deploy({"from":DEPLOYER})
    print(f"Deployed Registry to {registry.address}")
    token = TRSYERC20.deploy(1000000000000000000,{"from":DEPLOYER})
    print(f"Deployed TRSY to {token.address}")
    treasury = Treasury.deploy(token,registry,{"from":DEPLOYER})
    print(f"Deployed Treasury to {treasury.address}")
    factory = TokenPoolFactory.deploy(registry,{"from":DEPLOYER})
    print(f"Deployed TokenPoolFactory to {factory.address}")

def deployMockERC20(name, symbol):
    erc20 = MockERC20.deploy(name, symbol, {"from": DEPLOYER})
    erc20.transfer(USER_A, 100000000000000000000, {"from": DEPLOYER})
    erc20.transfer(USER_B, 100000000000000000000, {"from": DEPLOYER})
    log.append(f"Mock {name} token deployed")
    return erc20


def whitelistTokens():
    for token in tokens:
        treasury.whitelistToken(token,{"from":DEPLOYER})
        print(f"Whitelisted {token}")

def deployPools():
    for token in tokens:
        mock = deployMockFeed(token)
        factory.deployTokenPool(token)

def main():
    deploy_all()
    print("Deployment complete!")