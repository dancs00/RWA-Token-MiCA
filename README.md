# RWA-Token-MiCA

Wallet: 0x65Ebb74DccABb7Fb9cAC48C68DF67b19662A20d2

Transaction 0x468a998093adeEe73dE247844dda9dA9c1aAA361

Network: Ethereum Sepolia Testnet

Erc20: ENumi (NUMI)



# English Version

# 1. Compliance and Institutional Protection (Whitelist & MiCA)
The protocol integrates a native Whitelist function, an essential element for compliance with the MiCA (Markets in Crypto-Assets) regulation. Unlike standard tokens, the transfer of our assets is subject to on-chain identity verification. For institutional investors, this mitigates counterparty risks associated with unidentified or sanctioned wallets. Every transaction occurs exclusively between addresses that have cleared rigorous KYC (Know Your Customer) and AML (Anti-Money Laundering) processes, ensuring a "permissioned" trading environment that safeguards both the fund's integrity and the participants' reputations.

# 2. Liquidity and Fractionability (The Efficiency of 18 Decimals)
High-end numismatics are historically illiquid assets due to the high unit value of individual pieces. Adopting the ERC-20 standard with 18 decimals allows the ownership of the asset to be split into infinitesimal units. This granularity transforms an indivisible good into a fluid financial product, enabling investors to calibrate their portfolio exposure with pinpoint accuracy and access secondary markets 24/7. Fractionability lowers entry barriers, expanding the potential buyer base and ensuring a faster "exit strategy" compared to the sale of the entire physical set.

# 3. Transparency and Underlying Asset Certainty (AssetDocumentationURI)
The AssetDocumentationURI parameter acts as an immutable anchor between the digital token and the physical asset. It points to cryptographic documentation (stored on IPFS) that includes appraisals, certificates of authenticity, and historical provenance data. This architecture guarantees absolute transparency: investors can verify the underlying value of their digital title at any time, eliminating the information asymmetries typical of collectibles markets and consolidating trust in the stability of the fund's value.

The contract was tested on Remix IDE simulating a MiCA-compliant environment



# RWA-Token-MiCA Audit.md

1. Vulnerability Analysis
Reentrancy & Arithmetic Overflows: The contract was analyzed for common exploits. Given the use of Solidity ^0.8.20, arithmetic overflows are natively prevented by the compiler. While a ReentrancyGuard was initially considered, it was deemed redundant for this specific ERC-20 implementation as it does not perform external low-level calls, thus reducing unnecessary gas overhead.

Access Control & Governance: Access is strictly managed via OpenZeppelin’s Ownable module. The onlyOwner modifier ensures that sensitive operations, such as whitelist management, are restricted. For institutional deployment, it is recommended to transition the Owner address to a Multi-Signature wallet (e.g., Gnosis Safe) to mitigate "Single Point of Failure" risks.

2. Compliance Logic Evaluation (MiCA Framework)
Whitelist Integrity: The compliance logic is enforced through a mandatory "bottleneck" in the _update function. This ensures that no token transfers, minting, or burning can occur unless both the sender and the recipient have cleared KYC/AML verification.

Regulatory Resilience: The architecture prevents unauthorized secondary market circulation, aligning with MiCA requirements for Asset-Referenced Tokens (ARTs) and CasPs. Future iterations may include a "Force Transfer" function to comply with legal recovery orders or lost access scenarios.

3. Gas Optimization & Economic Efficiency
Custom Errors: Replaced traditional require strings with Custom Errors (e.g., error NotWhitelisted()). This significantly reduces the contract's bytecode size and lowers gas costs for failed transactions.

Variable Optimization: Shifted the assetDocumentationURI to an immutable state. Since this reference to the physical underlying asset does not change after deployment, defining it as immutable optimizes gas consumption for every on-chain read operation.







# Versione Italiana

# 1. Compliance e Protezione Istituzionale (Whitelist & MiCA)
Il protocollo integra una funzione nativa di Whitelist, elemento imprescindibile per la conformità al regolamento MiCA (Markets in Crypto-Assets). A differenza dei token standard, il trasferimento del nostro asset è subordinato a un controllo di identità on-chain. Per gli investitori istituzionali, questo elimina il rischio di controparte legato a portafogli non identificati o sanzionati. Ogni transazione avviene esclusivamente tra indirizzi che hanno superato rigorosi processi di KYC (Know Your Customer) e AML (Anti-Money Laundering), garantendo un ambiente di trading "permissioned" che tutela l'integrità del fondo e la reputazione dei partecipanti.

