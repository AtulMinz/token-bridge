// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MockToken is ERC20, Ownable {

    constructor () ERC20 ("MockToken", "MT") Ownable (msg.sender) {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    function mint(address _to, uint256 _amount) external onlyOwner{
        _mint(_to, _amount);
    }

    function transfer(address to, uint256 amount) public override returns(bool) {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        return super.transferFrom(from, to, amount);
    }
}