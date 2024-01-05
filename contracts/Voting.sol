// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract voting {
    address votingAdmin;
    constructor() {
        votingAdmin = msg.sender;
    }
    bool electionStarted;
    bool electionEnded;
    uint candidateId;
    uint public candidateCount;
    uint public voterCount;
    uint public totalVoteCasted;
    struct candidateDetails {
        string name;
        string agenda;
        uint votes;
        address candidateAddress;
    }
    candidateDetails[] private candidates;
    struct voterDetails {
        string name;
        string voterIdProof;
        bool voteDeligated;
        bool voteCasted;
        address voteDelegatedTo;
    }
    mapping(address => bool) candidateAddressRegistered;
    mapping(uint => candidateDetails) candidate;
    mapping(address => voterDetails) voter;
    mapping(string => bool) uniqueVoterIdProof;
    mapping(address => uint) voteCastedTo;
    modifier onlyVotingAdmin(){
        require(votingAdmin == msg.sender,"Only Voting Admin is allowed to perform this action");
        _;
    }
    function addCandidate(string memory _name, string memory _agenda, address _candidateAddress) public onlyVotingAdmin {
        require(!electionStarted, "Cannot add Candidate as election started");
        require(!(candidateAddressRegistered[_candidateAddress]), "Candidate Already Registered");
        candidate[candidateId] =
        candidateDetails(_name,_agenda,0,_candidateAddress);
        candidates.push(candidate[candidateId]);
        candidateId += 1;
        candidateAddressRegistered[_candidateAddress] = true;
        candidateCount += 1;
    }
    function addVoter(address _voterAddress, string memory _name, string memory _voterIdProof) public onlyVotingAdmin {
        require(!uniqueVoterIdProof[_voterIdProof], "Voter with this id proof already registered");
        require(!(bytes(voter[_voterAddress].name).length > 0), "Voter Already Registered");
        require(!electionStarted, "Cannot add Voter as election started");
        voter[_voterAddress] =
        voterDetails(_name,_voterIdProof,false,false,address(0));
        uniqueVoterIdProof[_voterIdProof] = true;
        voterCount += 1;
    }
    function fetchCadidate(uint _candidateId) public view returns(uint id, string memory name, string memory agenda){
        return (_candidateId,candidates[_candidateId].name,candidates[_candidateId].agenda);
    }
    function fetchVoter() public view returns(string memory name, string memory voterIdProof, bool voteDeligated, bool voteCasted, address voteDelegatedTo,string memory votedCandidateName){
        require(bytes(voter[msg.sender].name).length > 0, "You are not a registered voter");
        if (voter[msg.sender].voteCasted) {
            return (voter[msg.sender].name,voter[msg.sender].voterIdProof,voter[msg.sender].voteDeligated,voter[msg.sender].voteCasted,voter[msg.sender].voteDelegatedTo,candidates[voteCastedTo[msg.sender]].name);
        } else {
            return (voter[msg.sender].name,voter[msg.sender].voterIdProof,voter[msg.sender].voteDeligated,voter[msg.sender].voteCasted,voter[msg.sender].voteDelegatedTo," ");
        }
    }
    function startElection() public onlyVotingAdmin {
        electionStarted = true;
    }
    function delegateVote(address _delegatedTo) public {
        require(electionStarted, "Election Not Started");
        require((bytes(voter[msg.sender].name).length > 0), "Voter is not Registered");
        require(!voter[msg.sender].voteCasted, "You have already casted your vote");
        require((bytes(voter[_delegatedTo].name).length > 0), "Voter you are trying to delegate is not Registered");
        voter[msg.sender].voteDelegatedTo = _delegatedTo;
    }
    function castVote(address _voterAddress, uint _candidateId) public {
        require(electionStarted, "Election Not Started");
        if (msg.sender == _voterAddress) {
            require(!voter[_voterAddress].voteCasted, "You have already casted your vote");
        } else {
            require(voter[_voterAddress].voteDelegatedTo == msg.sender, "You are not authorized to vote on this voter's behalf");
        }
        voter[_voterAddress].voteCasted = true;
        candidates[_candidateId].votes += 1;
        voteCastedTo[_voterAddress] = _candidateId;
        totalVoteCasted += 1;
    }
    function stopElection() public onlyVotingAdmin {
        require(electionStarted, "Election Not Started");
        electionEnded = true;
        electionStarted = false;
    }
    function showResults(uint _candidateId) public view returns (string memory name, string memory agenda, uint votes){
        require(electionEnded, "Election has not ended yet");
        return(candidates[_candidateId].name,candidates[_candidateId].agenda,candidates[_candidateId].votes);
    }
    function showWinner() public view returns(uint id,string memory name, uint votes){
        require(electionEnded, "Election has not ended yet");
        uint winningVoteCount = 0;
        string memory winnerName;
        uint winnerCandidateId = 0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].votes > winningVoteCount) {
                winningVoteCount = candidates[p].votes;
                winnerName = candidates[p].name;
                winnerCandidateId = p;
            }
        }
        return (winnerCandidateId,winnerName,winningVoteCount);
    }
    function getCandidateList() public view returns (candidateDetails[] memory){
        return candidates;
    }
}
