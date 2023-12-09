// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FNFT is ERC20 {
  ERC721 public nft;
  uint256 public tokenId;
  address public minter;

  constructor(
    ERC721 _nft,
    uint256 _tokenId,
    string memory name,
    string memory symbol,
    address _minter,
    uint256 totalSupply
  ) ERC20(name, symbol) public {
    nft = _nft;
    tokenId = _tokenId;
    minter = _minter;
    nft.transferFrom(_minter, address(this), _tokenId);
    _mint(_minter, totalSupply);
  }

  function redeem() public {
    require(balanceOf(msg.sender) == totalSupply(), "Not enough balance");
    _burn(msg.sender, totalSupply());
    nft.transferFrom(address(this), msg.sender, tokenId);
  }

}