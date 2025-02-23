// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    address public owner;
    mapping(address => bool) public voters;
    Candidate[] public candidates;
    bool public votingOpen;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    modifier isVotingOpen() {
        require(votingOpen, "Voting is closed.");
        _;
    }

    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({name: candidateNames[i], voteCount: 0}));
        }
        votingOpen = true;
    }

    function vote(uint candidateIndex) external hasNotVoted isVotingOpen {
        require(candidateIndex < candidates.length, "Invalid candidate.");

        voters[msg.sender] = true;
        candidates[candidateIndex].voteCount += 1;
    }

    function endVoting() external onlyOwner {
        votingOpen = false;
    }

    function getWinner() external view returns (string memory winnerName) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winnerName = candidates[i].name;
            }
        }
    }

    function getCandidates() external view returns (string[] memory) {
        string[] memory names = new string[](candidates.length);
        for (uint i = 0; i < candidates.length; i++) {
            names[i] = candidates[i].name;
        }
        return names;
    }
}
