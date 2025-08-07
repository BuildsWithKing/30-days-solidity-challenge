// SPDX-License-Identifier: MIT

/// @title OptimizedGasSaver.
/// @author Michealking(@BuildsWithKing).
/// @custom security-contact: buildsWithKing@gmail.com
/// @date created: 6th of Aug, 2025.

/**
 * @notice This smart contract demonstrates real-world gas optimization techniques.    .
 */
pragma solidity ^0.8.18;

/// @dev Thrown when a user tries to perform only contract deployer's operation.
error __OPTIMIZEDGASSAVER_UNAUTHORIZED_ACCESS();

/// @dev Thrown when a user tries to re-register.
error __OPTIMIZEDGASSAVER_ALREADY_REGISTERED();

/// @dev Thrown when non-registered users tries to update data.
error __OPTIMIZEDGASSAVER_NOT_A_REGISTERED_USER();

contract OptimizedGasSaver {
    /// @notice Owner's address.
    address immutable i_Owner;

    /// @dev Groups user's data.
    struct Data {
        // User's first name.
        bytes16 firstName;
        // User's middle name.
        bytes16 middleName;
        // User's last name.
        bytes16 lastName;
        // user's age.
        uint8 age;
    }

    /// @dev Maps user's address => Data.
    mapping(address => Data) internal userData;

    /// @dev Maps user's address => bool (true/false).
    mapping(address => bool) internal registeredUser;

    /// @notice Emits Registered.
    /// @param userAddress The user's address.
    /// @param firstName The user's first name.
    /// @param lastName The user's last name.
    event Registered(address indexed userAddress, bytes16 firstName, bytes16 lastName);

    /// @notice Emits Updated.
    /// @param userAddress The user's address.
    /// @param newFirstName The user's first name.
    /// @param newLastName The user's last name.
    event Updated(address indexed userAddress, bytes16 newFirstName, bytes16 newLastName);

    /// @notice Emits Deleted.
    /// @param userAddress The user's address.
    event Deleted(address indexed userAddress);

    /// @notice Sets Contract deployer as owner.
    constructor() {
        i_Owner = msg.sender;
    }

    /// @dev Restricts access to only contract deployer.
    modifier onlyOwner() {
        if (msg.sender != i_Owner) {
            revert __OPTIMIZEDGASSAVER_UNAUTHORIZED_ACCESS();
        }
        _;
    }

    /// @notice Allows users register.
    /// @param _firstName The user's firstName.
    /// @param _middleName The user's middleName.
    /// @param _lastName The user's lastName.
    function register(bytes16 _firstName, bytes16 _middleName, bytes16 _lastName, uint8 _age) external {
        // Prevent user's from re-registering.
        if (registeredUser[msg.sender] == true) {
            revert __OPTIMIZEDGASSAVER_ALREADY_REGISTERED();
        }

        // Store inputs based on struct grouping.
        Data memory data = Data(_firstName, _middleName, _lastName, _age);

        // Store user's data.
        userData[msg.sender] = data;

        // Mark the user as a registered user.
        registeredUser[msg.sender] = true;

        // Emit Event Registered.
        emit Registered(msg.sender, _firstName, _lastName);
    }

    /// @notice Allows users update their data.
    /// @param _newFirstName The user's new firstName.
    /// @param _newMiddleName The user's middleName.
    /// @param _newLastName The user's lastName.
    function update(bytes16 _newFirstName, bytes16 _newMiddleName, bytes16 _newLastName, uint8 _newAge) external {
        // Prevent unregistered user's from updating data.
        if (registeredUser[msg.sender] == false) {
            revert __OPTIMIZEDGASSAVER_NOT_A_REGISTERED_USER();
        }

        // Access caller's data.
        Data storage data = userData[msg.sender];

        // Update caller's data.
        data.firstName = _newFirstName;
        data.middleName = _newMiddleName;
        data.lastName = _newLastName;
        data.age = _newAge;

        // Emit event updated.
        emit Updated(msg.sender, _newFirstName, _newLastName);
    }

    /// @notice deletes user's data.
    function deleteMyData() external {
        // delete caller's data.
        delete userData[msg.sender];

        // Set registered user as false.
        registeredUser[msg.sender] = false;

        // Emit event Deleted.
        emit Deleted(msg.sender);
    }

    /// @notice Returns user's data.
    /// @return user's stored data.
    function getMyData() external view returns (Data memory) {
        return userData[msg.sender];
    }

    /// @notice Returns owner's address.
    /// @return contract deployer's address.
    function getOwner() external view returns (address) {
        return i_Owner;
    }

    /// @notice Returns user's data.
    /// @return user's Data.
    function getUserData(address _userAddress) external view onlyOwner returns (Data memory) {
        return userData[_userAddress];
    }
}
