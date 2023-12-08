// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract Votable is ERC20 {
  uint256 public subjectIdIndex;
  mapping(address => mapping(uint256 => VotingState)) votingState;
  mapping(ERC721 => mapping(uint256 => uint256)) subjectIds;
  uint256[] progressSubjectIds;
  mapping(uint256 => VoteSubject) subjects;

  function getLockedAmount(address voter) public view returns (uint256) {
    uint256 totalAmount = 0;
    for(uint256 i = 0; i < progressSubjectIds.length; i++) {
      VotingState memory state = votingState[voter][progressSubjectIds[i]];
      if(state.amount == 0) {
        continue;
      }
      totalAmount += state.amount;
    }
    return totalAmount;
  }
  
  function vote(ERC721 nft, uint256 tokenId, bool isYes, uint256 votingAmount) public {
    uint256 balance = balanceOf(msg.sender);
    uint256 subjectId = subjectIds[nft][tokenId];
    VoteSubject storage subject = subjects[subjectId];
    uint256 alreadyVotedAmount = votingState[msg.sender][subjectId].amount;
    uint256 lockedAmount = getLockedAmount(msg.sender);
    uint256 maxVotableAmount = balance + lockedAmount;

    require(!subject.isEnded, "Subject is ended");
    require((alreadyVotedAmount + votingAmount) <= maxVotableAmount, "Not enough balance");
    uint256 afterAmount = votingState[msg.sender][subjectId].amount + votingAmount;
    votingState[msg.sender][subjectId].amount = afterAmount;
    
    emit Voted(subjectId, msg.sender, isYes, votingAmount, address(subject.nft), subject.tokenId, subject.action, subject.requester, subject.fractionAmount, subject.yesVoted, subject.noVoted, afterAmount);
  }

  function removeSubjectId(uint256 id) internal {
    bool removed = false;
    for (uint i = 0; i < progressSubjectIds.length; i++){
      if(progressSubjectIds[i] == id) {
        removed = true;
        delete progressSubjectIds[i];
      } else if(removed) {
        progressSubjectIds[i - 1] = progressSubjectIds[i];
      }
    }
    progressSubjectIds.pop();
  }

  function createSubjectId() internal returns (uint256){
      uint256 subjectId = ++subjectIdIndex;
      progressSubjectIds.push(subjectId);
      return subjectId;
  }

  function addSubject(ERC721 nft,
      uint256 tokenId,
      SubjectAction action,
      address minter,
      uint256 mintAmount) internal returns (uint256){

      uint256 subjectId = createSubjectId();
      subjectIds[nft][tokenId] = subjectId;
      subjects[subjectId].nft = nft;
      subjects[subjectId].tokenId = tokenId;
      subjects[subjectId].action = action;
      subjects[subjectId].requester = minter;
      subjects[subjectId].fractionAmount = mintAmount;
      return subjectId;
  }

  function resolveSubject(ERC721 nft, uint256 tokenId) internal returns (VoteSubject memory){
    uint256 subjectId = subjectIds[nft][tokenId];
    VoteSubject storage subject = subjects[subjectId];
    require(subject.yesVoted >= (totalSupply() / 2), "Not enough votes");
    subject.isEnded = true;
    removeSubjectId(subjectId);
    return subject;
  }

  event MintRequested(
    uint256 subjectId,
    ERC721 nft,
    uint256 tokenId, 
    address minter,
    uint256 mintAmount
  );

  event RedeemRequested(
    uint256 subjectId,
    ERC721 nft,
    uint256 tokenId, 
    address minter,
    uint256 mintAmount
  );

  event Voted(
    uint256 subjectId,
    address voter,
    bool isYes,
    uint256 amount,
    address nft,
    uint256 tokenId, 
    SubjectAction action,
    address minter,
    uint256 mintAmount,
    uint256 yesVoted,
    uint256 noVoted,
    uint256 totalVotedOfVoter);
}

struct VotingState {
  uint256 amount;
}

struct VoteSubject {
  ERC721 nft;
  uint256 tokenId;
  SubjectAction action;
  address requester;
  uint256 fractionAmount;
  uint256 yesVoted;
  uint256 noVoted;
  bool isEnded;
}

enum SubjectAction {
    MINT,
    REDEEM
}
