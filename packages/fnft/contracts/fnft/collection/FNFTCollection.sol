// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import './Votable.sol';

contract FNFTCollection is ERC20, Votable {
  ERC721[] public nfts;
  mapping(ERC721 => uint256[]) tokenIds;
  address public minter;

  constructor(
    string memory name,
    string memory symbol,
    address _minter,
    uint256 totalSupply
  ) ERC20(name, symbol) {
    minter = _minter;
    _mint(_minter, totalSupply);
  }

  function tryMint(ERC721 nft, uint256 tokenId, uint256 mintAmount) public {
      nft.transferFrom(msg.sender, address(this), tokenId);
      uint256 subjectId = addSubject(nft, tokenId, SubjectAction.MINT, minter, mintAmount);
      emit MintRequested(subjectId, nft, tokenId, msg.sender, mintAmount);
  }

  function executeMint(ERC721 nft, uint256 tokenId) public {
    VoteSubject memory subject = resolveSubject(nft, tokenId);
    _mint(subject.requester, subject.fractionAmount);
  }

  function tryRedeem(ERC721 nft, uint256 tokenId, uint256 payAmount) public {
    transferFrom(msg.sender, address(this), payAmount);
    uint256 subjectId = addSubject(nft, tokenId, SubjectAction.REDEEM, minter, payAmount);
    emit RedeemRequested(subjectId, nft, tokenId, msg.sender, payAmount);
  }

  function executeRedeem(ERC721 nft, uint256 tokenId) public {
    VoteSubject memory subject = resolveSubject(nft, tokenId);
    _burn(address(this), subject.fractionAmount);
    nft.transferFrom(address(this), msg.sender, tokenId);
  }
}