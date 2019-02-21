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
    
    struct Message{
        string URI;
        bytes32 imprint;
        address sender;
    }
    
    constructor(address _whitelistAddress, address _smartAssetAddress) public{
        whitelist = ArianeeWhitelist(address(_whitelistAddress));
        smartAsset = ERC721Interface(address(_smartAssetAddress));
    }
    
    modifier canSendMessage(uint256 _tokenId, address _sender){
        address _owner = smartAsset.ownerOf(_tokenId);
        require(whitelist.isAuthorized(_tokenId, _sender, _owner));
        _;
    }
    
    function sendMessage(uint256 _tokenId, string memory _uri, bytes32 _imprint) public canSendMessage(_tokenId, tx.origin){
        Message memory _message = Message({
            URI : _uri,
            imprint : _imprint,
            sender : tx.origin
        });
        
        messageList[_tokenId].push(_message);
    }
    
    
}