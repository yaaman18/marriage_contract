// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

interface IERC5192 {
    event Locked(uint256 tokenId);
    // event Unlocked(uint256 tokenId);
    function locked(uint256 tokenId) external view returns (bool);
}

contract MarriageRegistry is AccessControl, ERC721,ERC721Burnable,IERC5192 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(uint256 => bool) private _locked;

    constructor() ERC721("MarriageRegistry", "MARRIAGE") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MATCHMAKER_ROLE, msg.sender);
    }

    struct Marriage {
        address spouse1;
        address spouse2;
        uint8 spouse1Age;
        uint8 spouse2Age;
        string spouse1Gender;
        string spouse2Gender;
        uint256 timestamp;
        address matchmaker;
    }

    bytes32 public constant MATCHMAKER_ROLE = keccak256("MATCHMAKER_ROLE");

    mapping(uint256 => Marriage) public marriages;

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
    return super.supportsInterface(interfaceId);
    }

    function mintAndLockMarriageNFTs(uint256 _marriageId, address _spouse1, address _spouse2, uint8 _spouse1Age, uint8 _spouse2Age, string memory _spouse1Gender, string memory _spouse2Gender ) public onlyRole(MATCHMAKER_ROLE) {
        _tokenIds.increment();
        uint256 tokenId1 = _tokenIds.current();

        _tokenIds.increment();
        uint256 tokenId2 = _tokenIds.current();

        Marriage memory marriage = Marriage(_spouse1, _spouse2, _spouse1Age, _spouse2Age, _spouse1Gender, _spouse2Gender, block.timestamp, msg.sender);
        marriages[_marriageId] = marriage;

        _safeMint(_spouse1, tokenId1);
        _locked[tokenId1] = true;
        emit Locked(tokenId1);

        _safeMint(_spouse2, tokenId2);
        _locked[tokenId2] = true;
        emit Locked(tokenId2);


        grantRole(MATCHMAKER_ROLE, _spouse1);
        grantRole(MATCHMAKER_ROLE, _spouse2);
    }

    function locked(uint256 tokenId) public view override returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        return _locked[tokenId];
    }

}
