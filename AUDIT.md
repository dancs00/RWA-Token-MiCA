AUDIT.md

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Definiamo errori personalizzati per risparmiare GAS
error NotWhitelisted(address account);

contract RWAAssetToken is ERC20, Ownable {

    // Immutable: risparmio gas in lettura. Una volta impostato non cambia
    string public immutable assetDocumentationURI;
    
    mapping(address => bool) public isWhitelisted;

    event AddressWhitelisted(address indexed user);
    event AddressRemovedFromWhitelist(address indexed user);

    constructor(
        string memory name, 
        string memory symbol, 
        uint256 initialSupply,
        string memory _assetURI
    ) ERC20(name, symbol) Ownable(msg.sender) {
        assetDocumentationURI = _assetURI;
        isWhitelisted[msg.sender] = true;
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function addToWhitelist(address _user) external onlyOwner {
        isWhitelisted[_user] = true;
        emit AddressWhitelisted(_user);
    }

    function removeFromWhitelist(address _user) external onlyOwner {
        isWhitelisted[_user] = false;
        emit AddressRemovedFromWhitelist(_user);
    }

    // Override ottimizzato di _update
    function _update(address from, address to, uint256 value) internal virtual override {
        // Controllo Whitelist con Custom Errors
        if (from != address(0) && !isWhitelisted[from]) revert NotWhitelisted(from);
        if (to != address(0) && !isWhitelisted[to]) revert NotWhitelisted(to);
        
        super._update(from, to, value);
    }
}
