// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage";
 import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
 import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";

contract MarriageRegistry is AccessControl, ERC721URIStorage  {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Marriage {
        address spouse1;
        address spouse2;
        uint256 timestamp;
        bool isActive;
        bool isApproved;
    }

    mapping(uint256 => Marriage) public marriages;
    uint256 public marriageCount;

    bytes32 public constant MATCHMAKER_ROLE = keccak256("MATCHMAKER_ROLE");

    event MarriageRegistered(uint256 indexed marriageId, address indexed spouse1, address indexed spouse2, uint256 timestamp);
    event MarriageApproved(uint256 indexed marriageId, address indexed matchmaker);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MATCHMAKER_ROLE, msg.sender);
    }

    function registerMarriage(address _spouse1, address _spouse2) public {
        require(_spouse1 != address(0) && _spouse2 != address(0), "Invalid addresses");
        require(_spouse1 != _spouse2, "Cannot marry oneself");

        uint256 marriageId = marriageCount;

        marriages[marriageId] = Marriage({
            spouse1: _spouse1,
            spouse2: _spouse2,
            timestamp: block.timestamp,
            isActive: true,
            isApproved: false
        });

        marriageCount++;

        emit MarriageRegistered(marriageId, _spouse1, _spouse2, block.timestamp);
    }

    function getMarriage(uint256 _marriageId) public view returns (address, address, uint256, bool, bool) {
        Marriage storage marriage = marriages[_marriageId];
        return (marriage.spouse1, marriage.spouse2, marriage.timestamp, marriage.isActive, marriage.isApproved);
    }

    function approveMarriage(uint256 _marriageId) public onlyRole(MATCHMAKER_ROLE) {
        Marriage storage marriage = marriages[_marriageId];
        require(!marriage.isApproved, "Marriage is already approved");

        marriage.isApproved = true;

        emit MarriageApproved(_marriageId, msg.sender);
    }
}
