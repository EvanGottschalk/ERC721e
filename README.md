# ERC721e

Ready to start minting your own NFTs safely and comfortably with one simple codebase? Interested in admin controls and universal PFP recognition? Look no further than this simple upgrade to the ERC721 standard.

ERC721e contains the fundamental features necessary for any type of NFT, be it a piece of art, a membership card, or a character meant to be used on social media as a picture for profile (PFP). This is achieved through standard OpenZeppelin smart contracts that provide fundamental features such as URI assignment and the tracking of the number of minted NFTs.

Universal PFP recognition is achived through the `setPrimaryTokenID` function. By allowing holders to set a primary token within the smart contract, the recognition of their PFP is universal across other platforms. Any website or app can identify a user's primary token ID and set it as their PFP automatically. Through this standard of collection-level PFP assignment, users can have the right PFP at the right time. If a user visits the BAYC Discord sever or website, they see their ape as their PFP. Then, if they visit the DeGods Discord server or webside, they see their DeadGod as their PFP, etc.

The admin functions (which all begin wtith two underscores __) allow the collection creator to make necessary modifications in case of mistakes, fraud, or other future events. These functions are limited within reason - for example, an admin cannot change another wallet's primary PFP (`primaryTokenID`). Only the holder of an NFT can assign it as their primary NFT (this is because the `setPrimaryTokenID` function applies to `msg.sender`, and has no recipient input).

# Coming Soon
- Royalty fees on all send transactions. This makes royalty fees mandatory, allowing for no work-around in any secondary marketplace
- More admin controls
