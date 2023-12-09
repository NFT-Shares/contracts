// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./collection/FNFTCollection.sol";
import "./single/FNFT.sol";

contract FNFTFactory {

  function createSingle(ERC721 token, uint256 tokenId, string memory name, string memory symbol, uint256 totalSupply) public {
    ERC20 fnft = new FNFT(
      token,
      tokenId,
      name,
      symbol,
      msg.sender,
      totalSupply
    );
    emit CollectionFNFTCreated(address(fnft));
  }

  function createCollection(string memory name, string memory symbol, uint256 totalSupply, ERC721[] memory nft, uint256[] memory ids) public {
    FNFTCollection fnft = new FNFTCollection(
      name,
      symbol,
      msg.sender,
      totalSupply,
      nft,
      ids
    );
    emit SingleFNFTCreated(address(fnft));
  }

  event SingleFNFTCreated(address fnft);
  event CollectionFNFTCreated(address fnft);
}