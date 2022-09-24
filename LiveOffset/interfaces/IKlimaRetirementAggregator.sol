
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IKlimaRetirementAggregator {
    function retireCarbon(address _sourceToken,address _poolToken,uint256 _amount,bool _amountInCarbon,address _beneficiaryAddress,string memory _beneficiaryString,string memory _retirementMessage) external;
    function retireCarbonSpecific(address _sourceToken,address _poolToken,uint256 _amount,bool _amountInCarbon,address _beneficiaryAddress,string memory _beneficiaryString,string memory _retirementMessage, address[] memory _carbonList) external;
    function getSourceAmount(address _sourceToken, address _poolToken, uint256 _amount, bool _amountInCarbon) external returns (uint256, uint256);
    function getSourceAmountSpecific(address _sourceToken, address _poolToken, uint256 _amount, bool _amountInCarbon) external returns (uint256, uint256);
}