# 2. Liquidità e Frazionabilità (Efficienza dei 18 Decimali)
La numismatica di alto pregio è storicamente un asset illiquido a causa dell'elevato valore unitario dei singoli pezzi. L’adozione dello standard ERC-20 con 18 decimali permette di scindere la proprietà dell'asset in unità infinitesimali. Questa granularità trasforma un bene indivisibile in un prodotto finanziario fluido, consentendo agli investitori di calibrare l'esposizione in portafoglio con precisione millimetrica e di accedere a mercati secondari h24. La frazionabilità riduce le barriere all'ingresso, aumentando la base dei potenziali acquirenti e garantendo una "exit strategy" più rapida rispetto alla vendita dell'intero set fisico.

# 3. Trasparenza e Certezza del Sottostante (AssetDocumentationURI)
Il parametro AssetDocumentationURI agisce come un'ancora immutabile tra il token e l'asset fisico. Esso punta a una documentazione crittografica (memorizzata su IPFS) che include perizie, certificati di autenticità e dati sulla provenienza storica. Questa architettura garantisce una trasparenza assoluta: l'investitore può verificare in ogni momento il sottostante del proprio titolo digitale, eliminando le asimmetrie informative tipiche dei mercati collezionistici e consolidando la fiducia nella stabilità del valore del fondo.

Il contratto è stato testato su Remix IDE simulando un ambiente MiCA-compliant


# RWA-Token-MiCA Audit.md

1. Analisi delle Vulnerabilità
Reentrancy (Rischio: Basso): Il contratto eredita ReentrancyGuard, ma non lo utilizza esplicitamente nelle funzioni. Tuttavia, trattandosi di un token ERC-20 standard che non interagisce con contratti esterni che effettuano chiamate arbitrarie (low-level calls), il rischio è attualmente trascurabile.

Overflow/Underflow (Rischio: Nullo): Utilizzando Solidity ^0.8.20, i controlli aritmetici sono integrati nel compilatore. Non sono necessari pacchetti esterni come SafeMath.

Access Control (Rischio: Medio/Basso): Il controllo onlyOwner è implementato correttamente tramite il modulo Ownable di OpenZeppelin. Tuttavia, c'è un Single Point of Failure: se le chiavi dell'Owner vengono perse o rubate, l'intera whitelist diventa ingestibile e il controllo dell'emissione dei token è compromesso.

Raccomandazione: In un contesto istituzionale/MiCA, l'Owner dovrebbe essere un Multisig Wallet (es. Gnosis Safe).

2. Analisi della Whitelist (Compliance MiCA)
La logica della whitelist è solida ma presenta un potenziale punto di frizione operativa:

Aggiramento: La whitelist non può essere "aggirata" a livello di codice perché la funzione _update è un "collo di bottiglia" obbligatorio per ogni trasferimento, minting o burning.

Criticità Compliance: Se un indirizzo whitelisted viene compromesso, l'Owner può rimuoverlo (removeFromWhitelist), ma i token già presenti su quell'indirizzo rimarranno bloccati lì. In ambito MiCA, potrebbe essere richiesta una funzione di "Recover/Force Transfer" in caso di ordini giudiziari o perdita di accesso, che qui manca.

3. Ottimizzazione del Gas (Efficienza Economica)
Dato che ogni operazione su blockchain ha un costo, ecco come rendere il contratto più "leggero" per l'azienda:

Utilizzo di immutable: La variabile assetDocumentationURI viene impostata nel costruttore e probabilmente non cambierà mai. Dichiarandola immutable, si risparmia gas ad ogni lettura.

Custom Errors: Invece di usare stringhe lunghe nei require (es. "Mittente non verificato..."), l'uso di error NonWhitelisted(); riduce drasticamente la dimensione del bytecode del contratto e il costo del gas in caso di fallimento della transazione.

Mapping Optimization: Non ci sono grandi margini qui, ma l'uso di external per le funzioni di whitelist è già un'ottima pratica (più economico di public).
