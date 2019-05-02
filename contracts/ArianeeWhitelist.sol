pragma solidity 0.5.1;

import "@0xcert/ethereum-utils-contracts/src/contracts/permission/abilitable.sol";

contract ArianeeWhitelist is
Abilitable{
    
    mapping(uint256=> mapping(address=>bool)) internal whitelistedAddress;
    mapping(address=> mapping(uint256=> mapping(address=>bool))) internal optOutAddressPerOwner;
    
    uint8 constant ABILITY_ADD_WHITELIST = 2;
    
    /**
     * @dev This emits when a new address is whitelisted for a token
     */
    event WhitelistedAddressAdded(uint256 _tokenId, address _address);
    
    /**
     * @dev This emits when an address is blacklisted by a NFT owner on a given token.
     */
    event BlacklistedAddresAdded(address _sender, uint256 _tokenId, bool _activate);
    
    function isAuthorized(uint256 _tokenId, address _sender, address _tokenOwner) public view returns(bool){
        return (whitelistedAddress[_tokenId][_sender] && !(optOutAddressPerOwner[_tokenOwner][_tokenId][_sender]));
    }
    
    /**
     * @dev add an address to the whitelist for a nft.
     * @notice can only be called by contract authorized.
     * @param _tokenId id of the nft
     * @param _address address to whitelist.
     */
    function addWhitelistedAddress(uint256 _tokenId, address _address) public hasAbility(ABILITY_ADD_WHITELIST){
        whitelistedAddress[_tokenId][_address] = true;
        emit WhitelistedAddressAdded(_tokenId, _address);
    }
    
    /**
     * @dev blacklist an address by a receiver.
     * @param _sender address to blacklist.
     * @param _activate blacklist or unblacklist the sender
     */
    function addBlacklistedAddress(address _sender, uint256 _tokenId, bool _activate) public{
        optOutAddressPerOwner[msg.sender][_tokenId][_sender] = _activate;
        emit BlacklistedAddresAdded(_sender, _tokenId, _activate);
    }
    
    function isWhitelisted(uint256 _tokenId, address _address) external view returns (bool _isWhitelisted){
        _isWhitelisted = whitelistedAddress[_tokenId][_address];
    }
    
    function isBlacklisted(address _owner, address _sender, uint256 _tokenId) external view returns(bool _isBlacklisted){
        _isBlacklisted = optOutAddressPerOwner[_owner][_tokenId][_sender];
    }
    
}