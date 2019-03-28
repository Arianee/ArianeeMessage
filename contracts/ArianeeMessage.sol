pragma solidity 0.5.1;


contract ArianeeWhitelist{
    function isAuthorized(uint256 _tokenId, address _sender, address _tokenOwner) public view returns(bool);
}

contract ERC721Interface {
    function ownerOf(uint256 _tokenId) public view returns(address);
}


contract ArianeeMessage{
    
    mapping(uint256 => Message[]) public messageList;
    
    ArianeeWhitelist whitelist;
    ERC721Interface smartAsset;
    address arianeeStoreAddress;
    
    struct Message{
        string URI;
        bytes32 imprint;
        address sender;
        address to;
    }
    
    constructor(address _whitelistAddress, address _smartAssetAddress, address _arianeeStoreAddress) public{
        whitelist = ArianeeWhitelist(address(_whitelistAddress));
        smartAsset = ERC721Interface(address(_smartAssetAddress));
        arianeeStoreAddress = _arianeeStoreAddress;
    }
    
    modifier canSendMessage(uint256 _tokenId, address _sender){
        address _owner = smartAsset.ownerOf(_tokenId);
        require(whitelist.isAuthorized(_tokenId, _sender, _owner));
        _;
    }
    
    modifier onlyStore(){
        require(msg.sender == arianeeStoreAddress);
        _;
    }
    /**
     * @dev Send a message
     * @notice can only be called by an whitelisted address and through the store
     * @param _tokenId token associate to the message
     * @param _uri URI of the message
     * @param _imprint of the message
     * @param _to receiver of the message
     */
    function sendMessage(uint256 _tokenId, string memory _uri, bytes32 _imprint, address _to) public canSendMessage(_tokenId, tx.origin) onlyStore() returns(uint256){
        Message memory _message = Message({
            URI : _uri,
            imprint : _imprint,
            sender : tx.origin,
            to : _to
        });
        
        return messageList[_tokenId].push(_message);
    }
    
    
}