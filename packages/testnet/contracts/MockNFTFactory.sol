// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./MockNFT.sol";

contract MockNFTFactory {

  function create(string memory name, string memory symbol) public {
    MockNFT nft =  new MockNFT(name, symbol);
    nft.mint(msg.sender);
    nft.mint(msg.sender);
    nft.mint(msg.sender);
    emit NewNFTCreated(address(nft));
  }

  event NewNFTCreated(address nft);
}