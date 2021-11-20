// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.2.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.2.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract TestRings is ERC721Enumerable, Ownable {

    using Strings for uint256;

    string _baseTokenURI;
    uint256 private _price = 0.10 ether;
    bool public _paused = true;


    constructor() ERC721("CryptoRings", "CRINGS")  {
        _baseTokenURI = "https://cr-test.vercel.app/api/";
        for (uint256 i = 0; i < 25; i++) {
            _safeMint(msg.sender, i);
        }

    }

    function mint(uint256 num) public payable {
        uint256 supply = totalSupply();
        require( !_paused, "Sale is paused");
        require( num < 11, "You can only mint 10 rings");
        require( supply + num < 6001, "Exceeds maximum ring supply");
        require( msg.value >= _price * num, "Ether sent is not correct" );

        for(uint256 i; i < num; i++){
            _safeMint(msg.sender, supply + i );
        }
    }

    function setPrice(uint256 _newPrice) public onlyOwner() {
        _price = _newPrice;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
    
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getPrice() public view returns (uint256){
        return _price;
    }


    function pause(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public payable onlyOwner {
        uint256 bal = address(this).balance;
        require(payable(msg.sender).send(bal));
    }
}