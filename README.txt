Overview
Voting Smart Contract is built on the Ethereum blockchain. This Contract enables the Voting Admin(Address from which the contract is deployed) to register candidates and voters. This contract also lets voting admin to start, stop the election and show the election results. Voter also has the option to delegate the voting to someone else. 

Structure
- Constructor
Contract has a constructor to store the address form which the contract is being deployed.
- Structs
The contract has two structs such as voterDetails for voter details, candidateDetails for candidate details.
- Mapping
Contract has 5 mappings for efficient retrieval and manipulation of data.
- State Variables
Contract has boolean and unsigned type interger.
- Modifier
Contract has a modifier which checks if the address from which the contract is being called is of Voting admin or not.

Functions
- Add Candidate
- Add Voter
- Fetch Candidate
- Fetch Voter
- Start Election
- Delegate Voting Right
- Cast Vote
- End Election
- Show Results
- Show Winner
- Get Candidate List
