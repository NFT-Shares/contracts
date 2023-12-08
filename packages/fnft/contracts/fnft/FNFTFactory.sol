// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./collection/FNFTCollection.sol";
import "./single/FNFT.sol";

contract FNFTFactory {

  function createSingle(ERC721 token, uint256 tokenId, string memory name, string memory symbol, uint256 totalSupply) public returns (address) {
    ERC20 fnft = new FNFT(
      token,
      tokenId,
      name,
      symbol,
      msg.sender,
      totalSupply
    );
    return address(fnft);
  }

  function createCollection(string memory name, string memory symbol, uint256 totalSupply) public returns (address) {
    FNFTCollection fnft = new FNFTCollection(
      name,
      symbol,
      msg.sender,
      totalSupply
    );
    return address(fnft);
  }
}