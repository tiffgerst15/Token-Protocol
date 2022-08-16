//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

contract Registry {
//Variables
address public owner;
address[] public tokenPools;
mapping (address => address) public tokenToPool;
mapping (address => address) public PoolToToken;
mapping (address => uint256) public PoolToConcentration;


//Errors
error Error_Unauthorized();

//Events
event ReservePoolDeployed(
        address indexed poolAddress,
        address tokenAddress
    );

//Modifier
modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Error_Unauthorized();
        }
        _;
    }
//Constructor
    constructor(){
       owner = msg.sender;
    }

    function addTokenPool(address _tokenPool, address _token) public {
        tokenPools.push(_tokenPool);
        tokenToPool[_token] = _tokenPool;
        PoolToToken[_tokenPool] = _token;
    }





}