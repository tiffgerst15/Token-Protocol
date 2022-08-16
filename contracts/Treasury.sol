//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "../interfaces/IERC20.sol";
import "../interfaces/ITRSY.sol";
import "./TokenPool.sol";


contract Treasury {

// State Variables
ITRSY public immutable TRSY;
mapping (address => bool) public whitelistedUsers;
mapping (address => bool) public whitelistedTokens;
address public owner;
address public registry;

//Errors
error Error_Unauthorized();
error Error_UserNotWhitelisted();
error Error_TokenNotWhitelisted();

modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Error_Unauthorized();
        }
        _;
    }

constructor(
        address _trsy,
        address _registry
    ) {
    owner = msg.sender;
    registry = _registry;
    TRSY = ITRSY(_trsy);
    }
    
    function whitelistUser(address _user) public onlyOwner {
        whitelistedUsers[_user] =true;
    }
    
    function whitelistToken(address _token) public onlyOwner {
         whitelistedTokens[_token] =true;
    }

    function deposit() public {}

    function withdraw() public {}




}