// To integrate:
// 1. ownerOnly and/or internal (for security)
// 2. Royalties, max supply and mint price
// 3. Ability to change the above
// 4. Ability to change URI

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OathToMeliorism is ERC721URIStorage, Ownable {
    using SafeMath for uint256;
    using SafeMath for uint16;
    using SafeMath for uint8;
    using Counters for Counters.Counter;
    Counters.Counter private currentTokenId;
    Counters.Counter private primaryTokenHolderCounter;
    uint256 public _mintPrice;
    string public collectionInfoURI;
    mapping(uint16 => uint16) public mintLimits;

    // Used for assigning primary NFT
    mapping(address => uint256) public holderPrimaryTokens;
    mapping(uint256 => address) public primaryTokenHolderIndex;
    
    constructor() ERC721("ERC721e", "ENFT") {
        collectionInfoURI = "";
    }

//__________________________________________________________________________________
// Admin Functions - all admin functions begin with two underscores __

    function __mintFree(string memory token_URI) onlyOwner public returns (uint256 token_ID) {
        token_ID = mint(token_URI);

        return token_ID;
    }

    function __setMintPrice(uint256 new_price) onlyOwner public returns (uint256 old_price) {
        old_price = collectionInfoURI;
        _mintPrice = new_price;

        return(old_price);
    }

    function __setTokenURI(uint256 token_ID, string memory token_URI) onlyOwner public returns (string memory old_token_URI) {
        require(_exists(token_ID), "ERROR: Token does not exist");

        old_token_URI = tokenURI(token_ID);
        _setTokenURI(token_ID, token_URI);

        return(old_token_URI);
    }


    // Sets the URI for the collection info JSON.
    function __setContractURI(string memory new_collectionInfoURI) onlyOwner public returns (string memory old_collectionInfoURI) {
        old_collectionInfoURI = collectionInfoURI;
        collectionInfoURI = new_collectionInfoURI;

        return(old_collectionInfoURI);
    }

//__________________________________________________________________________________
// Internal Functions
    function mint(string memory token_URI) internal returns (uint256 token_ID) {
        currentTokenId.increment();
        token_ID = currentTokenId.current();
        _safeMint(msg.sender, token_ID);
        _setTokenURI(token_ID, token_URI);

        // Set as Primary token if the holder has none
        if (getPrimaryTokenID(msg.sender) < 1) {
            setPrimaryTokenID(msg.sender, token_ID);
        }


        return token_ID;
    }

//__________________________________________________________________________________
// Public Functions

    function mintPublic(string memory token_URI) public payable returns (uint256 token_ID) {
        token_ID = mint(token_URI);

        // For payment on mint
        require(msg.value >= _mintPrice, "Less funds were sent than the mint price.");


        return token_ID;
    }

    function getMintPrice () public view returns (uint256) {
        return _mintPrice;
    }

    function setPrimaryTokenID (uint256 token_ID) public {
        require(_ownerOf(token_ID) == msg.sender, "notOwner");
        if (!(getPrimaryTokenID(msg.sender) > 0)) {
            primaryTokenHolderCounter.increment();
            primaryTokenHolderIndex[primaryTokenHolderCounter.current()] = msg.sender;
        }
        holderPrimaryTokens[msg.sender] = token_ID;
    }

    function getPrimaryTokenID (address _userAddress) public view returns (uint256 token_ID) {
        //require(holderPrimaryTokens[_userAddress] > 0, 0);
        token_ID = holderPrimaryTokens[_userAddress];
        return token_ID;
    }
    
    function getPrimaryTokenURI (address _userAddress) public view returns (string memory _tokenURI) {
        //require(getPrimaryTokenID(msg.sender), 0);
        _tokenURI = tokenURI(holderPrimaryTokens[_userAddress]);
        return _tokenURI;
    }

    function getPrimaryHolderCount() public view returns (uint256) {
        return primaryTokenHolderCounter.current();
    }

    function getPrimaryHolderByIndex(uint256 index) public view returns (address) {
        return primaryTokenHolderIndex[index];
    }

    function getAllPrimaryHolders() public view returns (address[] memory) {
        uint256 primaryHolderCount = getPrimaryHolderCount();
        address[] memory primaryHolderAddresses = new address[](primaryHolderCount);
        for (uint i = 1; i <= primaryHolderCount; i++) {
            primaryHolderAddresses[i] = getPrimaryHolderByIndex(i);
        }
        return primaryHolderAddresses;
    }

//__________________________________________________________________________________
// Platform Functions

    // Required for OpenSea to obtain information about the entire collection, such as the profile image and description
    function contractURI() public view returns (string memory) {
        return collectionInfoURI;
    }
}