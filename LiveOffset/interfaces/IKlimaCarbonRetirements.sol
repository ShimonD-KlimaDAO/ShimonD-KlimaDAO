
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IKlimaCarbonRetirements {
    function getRetirementTotals(address _retiree) external returns (uint256, uint256, uint256);
}