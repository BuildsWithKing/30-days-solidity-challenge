// SPDX-License-Identifier: MIT

/// @title UnOptimizedGasSaver.
/// @author Michealking(@BuildsWithKing).
/// @custom security-contact: buildsWithKing@gmail.com
/// @date created: 6th of Aug, 2025.

/**
 * @notice This smart contract lacks real-world gas optimization techniques.    .
 */
pragma solidity ^0.8.18;

contract UnoptimizedGasSaver {
    /// @notice Owner's address.
    address public owner;

    /// @notice Stores users name.
    string public firstName;

    /// @notice Store users middle name.
    string public middleName;

    /// @notice Stores users last name.
    string public lastName;

    /// @notice Stores users age.
    uint256 public age;

    /// @notice Emits RegisteredFirstName.
    /// @param userAddress The user's address.
    /// @param firstName The user's first name.
    event RegisteredFirstName(address indexed userAddress, string firstName);

    /// @notice Emits RegisteredMiddleName.
    /// @param userAddress The user's address.
    /// @param middleName The user's middle name.
    event RegisteredMiddleName(address indexed userAddress, string middleName);

    /// @notice Emits RegisteredLastName.
    /// @param userAddress The user's address.
    /// @param lastName The user's middle name.
    event RegisteredLastName(address indexed userAddress, string lastName);

    /// @notice Emits UserAgeStored.
    /// @param userAddress The user's address.
    /// @param age The user's age.
    event UserAgeStored(address indexed userAddress, uint256 indexed age);

    /// @notice Emits UpdatedFirstName.
    /// @param userAddress The user's address.
    /// @param newFirstName The user's new first name.
    event UpdatedFirstName(address indexed userAddress, string newFirstName);

    /// @notice Emits UpdatedMiddleName.
    /// @param userAddress The user's address.
    /// @param newMiddleName The user's new middle name.
    event UpdatedMiddleName(address indexed userAddress, string newMiddleName);

    /// @notice Emits UpdatedLastName.
    /// @param userAddress The user's address.
    /// @param newLastName The user's new last name.
    event UpdatedLastName(address indexed userAddress, string newLastName);

    /// @notice Emits UpdatedAge.
    /// @param userAddress The user's address.
    /// @param age The user's new age.
    event UpdatedAge(address indexed userAddress, uint256 indexed age);

    /// @notice Emits FirstNameDeleted.
    /// @param userAddress The user's address.
    /// @param firstName The user's deleted first name.
    event FirstNameDeleted(address indexed userAddress, string firstName);

    /// @notice Emits MiddleNameDeleted.
    /// @param userAddress The user's address.
    /// @param middleName The user's deleted middle name.
    event MiddleNameDeleted(address indexed userAddress, string middleName);

    /// @notice Emits LastNameDeleted.
    /// @param userAddress The user's address.
    /// @param lastName The user's deleted first name.
    event LastNameDeleted(address indexed userAddress, string lastName);

    /// @notice Emits AgeDeleted.
    /// @param userAddress The user's address.
    /// @param age The user's deleted age.
    event AgeDeleted(address indexed userAddress, uint256 age);

    /// @notice Sets contract deployer as owner.
    constructor() {
        owner = msg.sender;
    }

    /// @dev Restricts access to only contract deployer.
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized Access");
        _;
    }

    /// @notice Allows users register their first name.
    function registerFirstName(string memory _firstName) public {
        // Prevent users from re-registering.
        require(bytes(firstName).length == 0, "ALREADY A REGISTERED USER");

        // Store user's first Name.
        firstName = _firstName;

        emit RegisteredFirstName(msg.sender, _firstName);
    }

    /// @notice Allows users register their middle name.
    function registerMiddleName(string memory _middleName) public {
        // Prevent users from re-registering.
        require(bytes(middleName).length == 0, "ALREADY A REGISTERED USER");

        // Store user's middle Name.
        middleName = _middleName;

        // Emit Event RegisteredMiddleName.
        emit RegisteredMiddleName(msg.sender, _middleName);
    }

    /// @notice Allows users register their last name.
    function registerLastName(string memory _lastName) public {
        // Prevent users from re-registering.
        require(bytes(lastName).length == 0, "ALREADY A REGISTERED USER");

        // Store user's middle Name.
        lastName = _lastName;

        // Emit Event RegisteredMiddleName.
        emit RegisteredMiddleName(msg.sender, _lastName);
    }

    /// @notice Stores user's age.
    function storeAge(uint256 _age) public {
        // Ensure user age is greater than 0
        require(_age > 0, "AGE CAN'T BE ZERO");

        // Prevent users from re-registering.
        require(age == 0, "ALREADY A REGISTERED USER");

        // store user's age.
        age = _age;

        // Emit event UserAgeStored.
        emit UserAgeStored(msg.sender, _age);
    }

    /// @notice Allows users update their first name.
    function updateFirstName(string memory _newFirstName) public {
        // Prevent non-registered users from updating.
        require(bytes(firstName).length != 0, "NOT A REGISTERED USER");

        // Store user's new first name.
        firstName = _newFirstName;

        // Emits UpdatedFirstName.
        emit UpdatedFirstName(msg.sender, _newFirstName);
    }

    /// @notice Allows users update their middle name.
    function updateMiddleName(string memory _newMiddleName) public {
        // Prevent non-registered users from updating.
        require(bytes(middleName).length != 0, "NOT A REGISTERED USER");

        // Stores user's new middle name.
        middleName = _newMiddleName;

        // Emits event UpdatedMiddleName.
        emit UpdatedMiddleName(msg.sender, _newMiddleName);
    }

    /// @notice Allows users update their last name.
    function updateLastName(string memory _newLastName) public {
        // Prevent non-registered users from updating.
        require(bytes(lastName).length != 0, "NOT A REGISTERED USER");

        // Stores user's new middle name.
        lastName = _newLastName;

        // Emits event UpdatedLastName.
        emit UpdatedLastName(msg.sender, _newLastName);
    }

    /// @notice Allows users update their age.
    function updateAge(uint256 _newAge) public {
        // Prevent non- registered users from updating age.
        require(age != 0, "NOT A REGISTERED USER");

        // Store user's new Age.
        age = _newAge;

        // Emits event UpdatedAge.
        emit UpdatedAge(msg.sender, _newAge);
    }

    /// @notice Deletes user's first name.
    function deleteMyFirstName() public {
        delete firstName;

        // Emits event FirstNameDeleted.
        emit FirstNameDeleted(msg.sender, firstName);
    }

    /// @notice Deletes user's middle name.
    function deleteMyMiddleName() public {
        delete middleName;

        // Emits event MiddleNameDeleted.
        emit MiddleNameDeleted(msg.sender, middleName);
    }

    /// @notice Deletes user's last name.
    function deleteMyLastName() public {
        delete lastName;

        // Emits event LastNameDeleted.
        emit LastNameDeleted(msg.sender, lastName);
    }

    /// @notice Deletes user's age.
    function deleteMyAge() public {
        delete age;

        // Emits event AgeDeleted.
        emit AgeDeleted(msg.sender, age);
    }
}