// SPDX-License-Identifier: MIT
// Based on OpenZepplin's Ownable

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Offsetter is Context, Ownable {
    address private _offsetter;

    event OffsetterTransferred(address indexed previousOffsetter, address indexed newOffsetter);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOffsetter(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOffsetter() {
        _checkOffsetter();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function offsetter() public view virtual returns (address) {
        return _offsetter;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOffsetter() internal view virtual {
        require(offsetter() == _msgSender(), "caller is not the offsetter");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOffsetter() public virtual onlyOwner {
        _transferOffsetter(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOffsetter(address newOffsetter) public virtual onlyOwner {
        require(newOffsetter != address(0), "new offsetter is the zero address");
        _transferOffsetter(newOffsetter);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOffsetter(address newOffsetter) internal virtual {
        address oldOffsetter = _offsetter;
        _offsetter = newOffsetter;
        emit OffsetterTransferred(oldOffsetter, newOffsetter);
    }
}