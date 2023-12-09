// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockNFT is ERC721 {
  uint256 tokenIdIdx = 0;

  constructor(string memory name, string memory symbol) ERC721(name, symbol) {
  }

  function mint(address to) public {
    uint256 id = tokenIdIdx++;
    _mint(to, id);
    emit NewTokenMinted(id);
  }

  function transferFrom(address from, address to, uint256 tokenId) public virtual override {
      _transfer(from, to, tokenId);
  }

  function _baseURI() internal override pure returns (string memory) {
    return "https://api.nft-shares/nft/metadata/";
  }

  event NewTokenMinted(uint256 tokenId);

}