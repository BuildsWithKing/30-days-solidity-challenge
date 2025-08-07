// SPDX-License-Identifier: MIT

/// @title OptimizedGasSaverTest.  
/// @author Michealking(@BuildsWithKing).
/// @custom security-contact: buildsWithKing@gmail.com
/// @date created: 7th of Aug, 2025. 

pragma solidity ^0.8.18;

import{Test} from "forge-std/Test.sol";
import{OptimizedGasSaver} from "../src/OptimizedGasSaver.sol";

contract OptimizedGasSaverTest is Test {

    OptimizedGasSaver optimizedGasSaver;

    /// @notice owner's address
    address owner = address(this);

    /// @notice user one's address
    address user1 = address(0x1);

    /// @notice user two's address.
    address user2 = address(0x1);

    /// @notice This is the setUp function that runs every other test. 
    function setUp() public {

        // Create new instance of OptimizedGasSaver.
        optimizedGasSaver = new OptimizedGasSaver();

        // Label owner as Owner. 
        vm.label(owner, "Owner");

        // Label user1 as User1. 
        vm.label(user1, "User1");

        // Label user2 as User2. 
        vm.label(user2, "User2");
    }

    /// @notice Test to check if constructor sets owner. 
    function testConstructorSetsOwner() public {

        // Ensure contract owner is same as owner. 
        assertEq(optimizedGasSaver.getOwner(), owner);
    }

    /// @notice Test for register. 
    function testRegister() public {

        //Register User1.  
        vm.prank(user1); 
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);
    }

    /// @notice Test to prevent duplicate registration.
    function testToPreventDuplicateRegistration() public {

        //Register User1.  
        vm.prank(user1); 
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);

         // Prevent user1 from re-registering. 
        vm.expectRevert();

        //Register User1. 
        vm.prank(user1);
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);

    }

    /// @notice Test for Update. 
    function testUpdateMyData() public {

        //Register User1. 
        vm.prank(user1); 
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);

        // Update user1's Data
        vm.prank(user1); 
        optimizedGasSaver.update("Solidity", "King", "BuildsWithKing", 25);

        // Read as user1
        vm.prank(user1);
        OptimizedGasSaver.Data memory data = optimizedGasSaver.getMyData();

        // Assert updated values
        assertEq(data.firstName, "Solidity");
        assertEq(data.middleName, "King");
        assertEq(data.lastName, "BuildsWithKing");
        assertEq(data.age, 25);
    }

    /// @notice Test for Delete. 
    function testForDeleteMyData() public {

        //Register User1. 
        vm.prank(user1); 
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);

        // Delete user1 data. 
        vm.prank(user1);
        optimizedGasSaver.deleteMyData();

        // Read as user1
        vm.prank(user1);
        OptimizedGasSaver.Data memory data = optimizedGasSaver.getMyData();

        // Assert user data
        assertEq(data.firstName, 0);
        assertEq(data.middleName, 0);
        assertEq(data.lastName, 0);
        assertEq(data.age, 0);
    }

    /// @notice Test for get my data. 
    function testGetMyData()  public {

        //Register User1. 
        vm.prank(user1); 
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);

        // Read as user1
        vm.prank(user1);
        OptimizedGasSaver.Data memory data = optimizedGasSaver.getMyData();

        // Assert user1's data
        assertEq(data.firstName, "Micheal");
        assertEq(data.middleName, "King");
        assertEq(data.lastName, "BuildsWithKing");
        assertEq(data.age, 23);
    }

    /// @notice Test for get user data.
    function testOnlyOwnerCanGetUsersData() public {
        //Register User1. 
        vm.prank(user1); 
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);

        // Read user1's Data
        vm.prank(owner);

        OptimizedGasSaver.Data memory data = optimizedGasSaver.getUserData(user1);

        // Assert user1's data
        assertEq(data.firstName, "Micheal");
        assertEq(data.middleName, "King");
        assertEq(data.lastName, "BuildsWithKing");
        assertEq(data.age, 23);

    }

    function testUsersCantAccessOtherUsersData() public {
        //Register User1. 
        vm.prank(user1); 
        optimizedGasSaver.register("Micheal", "King", "BuildsWithKing", 23);

        vm.expectRevert();

        // Read user1's Data
        vm.prank(user2);
        optimizedGasSaver.getUserData(user1);
    }

    /// @notice Test for get Owner. 
    function testGetOwner() public {
        address contractOwner = optimizedGasSaver.getOwner();
       
        // Assert owner.
        assertEq(contractOwner, owner);
    }
}