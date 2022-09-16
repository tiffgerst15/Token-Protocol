from scripts.helpful import get_account, get_contract
from brownie import accounts,config, network,Registry,TokenPool, TokenPoolFactory,TRSYERC20,Treasury, Contract, MockERC20, MockV3Aggregator
from web3 import Web3
import yaml
import json
import os
import shutil

TOKENS = ["DAI", "AAVE", "ETH"]
CONCENTRATION = [50e4, 30e4, 20e4]
DEPLOYER = get_account()
USER_A = "0x8472a4261ca81EA033eb7C68CeD3C4B1b06d8D8D"
USER_B = "0x0109432E15A395336842aA110b74eCA8248e94E5"
USERS = [USER_A, USER_B]
feedAddress = ["0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9", "0x547a514d5e3769680Ce22B2361c10Ea13619e8a9","0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419"]
tokens = []
feeds = []
pools = []


def deploy_all(front_end_update=False):
    registry = Registry.deploy({"from":DEPLOYER},publish_source=True)
    print(f"Deployed Registry to {registry.address}")
    token = TRSYERC20.deploy({"from":DEPLOYER})
    print(f"Deployed TRSY to {token.address}")
    treasury = Treasury.deploy(registry, token,{"from":DEPLOYER},publish_source=True)
    print(f"Deployed Treasury to {treasury.address}")
    factory = TokenPoolFactory.deploy(registry,{"from":DEPLOYER},publish_source=True)
    print(f"Deployed TokenPoolFactory to {factory.address}")
    registry.setFactory(factory)
    deployMockERC20()
    whitelistTokens(treasury)
    deployPools(factory)
    if front_end_update:
        update_front_end()
   

def deployMockERC20():
    for symbol in TOKENS:
        erc20 = MockERC20.deploy(symbol, symbol, {"from": DEPLOYER})
        print(erc20)
        tokens.append(erc20)
        erc20.transfer(USER_A, 100000000000000000000, {"from": DEPLOYER})
        erc20.transfer(USER_B, 100000000000000000000, {"from": DEPLOYER})
        

def whitelistTokens(treasury):
    for token in tokens:
        treasury.whitelistToken(token,{"from":DEPLOYER})
        print(f"Whitelisted {token}")

    
def deployPools(factory):
    for x in range (1,len(tokens)):
        print(tokens[x])
        print(feedAddress[x])
        factory.deployTokenPool(tokens[x],feedAddress[x],CONCENTRATION[x],18, {"from":DEPLOYER})

def main():
    deploy_all(front_end_update=True)
    print("Deployment complete!")

def update_front_end():
    # Send the build folder
    copy_folders_to_front_end("./build", "./frontend/src/chain-info")

    # Sending the front end our config in JSON format
    with open("brownie-config.yaml", "r") as brownie_config:
        config_dict = yaml.load(brownie_config, Loader=yaml.FullLoader)
        with open("./frontend/src/brownie-config.json", "w") as brownie_config_json:
            json.dump(config_dict, brownie_config_json)
    print("Front end updated!")


def copy_folders_to_front_end(src, dest):
    if os.path.exists(dest):
        shutil.rmtree(dest)
    shutil.copytree(src, dest)
