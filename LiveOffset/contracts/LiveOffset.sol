// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../interfaces/IKlimaRetirementAggregator.sol";
import "../interfaces/IERC20.sol";

import "./Offsetter.sol";

contract LiveOffset is Ownable, Offsetter {

    uint private _offsetPerLetter; 
    address private _eventBeneficiaryAddress;
    address private _carbonToken;
    bool private _retireSpecific;
    address private _specificAddress;

    address public immutable KlimaRetirementAggregator;

    event LiveOffsetEventUpdate(
        uint _offsetPerLetter,
        address _eventBeneficiaryAddress,
        address _carbonToken,
        bool _retireSpecific,
        address _specificAddress
    );

    constructor() {

        KlimaRetirementAggregator = 0xEde3bd57a04960E6469B70B4863cE1c9d9363Cb8;
        
    }

    function withdrawBalanceOwner() onlyOwner public {

        /* withdraw unused event offsets */
        
        uint balance = IERC20(_carbonToken).balanceOf(address(this));
        IERC20(_carbonToken).transfer(msg.sender, balance);

    }

    function singleOffset(string memory Name, string memory LoveLetter) onlyOffsetter public {

        /* single offset on behalf of the event */
        _executeOffset(_offsetPerLetter, Name, LoveLetter);

    }

    function _executeOffset(uint amount, string memory Name, string memory LoveLetter) private {

        uint balance = IERC20(_carbonToken).balanceOf(address(this));

        require(balance >= amount, "All offsets allocated for the event have been used!");

        /* Retire through aggregator */
            
        if (_retireSpecific == true) {
            address[] memory specific = new address[](1);
            specific[0] = _specificAddress;
            IKlimaRetirementAggregator(KlimaRetirementAggregator).retireCarbonSpecific(
                _carbonToken, _carbonToken, amount, false, _eventBeneficiaryAddress, Name, LoveLetter, specific);
        } else {
            IKlimaRetirementAggregator(KlimaRetirementAggregator).retireCarbon(
                _carbonToken, _carbonToken, amount, false, _eventBeneficiaryAddress, Name, LoveLetter);
        }

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
    

}