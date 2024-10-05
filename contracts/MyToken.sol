// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@4.8.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.8.0/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 public constant maxSupply = 10000;
    uint256 public totalSupply;
    bool public saleIsActive = false;

    constructor(address initialOwner)
        ERC721("Treasures from an artificial wreck", "TFAW")
        Ownable()
    {
        transferOwnership(initialOwner);
    }

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        require(saleIsActive, "Sale is not active");
        require(totalSupply < maxSupply, "Max supply reached");
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        totalSupply += 1;
    }

    function toggleSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function _burn(uint256 tokenId)
        internal
        virtual
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
        totalSupply -= 1;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
