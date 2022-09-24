// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../interfaces/IKlimaRetirementAggregator.sol";
import "../interfaces/IKlimaCarbonRetirements.sol";
import "../interfaces/IERC20.sol";

import "./Offsetter.sol";

contract LiveOffset is Ownable, Offsetter {

    uint private _offsetPerLetter; 
    address private _eventBeneficiaryAddress;
    address private _carbonToken;
    bool private _retireSpecific;
    address private _specificAddress;

    address public immutable KlimaRetirementAggregator;
    address public immutable KlimaCarbonRetirements;

    event LiveOffsetEventUpdate(
        uint _offsetPerLetter,
        address _eventBeneficiaryAddress,
        address _carbonToken,
        bool _retireSpecific,
        address _specificAddress
    );

    event SingleOffsetIndex(
        uint index
    );

    constructor() {

        KlimaRetirementAggregator = 0xEde3bd57a04960E6469B70B4863cE1c9d9363Cb8;
        KlimaCarbonRetirements = 0xac298CD34559B9AcfaedeA8344a977eceff1C0Fd;
        
    }

    function withdrawBalanceOwner() onlyOwner public {

        /* withdraw unused event offsets */
        
        uint balance = IERC20(_carbonToken).balanceOf(address(this));
        IERC20(_carbonToken).transfer(msg.sender, balance);

    }

    function singleOffset(string memory Name, string memory LoveLetter) onlyOffsetter public {

        /* single offset on behalf of the event */
        _executeOffset(Name, LoveLetter);

    }

    function _executeOffset(string memory Name, string memory LoveLetter) private {

        uint balance = IERC20(_carbonToken).balanceOf(address(this));
        uint index;

        require(balance >= _offsetPerLetter, "All offsets allocated for the event have been used!");

        /* Retire through aggregator */
            
        if (_retireSpecific == true) {
            address[] memory specific = new address[](1);
            specific[0] = _specificAddress;
            IKlimaRetirementAggregator(KlimaRetirementAggregator).retireCarbonSpecific(
                _carbonToken, _carbonToken, _offsetPerLetter, true, _eventBeneficiaryAddress, Name, LoveLetter, specific);
        } else {
            IKlimaRetirementAggregator(KlimaRetirementAggregator).retireCarbon(
                _carbonToken, _carbonToken, _offsetPerLetter, true, _eventBeneficiaryAddress, Name, LoveLetter);
        }

        (index,,) = IKlimaCarbonRetirements(KlimaCarbonRetirements).getRetirementTotals(_eventBeneficiaryAddress);

        emit SingleOffsetIndex(index);

    }

    /* Change params */
    function changeEventParams(address CarbonToken, address eventBeneficiaryAddress, 
        uint OffsetPerLetter, bool retireSpecific, address specificAddress) onlyOwner public {

        _offsetPerLetter = OffsetPerLetter;
        _eventBeneficiaryAddress = eventBeneficiaryAddress;
        _carbonToken = CarbonToken;
        _retireSpecific = retireSpecific;
        _specificAddress = specificAddress;

        IERC20(_carbonToken).approve(KlimaRetirementAggregator, type(uint).max);

        emit LiveOffsetEventUpdate(
            _offsetPerLetter,
            _eventBeneficiaryAddress,
            _carbonToken,
            _retireSpecific,
            _specificAddress
        );

    }

    /* called by the frontend to find pledge and display offset amount */
    function getEventData() public view returns (address, uint) {

        return (_eventBeneficiaryAddress, _offsetPerLetter);

    }
    
}