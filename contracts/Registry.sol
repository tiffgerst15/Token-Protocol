//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "../interfaces/ITRSY.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/ITokenPool.sol";

contract Registry {
//Variables

address public owner;
address[] public tokenPools;
address public factory; 
mapping (address => address) public tokenToPool;
mapping (address => address) public PoolToToken;
mapping (address => uint256) public PoolToConcentration;
mapping(address => uint256) public poolToConcentrationDifference;
mapping(address => uint256) public poolsToDecreaseConcentration;
uint256 constant PRECISION = 1e6;

//Struct
struct Pool {
    address token;
    address pool;
    uint256 targetConcentration;
    uint256 currentConcentration;
    uint256 USDval;
    uint256 balance;
}
struct Rebalancing {
    address pool;
    uint256 concentrationDifference;
    bool needsWithdraw;
    bool needsDeposit;
}

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

    function setFactory(address _factory) public onlyOwner{
        factory = _factory;
    }
    function addTokenPool(address _tokenPool, address _token) public {
        require(msg.sender == factory, "Only the factory can add token pools");
        tokenPools.push(_tokenPool);
        tokenToPool[_token] = _tokenPool;
        PoolToToken[_tokenPool] = _token;
    }

    function setTargetConcentration(address _pool, uint256 _target)
        external
        onlyOwner
    {
        PoolToConcentration[_pool] = _target;
    }

    function getConcentrationDifference(address pool) view public returns(uint256){
        uint256 total = getTotalAUMinUSD();
        (uint256 poolBalance, uint256 target) = ITokenPool(pool).getPoolValue();            
        uint256 difference = poolBalance*PRECISION/total - target;
        return difference;
    }

    // function getAllConcentrationDifferences() view public returns(uint256[] memory){
    //     uint256[] storage differences;
    //     uint256 len = tokenPools.length;
    //     uint256 total = getTotalAUMinUSD();
    //     for (uint i = 0; i < len;) {
    //         address pool = tokenPools[i];
    //         (uint256 poolBalance, uint256 target) = ITokenPool(pool).getPoolValue();            
    //         uint256 difference = poolBalance*PRECISION/total - target;
    //         differences[i] = difference;
    //         unchecked{++i;}
    //     }
    // }

    function getTotalAUMinUSD() public view returns (uint256) {
        uint256 total = 0;
        uint256 len = tokenPools.length;
        for (uint i = 0; i < len;) {
            address pool = tokenPools[i];  
            (uint256 poolBalance, ) = ITokenPool(pool).getPoolValue();
            total += poolBalance;
            unchecked{++i;}
        }
        return total;
    }

    function createPoolStruct(address _pool) public returns(Pool memory){
        Pool memory newPool;
        newPool.token = PoolToToken[_pool];
        newPool.pool = _pool;
        newPool.currentConcentration = getConcentrationDifference(_pool);
        (newPool.USDval,newPool.targetConcentration) = ITokenPool(_pool).getPoolValue();
        newPool.balance = IERC20(PoolToToken[_pool]).balanceOf(_pool);

    }
    function createAllPoolStructs() public returns (Pool[] memory){
        Pool[] memory pools;
        uint256 len = tokenPools.length;
        for (uint i = 0; i < len;) {
            address pool = tokenPools[i];  
            pools[i] = createPoolStruct(pool);
            unchecked{++i;}
        }
        return pools;
    }
}
