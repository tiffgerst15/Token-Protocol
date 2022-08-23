// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

interface IRegistry {
    function addTokenPool(address, address) external;

    function tokenToPool(address) external view returns (address);

    function getTotalPoolsAUMinUSD() external view returns (uint256);
    
    function tokensToWithdraw(uint256 _amount) external view returns (address[] memory, uint256[] memory);}