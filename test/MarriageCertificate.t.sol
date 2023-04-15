// SPDX-License-Identifier: Copyright (c) 2023 Mitsuyuki Yamaguchi
pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "../src/MarriageCertificate.sol";

// contract MarriageRegistryTest is Test {
//     MarriageRegistry marriageRegistry;
//     address admin;

//     function setUp() public {
//         admin = msg.sender;
//         marriageRegistry = new MarriageRegistry();
//     }

//     function test_RegisterMarriage() public {
//         address spouse1 = address(0x1);
//         address spouse2 = address(0x2);

//         marriageRegistry.grantMatchmakerRole(admin);

//         uint256 marriageId = marriageRegistry.marriageCount();

//         marriageRegistry.registerMarriage(spouse1, spouse2);


//         (bytes4 eventType, uint256 _marriageId, address _spouse1, address _spouse2, uint256 _timestamp) = abi.decode(eventLogs[0], (bytes4, uint256, address, address, uint256));

//         assertEq(eventType, marriageRegistry.MarriageRegistered.selector);
//         assertEq(_marriageId, marriageId);
//         assertEq(_spouse1, spouse1);
//         assertEq(_spouse2, spouse2);

//         (address rSpouse1, address rSpouse2, uint256 rTimestamp, bool rIsActive) = marriageRegistry.getMarriage(marriageId);

//         assertEq(rSpouse1, spouse1);
//         assertEq(rSpouse2, spouse2);
//         assertGt(rTimestamp, 0);
//         assertTrue(rIsActive);
//     }
// }
