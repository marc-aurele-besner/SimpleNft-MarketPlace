module.exports = {
  INVALID_SIGNATURE__SIMPLENFTMARKETPLACE: 'SimpleNftMarketplace: invalid signature',
  CALLER_NOT_LISTING_OWNER_OR_MODO: 'SimpleNftMarketplace: Only listing owner or moderator',

  CALLER_NOT_ADMIN: 'Controlable: Only admin',
  CALLER_NOT_MODERATOR: 'Controlable: Only moderator',
  CALLER_NOT_TREASURY: 'Controlable: Only treasury',
  TRANSFER_FAILED: 'Controlable: Transfer failed',

  INVALID_SIGNATURE__VALIDATESIGNATURE: 'ValidateSignature: invalid signature',

  CONTRACT_TOKEN_NOT_SUPPORTED: 'ListingManager: Contract token is not supported',
  LISTING_SOLD: 'ListingManager: Listing already sold',
  SELL_PRICE_ABOVE_ZERO: 'ListingManager: Sell price must be above zero',
  TOKEN_BLACKLISTED: 'ListingManager: Contract token is blacklisted',
  USER_BLACKLISTED: 'ListingManager: User is blacklisted',
  SELLER_BLACKLISTED: 'ListingManager: Seller is blacklisted',
  BUYER_BLACKLISTED: 'ListingManager: Buyer is blacklisted',

  ONLY_RENOUNCE_ROLES_FOR_SELF: 'AccessControl: can only renounce roles for self',

  CONTRACT_IS_NOT_INITIALIZING: 'Initializable: contract is not initializing',
  CONTRACT_IS_INITIALIZING: 'Initializable: contract is initializing',
  CONTRACT_ALREADY_INITIALIZED: 'Initializable: contract is already initialized'
};
