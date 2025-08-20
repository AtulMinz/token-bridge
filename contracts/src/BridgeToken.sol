// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeToken is Ownable {

    error Bridge___Insufficient_Allowance();
    error Bridge___Transaction_Failed();

    event Bridge(IERC20, uint256, address);
    event Redeem(IERC20, address, uint256);

    constructor() Ownable(_msgSender()) {}

    uint256 public nonce;

    function bridge(IERC20 _tokenAddress, uint256 _amount) external {
        require(_tokenAddress.allowance(_msgSender(), address(this)) >= _amount, Bridge___Insufficient_Allowance());

        require(_tokenAddress.transferFrom(_msgSender(), address(this), _amount), Bridge___Transaction_Failed());

        emit Bridge(_tokenAddress, _amount, _msgSender());
    }

    function redeem(IERC20 _tokenAddress, address _to, uint256 _amount, uint256 _nonce) external onlyOwner {
        require(_nonce == nonce + 1, "Invalid nonce");
        require(_tokenAddress.transfer(_to, _amount), Bridge___Transaction_Failed());

        nonce = nonce + 1;
        emit Redeem(_tokenAddress, _to, _amount);
    }
}

