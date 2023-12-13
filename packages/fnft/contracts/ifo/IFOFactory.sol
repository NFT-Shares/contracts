// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IFO.sol";

contract IFOFactory {
  mapping(ERC20 => IFO) public ifos;

  function create(ERC20 fnft, uint256 amount, uint256 price) public returns (IFO){
    ifos[fnft] = new IFO(fnft, msg.sender, amount, price);
    fnft.transferFrom(msg.sender, address(ifos[fnft]), amount);
    return ifos[fnft];
  }
}