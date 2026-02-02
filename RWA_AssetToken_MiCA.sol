/ SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title RWAAssetToken
 * @dev Tokenizzazione di asset fisici (es. Numismatica/Crediti) con Whitelist MiCA-compliant.
 */
contract RWAAssetToken is ERC20, Ownable, ReentrancyGuard {

    // Riferimento all'asset fisico (es. Hash IPFS del certificato o perizia)
    string public assetDocumentationURI;
    
    // Mapping per la Whitelist (KYC/AML richiesto da MiCA per i fornitori di servizi)
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
        // L'owner (emittente) viene solitamente whitelisted di default
        isWhitelisted[msg.sender] = true;
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    // --- FUNZIONI DI COMPLIANCE ---

    /**
     * @dev Aggiunge un indirizzo alla whitelist dopo verifica KYC/AML.
     */
    function addToWhitelist(address _user) external onlyOwner {
        isWhitelisted[_user] = true;
        emit AddressWhitelisted(_user);
    }

    function removeFromWhitelist(address _user) external onlyOwner {
        isWhitelisted[_user] = false;
        emit AddressRemovedFromWhitelist(_user);
    }

    // --- OVERRIDE DEL TRASFERIMENTO ---

    /**
     * @dev Blocca il trasferimento se il mittente o il destinatario non sono whitelisted.
     * Questo garantisce che l'asset circoli solo tra investitori verificati.
     */
    function _update(address from, address to, uint256 value) internal virtual override {
        // Escludiamo il minting (from == address(0)) dai controlli se necessario, 
        // ma per MiCA è meglio che anche il ricevente del mint sia verificato.
        if (from != address(0)) {
            require(isWhitelisted[from], "Mittente non verificato (KYC richiesto)");
        }
        if (to != address(0)) {
            require(isWhitelisted[to], "Destinatario non verificato (KYC richiesto)");
        }
        
        super._update(from, to, value);
    }
}
