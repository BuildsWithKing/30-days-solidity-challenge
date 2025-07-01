// SPDX-License-Identifier: MIT

/* This smart contract allows user to store, view and update their favorite quotes.
This contract also allows the contract owner to view quote of any user

*/

pragma solidity ^0.8.18; //Solidity version


contract QuoteVault { 

    address private owner; // The owner variable name is assigned to an address, indicating the contract deployer's address.
    uint256 public quoteCount; //This stores the number of quote counts

    //This stores multiple variables, enabling easy access
    struct Quote {
        string author;
        string description;
        uint256 addAt;
    }

    mapping (address => Quote) private userQuotes; //This maps user address to their quotes
    address[] private userAddress; //stores users Address

    constructor () { //This function ensures the message sender is the contract deployer.
        owner = msg.sender;
        }

    modifier onlyOwner () { //The modifier permits the contract deployer access to the function, and denied other parties/users
        require (msg.sender == owner, "Access Denied");
            _;
        }

    //This function allows user store quotes then increment the quoteCount when new users add quotes 
    function storeQuote (string memory _author, string memory _description) public {
        if (bytes(userQuotes[msg.sender].author).length == 0) {
            userAddress.push(msg.sender);
            quoteCount++;
        }
        userQuotes[msg.sender] = Quote(_author, _description, block.timestamp);
    }

    //This function enable user view their quotes
    function myQuote() public view returns (string memory author, string memory description, uint256 timeStamp){
        Quote memory quote = userQuotes[msg.sender];
        return (quote.author, quote.description, quote.addAt);
        }

    //This function allows users edit their quotes and stores the new quote
    function updateQuote(string memory _newAuthor, string memory _newDescription) public {
        userQuotes[msg.sender] = Quote(_newAuthor,_newDescription,block.timestamp);
         }

    //This function deletes users Quote
    function deleteQuote () public {
        delete userQuotes[msg.sender];
        }

    //This function gets the deployer's address
    function getOwner() public view returns (address) {
        return owner;
        }

    //This function allows user view their quote and that of others using address
    function viewQuotes(address _user) public view returns(string memory author, string memory description, uint256 timestamp){
        Quote memory userQuote = userQuotes[_user];
        return (userQuote.author, userQuote.description, userQuote.addAt);
    }

    //This function gets the timeStamp of the provided address
    function retrieveTimeStamp (address _user) public view returns (uint256 blockTimeStamp) {
        Quote memory quote = userQuotes[_user];
        return (quote.addAt);
    }
}