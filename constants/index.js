const { WhiteList } = require('./WhiteList');

module.exports = {
    FIGLET_NAME: `
.d8888. d888888b .88b  d88. d8888b. db      d88888b     d8b   db d88888b d888888b 
88'  YP   \`88'   88'YbdP\`88 88  \`8D 88      88'         888o  88 88'     \`~~88~~' 
\`8bo.      88    88  88  88 88oodD' 88      88ooooo     88V8o 88 88ooo      88    
\`Y8b.      88    88  88  88 88~~~   88      88~~~~      88 V8o88 88~~~      88    
db   8D   .88.   88  88  88 88      88booo. 88.         88  V888 88         88    
\`8888Y' Y888888P YP  YP  YP 88      Y88888P Y88888P     VP   V8P YP         YP    
`,
    CONTRACT_NAME: 'SimpleNft',
    TOKEN_NAME: 'Simple Nft',
    TOKEN_SYMBOL: 'SNFT',
    CONTRACT_CONTRACT_URI: 'ipfs://test123456test.test/test123contractURI.json',
    CONTRACT_BASE_URI: 'ipfs://test123456test.test/',
    CONTRACT_EXTENSION_URI: '.json',
    MAX_SUPPLY: 1000,
    MINT_PRICE: 0.5,
    WhiteList: WhiteList
};
