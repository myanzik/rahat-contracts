//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

//ERC1155 Tokens
import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol';
//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.3/contracts/token/ERC1155/extensions/ERC1155Pausable.sol';

//Utils
import "@openzeppelin/contracts/utils/Counters.sol";
import '@openzeppelin/contracts/access/AccessControl.sol';
import "@openzeppelin/contracts/utils/Strings.sol";

contract RahatERC1155 is ERC1155,ERC1155Supply,ERC1155Burnable{
    
    using Counters for Counters.Counter;
    using Strings for uint256;
    
    Counters.Counter private _itemIds; // tracks the token ids
    
	mapping(address => bool) public owner;
	mapping(uint256 => string) public name;
	mapping(uint256 => string) public symbol;

	modifier OnlyOwner {
		require(owner[tx.origin], 'Only Admin can execute this transaction');
		_;
	}

	constructor(address _admin) ERC1155("https://game.example/api/item/{id}.json") {
		owner[_admin] = true;
	}
	

	
	function mintItem(	string memory _name,
		string memory _symbol,uint256 _amount) public returns (uint256) {
	   _itemIds.increment();
	   uint256 newItemId = _itemIds.current();
	   name[newItemId] = _name;
	   symbol[newItemId] = _symbol;
	    _mint(msg.sender, newItemId, _amount, "");
	    
	    return newItemId;
	}
	
	function setBaseURI(string memory newuri) public OnlyOwner {
        _setURI(newuri);
    }
    
    function exists(uint256 _id) public view override returns(bool){
         return(_itemIds.current() >= _id);
    }

	
	function mintItem(uint256 _id,uint256 _amount) public {
	    require(exists(_id),"token with given id doesn't exists");
	    _mint(msg.sender, _id, _amount, "");
	}
	
	function getTokenData(uint256 _tokenId) public view returns(string memory){
	    return _toFullURI(uri(_tokenId),_tokenId);
	}
	
    function _toFullURI(string memory _baseUri, uint256 _tokenId)
        internal
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    _baseUri,
                    "/",
                    _tokenId.toString(),
                    ".json"
                )
            );
    }
	

    function _mint(address account, uint256 id, uint256 amount, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._mint(account,id,amount,data);
    }
    function _mintBatch(address account, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._mintBatch(account,ids,amounts,data);
    }
    function _burn(address account, uint256 id, uint256 amount)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._burn(account,id,amount);
    }
    function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._burnBatch(account,ids,amounts);
    }
}
