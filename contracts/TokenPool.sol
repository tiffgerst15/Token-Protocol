//SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "../interfaces/AggregatorV3Interface.sol";
import "../interfaces/ITRSY.sol";

contract TokenPool{
ITRSY public token;
address public chainlinkfeed;
uint256 public targetconcentration;
AggregatorV3Interface public oracle;

constructor (address _tokenAddress, address _chainlinkfeed, uint256 _targetconcentration)  {
    token = ITRSY(_tokenAddress);
    chainlinkfeed = _chainlinkfeed;
    oracle = AggregatorV3Interface(_chainlinkfeed);
    targetconcentration = _targetconcentration;
}
function getPrice() public view returns (uint256){
    (,int256 price, , , ) = oracle.latestRoundData();
    return uint256(price) * 10**10;
}

function getPoolValue() external view returns(uint256, uint256){
    uint256 price = getPrice();
    return ((token.balanceOf(address(this)) * price)/10**18, targetconcentration);
}

function getDepositValue(uint256 _amount) external view returns(uint256, uint256){
    uint256 price = getPrice();
    return (_amount * price / 10**18, targetconcentration);
}

}





