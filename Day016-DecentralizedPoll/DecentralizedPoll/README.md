# 🗳 DecentralizedPoll (Day 16 – 30 Days of Solidity)

A transparent on-chain **voting and polling smart contract** that allows anyone to **create polls**, **vote securely,** and **view public results** with full blockchain transparency. 

---

## ✅ Features

- constructor(): Sets the contract deployer as owner.
- createPoll(string _title, string _description, string[] _options): Creates a new poll (requires at least 2 options).
- updatePoll(uint256 _pollId, string _newTitle, string _newDescription, string[] _newOptions): Allows poll creator to update their poll before voting starts.
- deletePoll(uint256 _pollId): Allows poll creator to delete their poll.
- vote(uint256 _pollId, uint256 _optionIndex): Vote once on an active poll by selecting option index.
- getPollOptions(uint256 _pollId): View options of a poll.
- getAllPolls(): Returns all poll IDs.
- getPollResults(uint256 _pollId): Returns total votes per option.
- getPollCreator(uint256 _pollId): View who created the poll.
- activatePoll(uint256 _pollId): Poll creator activates poll to start voting.
- deactivatePoll(uint256 _pollId): Poll creator ends voting.
- activateContract(): Owner activates the entire contract.
- deactivateContract(): Owner disables all features globally.
- getMyPolls(): Returns all polls created by the caller.
- getCreatorPolls(address _creator): Owner-only access to view any user's polls.
- deletePoll(address _creatorAddress, uint256 _pollId): Owner-only ability to delete another user's poll.

> ⚠ Important:
> - Contract must be activated before use.
> - Each poll must be activated before voting starts.

---

## 🧠 Concepts Practiced

- Custom Errors: Gas-efficient error handling with clear error reasons.
- Structs & Mappings: Efficient data storage per poll with creator verification.
- Modifiers: Protect access to sensitive functions.
- Poll Lifecycle Management: Polls have statuses (Created, Active, Ended).
- Event Emissions: Transparency via PollCreated, Voted, PollActivated, and more.
- Gas Optimization: Optimized deletion using swap-pop method.

---

## 📂 Files

- DecentralizedPoll.sol

---

## 🚀 Why This Matters

In DAO-style projects and decentralized governance, *polling and voting* is essential. This project teaches:
- Transparent voting without intermediaries.
- Access control using *msg.sender*.
- Tracking poll histories directly on-chain.
- Structuring lifecycle logic in Solidity.

---

🗓 *Posted on:* July 23, 2025. 
🛠 *Built between:* July 13th - July 23, 2025. 

---

## ⚙ Example Usage (Remix):

### ✅ Step 1: Deploy Contract
- Compile and deploy on [Remix](https://remix.ethereum.org/).
- Call activateContract() as owner to enable functionality.

### ✅ Step 2: Create a Poll
```solidity
createPoll(
    "Favorite Blockchain?",
    "Vote for the blockchain you love the most.",
    ["Ethereum", "Solana", "BNB Chain"]
)
```
### ✅ Step 3: Activate Poll
```
activatePoll(1) // Assuming pollId = 1
```

### ✅ Step 4: Vote on Poll
```
vote(1, 0) // Vote for first option (Ethereum)
```
### ✅ Step 5: Update Poll (Before Activation)
```
updatePoll(
    1,
    "Updated Blockchain Poll",
    "Choose your favorite L1 blockchain.",
    ["Ethereum", "Solana", "Polygon", "BNB Chain"]
)
```

### ✅ Step 6: View Poll Results
```
getPollResults(1)
```
### ✅ Step 7: End Voting
```
deactivatePoll(1)
```

---

## 🛠 Tools Used

Language: Solidity ^0.8.18

IDE: Remix + Visual Studio Code

Version Control: Git + GitHub (SSH)



---

📄 License

MIT License – Free to use, learn, and build on top of.


---

✍ Author

Built with 🔥 by [@BuildsWithKing](https://github.com/BuildsWithKing)  
Part of the [30 Days of Solidity Challenge](https://github.com/BuildsWithKing/30-days-solidity-challenge)


---

🙏 Please give credit if this inspired your learning journey.

---

✅ Day 16 Completed!