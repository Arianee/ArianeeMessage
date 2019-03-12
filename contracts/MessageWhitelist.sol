pragma solidity 0.5.1;

contract ArianeeWhitelist{
    
    mapping(uint256=> mapping(address=>bool)) public whitelistedAddress;
    mapping(address=> mapping(address=>bool)) optOutAddressPerOwner;
    
    function isAuthorized(uint256 _tokenId, address _sender, address _tokenOwner) public view returns(bool){
        return (whitelistedAddress[_tokenId][_sender] && !(optOutAddressPerOwner[_tokenOwner][_sender]));
    }
    
    function addWhitelistedAddress(uint256 _tokenId, address _address) public{
        whitelistedAddress[_tokenId][_address] = true;
    }
    
}