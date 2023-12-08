// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IFO is Ownable {
  ERC20 public fnft;
  uint256 public price;
  bool public isProgress;
  uint256 public sales;

  constructor(ERC20 _fnft, address _owner, uint256 amount, uint256 _price) Ownable(_owner) {
    fnft = _fnft;
    price = _price;
    isProgress = true;
    fnft.transferFrom(_owner, address(this), amount);
  }

  function stop() onlyOwner public {
    isProgress = false;
    fnft.transfer(msg.sender, fnft.balanceOf(address(this)));
    payable(msg.sender).transfer(sales);
  }

  function buy() public payable {
    require(isProgress, "IFO is not progress");
    require(msg.value >= price, "Not enough price");
    uint256 amount = msg.value / price;
    require(amount <= fnft.balanceOf(address(this)), "Not enough balance");
    fnft.transfer(msg.sender, amount);
    sales += msg.value;
  }

}