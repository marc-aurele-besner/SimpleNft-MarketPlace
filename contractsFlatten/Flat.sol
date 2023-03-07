// Sources flattened with hardhat v2.12.7 https://hardhat.org

// File @openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)

pragma solidity ^0.8.0;

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControlUpgradeable {
    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) external;
}


// File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}


// File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.1) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.2;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
     * constructor.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: setting the version to 255 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized < type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}


// File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}


// File @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165Upgradeable {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
    function __ERC165_init() internal onlyInitializing {
    }

    function __ERC165_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165Upgradeable).interfaceId;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}


// File @openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library MathUpgradeable {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}


// File @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library StringsUpgradeable {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = MathUpgradeable.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, MathUpgradeable.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}


// File @openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)

pragma solidity ^0.8.0;





/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControlUpgradeable, ERC165Upgradeable {
    function __AccessControl_init() internal onlyInitializing {
    }

    function __AccessControl_init_unchained() internal onlyInitializing {
    }
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControlUpgradeable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        return _roles[role].members[account];
    }

    /**
     * @dev Revert with a standard message if `_msgSender()` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        StringsUpgradeable.toHexString(account),
                        " is missing role ",
                        StringsUpgradeable.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     *
     * May emit a {RoleRevoked} event.
     */
    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * May emit a {RoleGranted} event.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     *
     * NOTE: This function is deprecated in favor of {_grantRole}.
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}


// File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721Upgradeable is IERC165Upgradeable {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


// File @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721MetadataUpgradeable is IERC721Upgradeable {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}


// File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721ReceiverUpgradeable {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


// File @openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;








/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721Upgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC721Upgradeable, IERC721MetadataUpgradeable {
    using AddressUpgradeable for address;
    using StringsUpgradeable for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    function __ERC721_init(string memory name_, string memory symbol_) internal onlyInitializing {
        __ERC721_init_unchained(name_, symbol_);
    }

    function __ERC721_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
        return
            interfaceId == type(IERC721Upgradeable).interfaceId ||
            interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner or approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(from, to, tokenId, data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
     */
    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId, 1);

        // Check that tokenId was not minted by `_beforeTokenTransfer` hook
        require(!_exists(tokenId), "ERC721: token already minted");

        unchecked {
            // Will not overflow unless all 2**256 token ids are minted to the same owner.
            // Given that tokens are minted one by one, it is impossible in practice that
            // this ever happens. Might change if we allow batch minting.
            // The ERC fails to describe this case.
            _balances[to] += 1;
        }

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     * This is an internal function that does not check if the sender is authorized to operate on the token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721Upgradeable.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId, 1);

        // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
        owner = ERC721Upgradeable.ownerOf(tokenId);

        // Clear approvals
        delete _tokenApprovals[tokenId];

        unchecked {
            // Cannot overflow, as that would require more tokens to be burned/transferred
            // out than the owner initially received through minting and transferring in.
            _balances[owner] -= 1;
        }
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId, 1);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];

        unchecked {
            // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
            // `from`'s balance is the number of token held, which is at least one before the current
            // transfer.
            // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
            // all 2**256 token ids to be minted, which in practice is impossible.
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits an {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721Upgradeable.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Reverts if the `tokenId` has not been minted yet.
     */
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
     * - When `from` is zero, the tokens will be minted for `to`.
     * - When `to` is zero, ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256, /* firstTokenId */
        uint256 batchSize
    ) internal virtual {
        if (batchSize > 1) {
            if (from != address(0)) {
                _balances[from] -= batchSize;
            }
            if (to != address(0)) {
                _balances[to] += batchSize;
            }
        }
    }

    /**
     * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
     * - When `from` is zero, the tokens were minted for `to`.
     * - When `to` is zero, ``from``'s tokens were burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual {}

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[44] private __gap;
}


// File @openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)

pragma solidity ^0.8.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSAUpgradeable {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV // Deprecated in v4.8
    }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature` or error string. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     *
     * Documentation for signature generation:
     * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
     * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
     *
     * _Available since v4.3._
     */
    function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            /// @solidity memory-safe-assembly
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
     *
     * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address, RecoverError) {
        bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        uint8 v = uint8((uint256(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
     *
     * _Available since v4.2._
     */
    function recover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
     * `r` and `s` signature fields separately.
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from `s`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", StringsUpgradeable.toString(s.length), s));
    }

    /**
     * @dev Returns an Ethereum Signed Typed Data, created from a
     * `domainSeparator` and a `structHash`. This produces hash corresponding
     * to the one signed with the
     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
     * JSON-RPC method as part of EIP-712.
     *
     * See {recover}.
     */
    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}


// File @openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)

pragma solidity ^0.8.0;


/**
 * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
 *
 * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
 * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
 * they need in their contracts using a combination of `abi.encode` and `keccak256`.
 *
 * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
 * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
 * ({_hashTypedDataV4}).
 *
 * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
 * the chain id to protect against replay attacks on an eventual fork of the chain.
 *
 * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
 * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
 *
 * _Available since v3.4._
 *
 * @custom:storage-size 52
 */
abstract contract EIP712Upgradeable is Initializable {
    /* solhint-disable var-name-mixedcase */
    bytes32 private _HASHED_NAME;
    bytes32 private _HASHED_VERSION;
    bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    /* solhint-enable var-name-mixedcase */

    /**
     * @dev Initializes the domain separator and parameter caches.
     *
     * The meaning of `name` and `version` is specified in
     * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
     *
     * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
     * - `version`: the current major version of the signing domain.
     *
     * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
     * contract upgrade].
     */
    function __EIP712_init(string memory name, string memory version) internal onlyInitializing {
        __EIP712_init_unchained(name, version);
    }

    function __EIP712_init_unchained(string memory name, string memory version) internal onlyInitializing {
        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));
        _HASHED_NAME = hashedName;
        _HASHED_VERSION = hashedVersion;
    }

    /**
     * @dev Returns the domain separator for the current chain.
     */
    function _domainSeparatorV4() internal view returns (bytes32) {
        return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
    }

    function _buildDomainSeparator(
        bytes32 typeHash,
        bytes32 nameHash,
        bytes32 versionHash
    ) private view returns (bytes32) {
        return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
    }

    /**
     * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
     * function returns the hash of the fully encoded EIP712 message for this domain.
     *
     * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
     *
     * ```solidity
     * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
     *     keccak256("Mail(address to,string contents)"),
     *     mailTo,
     *     keccak256(bytes(mailContents))
     * )));
     * address signer = ECDSA.recover(digest, signature);
     * ```
     */
    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
        return ECDSAUpgradeable.toTypedDataHash(_domainSeparatorV4(), structHash);
    }

    /**
     * @dev The hash of the name parameter for the EIP712 domain.
     *
     * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712NameHash() internal virtual view returns (bytes32) {
        return _HASHED_NAME;
    }

    /**
     * @dev The hash of the version parameter for the EIP712 domain.
     *
     * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712VersionHash() internal virtual view returns (bytes32) {
        return _HASHED_VERSION;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


// File @openzeppelin/contracts/utils/Context.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}


// File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}


// File @openzeppelin/contracts/utils/Address.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}


// File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}


// File @openzeppelin/contracts/utils/math/Math.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}


// File @openzeppelin/contracts/utils/Strings.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}


// File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;







/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner or approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(from, to, tokenId, data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
     */
    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId, 1);

        // Check that tokenId was not minted by `_beforeTokenTransfer` hook
        require(!_exists(tokenId), "ERC721: token already minted");

        unchecked {
            // Will not overflow unless all 2**256 token ids are minted to the same owner.
            // Given that tokens are minted one by one, it is impossible in practice that
            // this ever happens. Might change if we allow batch minting.
            // The ERC fails to describe this case.
            _balances[to] += 1;
        }

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     * This is an internal function that does not check if the sender is authorized to operate on the token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId, 1);

        // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
        owner = ERC721.ownerOf(tokenId);

        // Clear approvals
        delete _tokenApprovals[tokenId];

        unchecked {
            // Cannot overflow, as that would require more tokens to be burned/transferred
            // out than the owner initially received through minting and transferring in.
            _balances[owner] -= 1;
        }
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId, 1);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];

        unchecked {
            // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
            // `from`'s balance is the number of token held, which is at least one before the current
            // transfer.
            // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
            // all 2**256 token ids to be minted, which in practice is impossible.
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits an {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Reverts if the `tokenId` has not been minted yet.
     */
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
     * - When `from` is zero, the tokens will be minted for `to`.
     * - When `to` is zero, ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256, /* firstTokenId */
        uint256 batchSize
    ) internal virtual {
        if (batchSize > 1) {
            if (from != address(0)) {
                _balances[from] -= batchSize;
            }
            if (to != address(0)) {
                _balances[to] += batchSize;
            }
        }
    }

    /**
     * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
     * - When `from` is zero, the tokens were minted for `to`.
     * - When `to` is zero, ``from``'s tokens were burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual {}
}


// File @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol@v4.8.1

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// File contracts/abstracts/Controlable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


abstract contract Controlable is AccessControlUpgradeable {
  bytes32 public constant MODERATOR_ROLE = keccak256('MODERATOR_ROLE');
  bytes32 public constant TREASURY_ROLE = keccak256('TREASURY_ROLE');

  IERC20Upgradeable internal _token;

  mapping(address => mapping(uint => bool)) private blacklistToken;
  mapping(address => bool) private blacklistUser;
  mapping(address => bool) private supportedContracts;

  uint32 internal _transactionFee; // 100_000 = 1%
  uint256 internal _accumulatedTransactionFee;

  event TransactionFeeChanged(uint32 indexed oldFee, uint32 indexed newFee);
  event SupportedContractRemoved(address indexed contractAddress);
  event SupportedContractAdded(address indexed contractAddress);

  function __Controlable_init(address treasury) internal onlyInitializing {
    __AccessControl_init();
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(MODERATOR_ROLE, _msgSender());
    _setupRole(TREASURY_ROLE, treasury);
  }

  modifier onlyAdmin() {
    require(isAdmin(msg.sender), 'Controlable: Only admin');
    _;
  }

  modifier onlyModerator() {
    require(isModerator(msg.sender), 'Controlable: Only moderator');
    _;
  }

  modifier onlyTreasury() {
    require(isTreasury(msg.sender), 'Controlable: Only treasury');
    _;
  }

  function _changeSupportedContract(address contractAddress) internal onlyAdmin returns (bool success) {
    if (supportedContracts[contractAddress]) {
      // Le contrat est déjà pris en charge, donc on le supprime
      supportedContracts[contractAddress] = false;
      emit SupportedContractRemoved(contractAddress);
    } else {
      // Le contrat n'est pas pris en charge, donc on l'ajoute
      supportedContracts[contractAddress] = true;
      emit SupportedContractAdded(contractAddress);
    }
    return true;
  }

  function _changeTransactionFee(uint32 transactionFee_) internal returns (bool success) {
    uint32 oldFee = _transactionFee;
    _transactionFee = transactionFee_;
    emit TransactionFeeChanged(oldFee, transactionFee_);
    return true;
  }

  // Treasury
  function _withdrawTransactionFee() internal returns (bool success) {
    require(_token.transfer(msg.sender, _accumulatedTransactionFee), 'Controlable: Transfer failed');
    return true;
  }

  // Moderator
  function _blacklistToken(address tokenContract, uint256 tokenId, bool isBlacklisted) internal returns (bool success) {
    if (isBlacklisted == true) {
      blacklistToken[tokenContract][tokenId] = true;
    } else {
      blacklistToken[tokenContract][tokenId] = false;
    }
    success = true;
  }

  function _blacklistUser(address userAddress, bool set) internal returns (bool success) {
    if (set == true) {
      blacklistUser[userAddress] = true;
    } else {
      blacklistUser[userAddress] = false;
    }
  }

  function _isBlacklistedUser(address userAddress) internal view returns (bool isBlacklisted) {
    return blacklistUser[userAddress];
  }

  function _isBlacklistedToken(address tokenContract, uint256 tokenId) internal view returns (bool isBlacklisted) {
    return blacklistToken[tokenContract][tokenId];
  }

  function _isSupportedContract(address tokenContract) internal view returns (bool isSupported) {
    return supportedContracts[tokenContract];
  }

  function transactionFee() public view returns (uint32) {
    return _transactionFee;
  }

  function token() public view returns (address tokenAddress) {
    return address(_token);
  }

  function giveModeratorAccess(address account) internal onlyAdmin returns (bool success) {
    grantRole(MODERATOR_ROLE, account);
    return true;
  }

  function giveTreasuryAccess(address account) internal onlyAdmin returns (bool success) {
    grantRole(TREASURY_ROLE, account);
    return true;
  }

  function isAdmin(address account) public view returns (bool) {
    return hasRole(DEFAULT_ADMIN_ROLE, account);
  }

  function isTreasury(address account) public view returns (bool) {
    return hasRole(TREASURY_ROLE, account);
  }

  function isModerator(address account) public view returns (bool) {
    return hasRole(MODERATOR_ROLE, account);
  }

  function addRole(bytes32 role, address account) internal onlyAdmin returns (bool success) {
    _grantRole(role, account);
    return true;
  }

  function removeRole(bytes32 role, address account) internal onlyAdmin returns (bool success) {
    _revokeRole(role, account);
    return true;
  }
}


// File contracts/abstracts/ListingManager.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// IERC721ReceiverUpgradeable

abstract contract ListingManager is Controlable {
  struct Listing {
    address tokenContract;
    uint tokenId;
    uint salePrice;
    address seller;
    address buyer;
    uint listingTimestamp;
    uint buyTimestamp;
  }

  uint32 public constant BASE_TRANSACTION_FEE = 100_000;
  uint256 private _listingId = 0;
  mapping(uint256 => Listing) internal _listings;

  event ListingCreated(uint256 listingId, address tokenContract, uint256 tokenId, uint256 salePrice, address seller);
  event Sale(uint256 listingId, address buyer);

  function __ListingManager_init(address treasury) internal onlyInitializing {
    __Controlable_init(treasury);
  }

  function _calculateListingFee(uint256 listingId) internal view returns (uint256 amount) {
    uint256 fee = (_listings[listingId].salePrice * uint256(_transactionFee)) / BASE_TRANSACTION_FEE;
    return fee;
  }

  function _createListing(address tokenContract, uint256 tokenId, uint256 salePrice, address seller) internal returns (uint256 listingId) {
    require(!_isBlacklistedUser(seller), 'ListingManager: User is blacklisted');
    require(!_isBlacklistedToken(tokenContract, tokenId), 'ListingManager: Contract token is blacklisted');
    require(!_isSupportedContract(tokenContract), 'ListingManager: Contract token is not supported');
    require(salePrice > 0, 'ListingManager: Sell price must be above zero');

    IERC721Upgradeable(tokenContract).safeTransferFrom(seller, address(this), tokenId);

    Listing memory listing = Listing(tokenContract, tokenId, salePrice, seller, address(0), block.timestamp, 0);
    _listings[_listingId] = listing;
    listingId = _listingId;
    _listingId++;

    emit ListingCreated(listingId, tokenContract, tokenId, salePrice, seller);
  }

  function _buyListing(uint256 listingId, address buyer) internal returns (bool success) {
    Listing memory listing = _listings[listingId];
    require(listing.buyTimestamp == 0, 'ListingManager: Listing already sold');

    uint256 listingFee = _calculateListingFee(listingId);
    uint256 amount = listing.salePrice - listingFee;

    _token.transferFrom(buyer, address(this), listing.salePrice);
    _token.transferFrom(address(this), listing.seller, amount);
    IERC721Upgradeable(listing.tokenContract).safeTransferFrom(address(this), buyer, listing.tokenId);

    _listings[listingId].buyer = buyer;
    _listings[listingId].buyTimestamp = block.timestamp;

    _accumulatedTransactionFee += listingFee;

    emit Sale(listingId, buyer);
    return true;
  }

  function getListingDetail(uint256 listingId) public view returns (Listing memory) {
    return _listings[listingId];
  }

  function isSold(uint256 listingId) public view returns (bool) {
    if (_listings[listingId].buyTimestamp != 0) {
      return true;
    }
    return false;
  }
}


// File contracts/abstracts/ValidateSignature.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract ValidateSignature is EIP712Upgradeable {
  bytes32 private constant _CREATE_LISTING_TYPEHASH = keccak256('CreateListing(address tokenContract,uint256 tokenId,uint256 salePrice,address seller)');
  bytes32 private constant _BUY_LISTING_TYPEHASH = keccak256('BuyListing(uint256 listingId,address buyer)');

  function __ValidateSignature_init(string memory name, string memory version) internal onlyInitializing {
    __EIP712_init(name, version);
  }

  function _verifyCreateListing(
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) internal view returns (bool success) {
    bytes32 structHash = keccak256(abi.encode(_CREATE_LISTING_TYPEHASH, tokenContract, tokenId, salePrice, seller));

    bytes32 hash = _hashTypedDataV4(structHash);

    address signer = ECDSAUpgradeable.recover(hash, v, r, s);
    require(signer == seller, 'ValidateSignature: invalid signature');

    return true;
  }

  function _verifyBuyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) internal view returns (bool success) {
    bytes32 structHash = keccak256(abi.encode(_BUY_LISTING_TYPEHASH, listingId, buyer));

    bytes32 hash = _hashTypedDataV4(structHash);

    address signer = ECDSAUpgradeable.recover(hash, v, r, s);
    require(signer == buyer, 'ValidateSignature: invalid signature');

    return true;
  }
}


// File contracts/mocks/MockERC20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MockERC20
 */

contract MockERC20 is ERC20 {
  constructor() ERC20('MockERC20', 'MOCK') {}

  function mint(address _to, uint256 _amount) public {
    require(_to != address(0));
    require(_amount > 0);
    _mint(_to, _amount);
  }

  function burn(uint256 _amount) public {
    require(_amount > 0);
    _burn(_msgSender(), _amount);
  }

  function burnFrom(address _from, uint256 _amount) public {
    require(_amount > 0);
    _burn(_from, _amount);
  }
}


// File contracts/mocks/MockERC721.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MockERC721
 */

contract MockERC721 is ERC721 {
  constructor() ERC721('MockERC721', 'MOCK') {}

  function mint(address _to, uint256 _tokenId) public {
    require(_to != address(0));
    require(_tokenId > 0);
    _mint(_to, _tokenId);
  }

  function burn(uint256 _tokenId) public {
    require(_exists(_tokenId));
    _burn(_tokenId);
  }
}


// File contracts/mocks/MockERC721Upgradeable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MockERC721Upgradeable
 */

contract MockERC721Upgradeable is ERC721Upgradeable {
  function initialize(string memory name_, string memory symbol_) external initializer {
    __MockERC721Upgradeable_init(name_, symbol_);
  }

  function __MockERC721Upgradeable_init(string memory name_, string memory symbol_) internal onlyInitializing {
    __MockERC721Upgradeable_init_unchained(name_, symbol_);
  }

  function __MockERC721Upgradeable_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
    __ERC721_init(name_, symbol_);
  }

  function mint(address _to, uint256 _tokenId) public {
    require(_to != address(0));
    require(_tokenId > 0);
    _mint(_to, _tokenId);
  }

  function burn(uint256 _tokenId) public {
    require(_exists(_tokenId));
    _burn(_tokenId);
  }

  uint256[50] private __gap;
}


// File contracts/SimpleNftMarketplace.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


contract SimpleNftMarketplace is ListingManager, ValidateSignature {
  string public constant NAME = 'SimpleNft-MarketPlace';
  string public constant VERSION = '0.0.1';

  modifier onlyListingOwnerOrModerator(uint256 listingId) {
    require(msg.sender == _listings[listingId].seller || isModerator(msg.sender), 'SimpleNftMarketplace: Only listing owner or moderator');
    _;
  }

  function initialize(address treasury) external initializer {
    __ValidateSignature_init(name(), version());
    __ListingManager_init(treasury);
  }

  function name() public pure returns (string memory) {
    return NAME;
  }

  function version() public pure returns (string memory) {
    return VERSION;
  }

  function createListing(address tokenContract, uint256 tokenId, uint256 salePrice) external returns (uint256 listingId) {
    _createListing(tokenContract, tokenId, salePrice, msg.sender);
  }

  function buyListing(uint256 listingId) external returns (bool success) {
    _buyListing(listingId, msg.sender);
  }

  function createListing(
    address tokenContract,
    uint256 tokenId,
    uint256 salePrice,
    address seller,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 listingId) {
    require(_verifyCreateListing(tokenContract, tokenId, salePrice, seller, v, r, s), 'SimpleNftMarketplace: invalid signature');
    return _createListing(tokenContract, tokenId, salePrice, msg.sender);
  }

  function buyListing(uint256 listingId, address buyer, uint8 v, bytes32 r, bytes32 s) external returns (bool success) {
    require(_verifyBuyListing(listingId, buyer, v, r, s), 'SimpleNftMarketplace: invalid signature');
    return _buyListing(listingId, buyer);
  }

  // Moderator || Listing creator
  function cancelListing(uint256 listingId) external onlyListingOwnerOrModerator(listingId) returns (bool success) {
    return false;
  }

  // Admin
  function changeSupportedContract(address contractAddress, bool isSupported) external onlyAdmin returns (bool success) {
    return _changeSupportedContract(contractAddress);
  }

  function changeTransactionFee(uint32 newTransactionFee) external onlyAdmin returns (bool success) {
    return _changeTransactionFee(newTransactionFee);
  }

  // Treasury
  function withdrawTransactionFee() external onlyTreasury returns (bool success) {
    return _withdrawTransactionFee();
  }

  // Moderator
  function blacklistToken(address tokenContract, uint256 tokenId, bool isBlackListed) external onlyModerator returns (bool success) {
    return _blacklistToken(tokenContract, tokenId, isBlackListed);
  }

  function blacklistUser(address userAddress, bool set) external onlyModerator returns (bool success) {
    return _blacklistUser(userAddress, set);
  }

  // Read operation

  function listingPrice(uint256 listingId) external view returns (uint256 listingPrice) {
    Listing storage listing = _listings[listingId];
    return listing.salePrice;
  }

  function isListingActive(uint256 listingId) external view returns (bool isActive) {
    return _listings[listingId].buyer == address(0) && _listings[listingId].seller != address(0);
  }

  function isBlacklistedUser(address userAddress) external view returns (bool isBlacklisted) {
    return _isBlacklistedUser(userAddress);
  }

  function isBlacklistedToken(address tokenContract, uint256 tokenId) external view returns (bool isBlacklisted) {
    return _isBlacklistedToken(tokenContract, tokenId);
  }

  function isSupportedContract(address tokenContract) external view returns (bool isSupported) {
    return _isSupportedContract(tokenContract);
  }

  function calculateListingFee(uint256 listingId) external view returns (uint256 amount) {
    return _calculateListingFee(listingId);
  }
}


// File contracts/test/utils/Vm.sol

// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

interface Vm {
  // Set block.timestamp (newTimestamp)
  function warp(uint256) external;

  // Set block.height (newHeight)
  function roll(uint256) external;

  // Set block.basefee (newBasefee)
  function fee(uint256) external;

  // Loads a storage slot from an address (who, slot)
  function load(address, bytes32) external returns (bytes32);

  // Stores a value to an address' storage slot, (who, slot, value)
  function store(address, bytes32, bytes32) external;

  // Signs data, (privateKey, digest) => (v, r, s)
  function sign(uint256, bytes32) external returns (uint8, bytes32, bytes32);

  // Gets address for a given private key, (privateKey) => (address)
  function addr(uint256) external returns (address);

  // Performs a foreign function call via terminal, (stringInputs) => (result)
  function ffi(string[] calldata) external returns (bytes memory);

  // Sets the *next* call's msg.sender to be the input address
  function prank(address) external;

  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called
  function startPrank(address) external;

  // Sets the *next* call's msg.sender to be the input address, and the tx.origin to be the second input
  function prank(address, address) external;

  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input
  function startPrank(address, address) external;

  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;

  // Sets an address' balance, (who, newBalance)
  function deal(address, uint256) external;

  // Sets an address' code, (who, newCode)
  function etch(address, bytes calldata) external;

  // Expects an error on next call
  function expectRevert(bytes calldata) external;

  function expectRevert(bytes4) external;

  function expectRevert() external;

  // Record all storage reads and writes
  function record() external;

  // Gets all accessed reads and write slot from a recording session, for a given address
  function accesses(address) external returns (bytes32[] memory reads, bytes32[] memory writes);

  // Prepare an expected log with (bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData).
  // Call this function, then emit an event, then call a function. Internally after the call, we check if
  // logs were emitted in the expected order with the expected topics and data (as specified by the booleans)
  function expectEmit(bool, bool, bool, bool) external;

  // Mocks a call to an address, returning specified data.
  // Calldata can either be strict or a partial match, e.g. if you only
  // pass a Solidity selector to the expected calldata, then the entire Solidity
  // function will be mocked.
  function mockCall(address, bytes calldata, bytes calldata) external;

  // Clears all mocked calls
  function clearMockedCalls() external;

  // Expect a call to an address with the specified calldata.
  // Calldata can either be strict or a partial match
  function expectCall(address, bytes calldata) external;

  // Gets the code from an artifact file. Takes in the relative path to the json file
  function getCode(string calldata) external returns (bytes memory);

  // Labels an address in call traces
  function label(address, string calldata) external;

  // If the condition is false, discard this run's fuzz inputs and generate new ones
  function assume(bool) external;
}


// File contracts/test/utils/stdlib.sol

// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0 <0.9.0;

// Wrappers around Cheatcodes to avoid footguns
abstract contract stdCheats {
  using stdStorage for StdStorage;

  event WARNING_Deprecated(string msg);

  Vm private constant vm_std_cheats = Vm(address(uint160(uint256(keccak256('hevm cheat code')))));
  StdStorage private std_store_std_cheats;

  // Skip forward or rewind time by the specified number of seconds
  function skip(uint256 time) public {
    vm_std_cheats.warp(block.timestamp + time);
  }

  function rewind(uint256 time) public {
    vm_std_cheats.warp(block.timestamp - time);
  }

  // Setup a prank from an address that has some ether
  function hoax(address who) public {
    vm_std_cheats.deal(who, 1 << 128);
    vm_std_cheats.prank(who);
  }

  function hoax(address who, uint256 give) public {
    vm_std_cheats.deal(who, give);
    vm_std_cheats.prank(who);
  }

  function hoax(address who, address origin) public {
    vm_std_cheats.deal(who, 1 << 128);
    vm_std_cheats.prank(who, origin);
  }

  function hoax(address who, address origin, uint256 give) public {
    vm_std_cheats.deal(who, give);
    vm_std_cheats.prank(who, origin);
  }

  // Start perpetual prank from an address that has some ether
  function startHoax(address who) public {
    vm_std_cheats.deal(who, 1 << 128);
    vm_std_cheats.startPrank(who);
  }

  function startHoax(address who, uint256 give) public {
    vm_std_cheats.deal(who, give);
    vm_std_cheats.startPrank(who);
  }

  // Start perpetual prank from an address that has some ether
  // tx.origin is set to the origin parameter
  function startHoax(address who, address origin) public {
    vm_std_cheats.deal(who, 1 << 128);
    vm_std_cheats.startPrank(who, origin);
  }

  function startHoax(address who, address origin, uint256 give) public {
    vm_std_cheats.deal(who, give);
    vm_std_cheats.startPrank(who, origin);
  }

  // DEPRECATED: Use `deal` instead
  function tip(address token, address to, uint256 give) public {
    emit WARNING_Deprecated('The `tip` stdcheat has been deprecated. Use `deal` instead.');
    std_store_std_cheats.target(token).sig(0x70a08231).with_key(to).checked_write(give);
  }

  // The same as Hevm's `deal`
  // Use the alternative signature for ERC20 tokens
  function deal(address to, uint256 give) public {
    vm_std_cheats.deal(to, give);
  }

  // Set the balance of an account for any ERC20 token
  // Use the alternative signature to update `totalSupply`
  function deal(address token, address to, uint256 give) public {
    deal(token, to, give, false);
  }

  function deal(address token, address to, uint256 give, bool adjust) public {
    // get current balance
    (, bytes memory balData) = token.call(abi.encodeWithSelector(0x70a08231, to));
    uint256 prevBal = abi.decode(balData, (uint256));

    // update balance
    std_store_std_cheats.target(token).sig(0x70a08231).with_key(to).checked_write(give);

    // update total supply
    if (adjust) {
      (, bytes memory totSupData) = token.call(abi.encodeWithSelector(0x18160ddd));
      uint256 totSup = abi.decode(totSupData, (uint256));
      if (give < prevBal) {
        totSup -= (prevBal - give);
      } else {
        totSup += (give - prevBal);
      }
      std_store_std_cheats.target(token).sig(0x18160ddd).checked_write(totSup);
    }
  }

  // Deploy a contract by fetching the contract bytecode from
  // the artifacts directory
  // e.g. `deployCode(code, abi.encode(arg1,arg2,arg3))`
  function deployCode(string memory what, bytes memory args) public returns (address addr) {
    bytes memory bytecode = abi.encodePacked(vm_std_cheats.getCode(what), args);
    assembly {
      addr := create(0, add(bytecode, 0x20), mload(bytecode))
    }
  }

  function deployCode(string memory what) public returns (address addr) {
    bytes memory bytecode = vm_std_cheats.getCode(what);
    assembly {
      addr := create(0, add(bytecode, 0x20), mload(bytecode))
    }
  }
}

library stdError {
  bytes public constant assertionError = abi.encodeWithSignature('Panic(uint256)', 0x01);
  bytes public constant arithmeticError = abi.encodeWithSignature('Panic(uint256)', 0x11);
  bytes public constant divisionError = abi.encodeWithSignature('Panic(uint256)', 0x12);
  bytes public constant enumConversionError = abi.encodeWithSignature('Panic(uint256)', 0x21);
  bytes public constant encodeStorageError = abi.encodeWithSignature('Panic(uint256)', 0x22);
  bytes public constant popError = abi.encodeWithSignature('Panic(uint256)', 0x31);
  bytes public constant indexOOBError = abi.encodeWithSignature('Panic(uint256)', 0x32);
  bytes public constant memOverflowError = abi.encodeWithSignature('Panic(uint256)', 0x41);
  bytes public constant zeroVarError = abi.encodeWithSignature('Panic(uint256)', 0x51);
  // DEPRECATED: Use Hevm's `expectRevert` without any arguments instead
  bytes public constant lowLevelError = bytes(''); // `0x`
}

struct StdStorage {
  mapping(address => mapping(bytes4 => mapping(bytes32 => uint256))) slots;
  mapping(address => mapping(bytes4 => mapping(bytes32 => bool))) finds;
  bytes32[] _keys;
  bytes4 _sig;
  uint256 _depth;
  address _target;
  bytes32 _set;
}

library stdStorage {
  event SlotFound(address who, bytes4 fsig, bytes32 keysHash, uint slot);
  event WARNING_UninitedSlot(address who, uint slot);

  Vm private constant vm_std_store = Vm(address(uint160(uint256(keccak256('hevm cheat code')))));

  function sigs(string memory sigStr) internal pure returns (bytes4) {
    return bytes4(keccak256(bytes(sigStr)));
  }

  /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
  // slot complexity:
  //  if flat, will be bytes32(uint256(uint));
  //  if map, will be keccak256(abi.encode(key, uint(slot)));
  //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
  //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
  function find(StdStorage storage self) internal returns (uint256) {
    address who = self._target;
    bytes4 fsig = self._sig;
    uint256 field_depth = self._depth;
    bytes32[] memory ins = self._keys;

    // calldata to test against
    if (self.finds[who][fsig][keccak256(abi.encodePacked(ins, field_depth))]) {
      return self.slots[who][fsig][keccak256(abi.encodePacked(ins, field_depth))];
    }
    bytes memory cald = abi.encodePacked(fsig, flatten(ins));
    vm_std_store.record();
    bytes32 fdat;
    {
      (, bytes memory rdat) = who.staticcall(cald);
      fdat = bytesToBytes32(rdat, 32 * field_depth);
    }

    (bytes32[] memory reads, ) = vm_std_store.accesses(address(who));
    if (reads.length == 1) {
      bytes32 curr = vm_std_store.load(who, reads[0]);
      if (curr == bytes32(0)) {
        emit WARNING_UninitedSlot(who, uint256(reads[0]));
      }
      if (fdat != curr) {
        require(false, 'Packed slot. This would cause dangerous overwriting and currently isnt supported');
      }
      emit SlotFound(who, fsig, keccak256(abi.encodePacked(ins, field_depth)), uint256(reads[0]));
      self.slots[who][fsig][keccak256(abi.encodePacked(ins, field_depth))] = uint256(reads[0]);
      self.finds[who][fsig][keccak256(abi.encodePacked(ins, field_depth))] = true;
    } else if (reads.length > 1) {
      for (uint256 i = 0; i < reads.length; i++) {
        bytes32 prev = vm_std_store.load(who, reads[i]);
        if (prev == bytes32(0)) {
          emit WARNING_UninitedSlot(who, uint256(reads[i]));
        }
        // store
        vm_std_store.store(who, reads[i], bytes32(hex'1337'));
        bool success;
        bytes memory rdat;
        {
          (success, rdat) = who.staticcall(cald);
          fdat = bytesToBytes32(rdat, 32 * field_depth);
        }

        if (success && fdat == bytes32(hex'1337')) {
          // we found which of the slots is the actual one
          emit SlotFound(who, fsig, keccak256(abi.encodePacked(ins, field_depth)), uint256(reads[i]));
          self.slots[who][fsig][keccak256(abi.encodePacked(ins, field_depth))] = uint256(reads[i]);
          self.finds[who][fsig][keccak256(abi.encodePacked(ins, field_depth))] = true;
          vm_std_store.store(who, reads[i], prev);
          break;
        }
        vm_std_store.store(who, reads[i], prev);
      }
    } else {
      require(false, 'No storage use detected for target');
    }

    require(self.finds[who][fsig][keccak256(abi.encodePacked(ins, field_depth))], 'NotFound');

    delete self._target;
    delete self._sig;
    delete self._keys;
    delete self._depth;

    return self.slots[who][fsig][keccak256(abi.encodePacked(ins, field_depth))];
  }

  function target(StdStorage storage self, address _target) internal returns (StdStorage storage) {
    self._target = _target;
    return self;
  }

  function sig(StdStorage storage self, bytes4 _sig) internal returns (StdStorage storage) {
    self._sig = _sig;
    return self;
  }

  function sig(StdStorage storage self, string memory _sig) internal returns (StdStorage storage) {
    self._sig = sigs(_sig);
    return self;
  }

  function with_key(StdStorage storage self, address who) internal returns (StdStorage storage) {
    self._keys.push(bytes32(uint256(uint160(who))));
    return self;
  }

  function with_key(StdStorage storage self, uint256 amt) internal returns (StdStorage storage) {
    self._keys.push(bytes32(amt));
    return self;
  }

  function with_key(StdStorage storage self, bytes32 key) internal returns (StdStorage storage) {
    self._keys.push(key);
    return self;
  }

  function depth(StdStorage storage self, uint256 _depth) internal returns (StdStorage storage) {
    self._depth = _depth;
    return self;
  }

  function checked_write(StdStorage storage self, address who) internal {
    checked_write(self, bytes32(uint256(uint160(who))));
  }

  function checked_write(StdStorage storage self, uint256 amt) internal {
    checked_write(self, bytes32(amt));
  }

  function checked_write(StdStorage storage self, bool write) internal {
    bytes32 t;
    assembly {
      t := write
    }
    checked_write(self, t);
  }

  function checked_write(StdStorage storage self, bytes32 set) internal {
    address who = self._target;
    bytes4 fsig = self._sig;
    uint256 field_depth = self._depth;
    bytes32[] memory ins = self._keys;

    bytes memory cald = abi.encodePacked(fsig, flatten(ins));
    if (!self.finds[who][fsig][keccak256(abi.encodePacked(ins, field_depth))]) {
      find(self);
    }
    bytes32 slot = bytes32(self.slots[who][fsig][keccak256(abi.encodePacked(ins, field_depth))]);

    bytes32 fdat;
    {
      (, bytes memory rdat) = who.staticcall(cald);
      fdat = bytesToBytes32(rdat, 32 * field_depth);
    }
    bytes32 curr = vm_std_store.load(who, slot);

    if (fdat != curr) {
      require(false, 'Packed slot. This would cause dangerous overwriting and currently isnt supported');
    }
    vm_std_store.store(who, slot, set);
    delete self._target;
    delete self._sig;
    delete self._keys;
    delete self._depth;
  }

  function bytesToBytes32(bytes memory b, uint offset) public pure returns (bytes32) {
    bytes32 out;

    uint256 max = b.length > 32 ? 32 : b.length;
    for (uint i = 0; i < max; i++) {
      out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }

  function flatten(bytes32[] memory b) private pure returns (bytes memory) {
    bytes memory result = new bytes(b.length * 32);
    for (uint256 i = 0; i < b.length; i++) {
      bytes32 k = b[i];
      assembly {
        mstore(add(result, add(32, mul(32, i))), k)
      }
    }

    return result;
  }
}


// File contracts/test/utils/cheatcodes.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

//pragma abicoder v2;

interface CheatCodes {
  // Set block.timestamp
  function warp(uint256) external;

  // Set block.number
  function roll(uint256) external;

  // Set block.basefee
  function fee(uint256) external;

  // Loads a storage slot from an address
  function load(address account, bytes32 slot) external returns (bytes32);

  // Stores a value to an address' storage slot
  function store(address account, bytes32 slot, bytes32 value) external;

  // Signs data
  function sign(uint256 privateKey, bytes32 digest) external returns (uint8 v, bytes32 r, bytes32 s);

  // Computes address for a given private key
  function addr(uint256 privateKey) external returns (address);

  // Performs a foreign function call via terminal
  function ffi(string[] calldata) external returns (bytes memory);

  // Sets the *next* call's msg.sender to be the input address
  function prank(address) external;

  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called
  function startPrank(address) external;

  // Sets the *next* call's msg.sender to be the input address, and the tx.origin to be the second input
  function prank(address, address) external;

  // Sets all subsequent calls' msg.sender to be the input address until `stopPrank` is called, and the tx.origin to be the second input
  function startPrank(address, address) external;

  // Resets subsequent calls' msg.sender to be `address(this)`
  function stopPrank() external;

  // Sets an address' balance
  function deal(address who, uint256 newBalance) external;

  // Sets an address' code
  function etch(address who, bytes calldata code) external;

  // Expects an error on next call
  function expectRevert(bytes calldata) external;

  function expectRevert(bytes4) external;

  function expectRevert() external;

  // Record all storage reads and writes
  function record() external;

  // Gets all accessed reads and write slot from a recording session, for a given address
  function accesses(address) external returns (bytes32[] memory reads, bytes32[] memory writes);

  // Prepare an expected log with (bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData).
  // Call this function, then emit an event, then call a function. Internally after the call, we check if
  // logs were emitted in the expected order with the expected topics and data (as specified by the booleans)
  function expectEmit(bool, bool, bool, bool) external;

  // Mocks a call to an address, returning specified data.
  // Calldata can either be strict or a partial match, e.g. if you only
  // pass a Solidity selector to the expected calldata, then the entire Solidity
  // function will be mocked.
  function mockCall(address, bytes calldata, bytes calldata) external;

  // Clears all mocked calls
  function clearMockedCalls() external;

  // Expect a call to an address with the specified calldata.
  // Calldata can either be strict or a partial match
  function expectCall(address, bytes calldata) external;

  function getCode(string calldata) external returns (bytes memory);

  // Label an address in test traces
  //function label(address addr, string memory label) external;

  // When fuzzing, generate new inputs if conditional not met
  function assume(bool) external;
}


// File contracts/test/utils/console.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library console {
  address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);

  function _sendLogPayload(bytes memory payload) private view {
    uint256 payloadLength = payload.length;
    address consoleAddress = CONSOLE_ADDRESS;
    assembly {
      let payloadStart := add(payload, 32)
      let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
    }
  }

  function log() internal view {
    _sendLogPayload(abi.encodeWithSignature('log()'));
  }

  function logInt(int p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(int)', p0));
  }

  function logUint(uint p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint)', p0));
  }

  function logString(string memory p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string)', p0));
  }

  function logBool(bool p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool)', p0));
  }

  function logAddress(address p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address)', p0));
  }

  function logBytes(bytes memory p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes)', p0));
  }

  function logBytes1(bytes1 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes1)', p0));
  }

  function logBytes2(bytes2 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes2)', p0));
  }

  function logBytes3(bytes3 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes3)', p0));
  }

  function logBytes4(bytes4 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes4)', p0));
  }

  function logBytes5(bytes5 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes5)', p0));
  }

  function logBytes6(bytes6 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes6)', p0));
  }

  function logBytes7(bytes7 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes7)', p0));
  }

  function logBytes8(bytes8 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes8)', p0));
  }

  function logBytes9(bytes9 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes9)', p0));
  }

  function logBytes10(bytes10 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes10)', p0));
  }

  function logBytes11(bytes11 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes11)', p0));
  }

  function logBytes12(bytes12 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes12)', p0));
  }

  function logBytes13(bytes13 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes13)', p0));
  }

  function logBytes14(bytes14 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes14)', p0));
  }

  function logBytes15(bytes15 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes15)', p0));
  }

  function logBytes16(bytes16 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes16)', p0));
  }

  function logBytes17(bytes17 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes17)', p0));
  }

  function logBytes18(bytes18 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes18)', p0));
  }

  function logBytes19(bytes19 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes19)', p0));
  }

  function logBytes20(bytes20 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes20)', p0));
  }

  function logBytes21(bytes21 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes21)', p0));
  }

  function logBytes22(bytes22 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes22)', p0));
  }

  function logBytes23(bytes23 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes23)', p0));
  }

  function logBytes24(bytes24 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes24)', p0));
  }

  function logBytes25(bytes25 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes25)', p0));
  }

  function logBytes26(bytes26 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes26)', p0));
  }

  function logBytes27(bytes27 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes27)', p0));
  }

  function logBytes28(bytes28 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes28)', p0));
  }

  function logBytes29(bytes29 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes29)', p0));
  }

  function logBytes30(bytes30 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes30)', p0));
  }

  function logBytes31(bytes31 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes31)', p0));
  }

  function logBytes32(bytes32 p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bytes32)', p0));
  }

  function log(uint p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint)', p0));
  }

  function log(string memory p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string)', p0));
  }

  function log(bool p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool)', p0));
  }

  function log(address p0) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address)', p0));
  }

  function log(uint p0, uint p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint)', p0, p1));
  }

  function log(uint p0, string memory p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string)', p0, p1));
  }

  function log(uint p0, bool p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool)', p0, p1));
  }

  function log(uint p0, address p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address)', p0, p1));
  }

  function log(string memory p0, uint p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint)', p0, p1));
  }

  function log(string memory p0, string memory p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string)', p0, p1));
  }

  function log(string memory p0, bool p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool)', p0, p1));
  }

  function log(string memory p0, address p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address)', p0, p1));
  }

  function log(bool p0, uint p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint)', p0, p1));
  }

  function log(bool p0, string memory p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string)', p0, p1));
  }

  function log(bool p0, bool p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool)', p0, p1));
  }

  function log(bool p0, address p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address)', p0, p1));
  }

  function log(address p0, uint p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint)', p0, p1));
  }

  function log(address p0, string memory p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string)', p0, p1));
  }

  function log(address p0, bool p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool)', p0, p1));
  }

  function log(address p0, address p1) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address)', p0, p1));
  }

  function log(uint p0, uint p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint)', p0, p1, p2));
  }

  function log(uint p0, uint p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string)', p0, p1, p2));
  }

  function log(uint p0, uint p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool)', p0, p1, p2));
  }

  function log(uint p0, uint p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address)', p0, p1, p2));
  }

  function log(uint p0, string memory p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint)', p0, p1, p2));
  }

  function log(uint p0, string memory p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string)', p0, p1, p2));
  }

  function log(uint p0, string memory p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool)', p0, p1, p2));
  }

  function log(uint p0, string memory p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address)', p0, p1, p2));
  }

  function log(uint p0, bool p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint)', p0, p1, p2));
  }

  function log(uint p0, bool p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string)', p0, p1, p2));
  }

  function log(uint p0, bool p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool)', p0, p1, p2));
  }

  function log(uint p0, bool p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address)', p0, p1, p2));
  }

  function log(uint p0, address p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint)', p0, p1, p2));
  }

  function log(uint p0, address p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string)', p0, p1, p2));
  }

  function log(uint p0, address p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool)', p0, p1, p2));
  }

  function log(uint p0, address p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address)', p0, p1, p2));
  }

  function log(string memory p0, uint p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint)', p0, p1, p2));
  }

  function log(string memory p0, uint p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string)', p0, p1, p2));
  }

  function log(string memory p0, uint p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool)', p0, p1, p2));
  }

  function log(string memory p0, uint p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address)', p0, p1, p2));
  }

  function log(string memory p0, string memory p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint)', p0, p1, p2));
  }

  function log(string memory p0, string memory p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,string)', p0, p1, p2));
  }

  function log(string memory p0, string memory p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool)', p0, p1, p2));
  }

  function log(string memory p0, string memory p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,address)', p0, p1, p2));
  }

  function log(string memory p0, bool p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint)', p0, p1, p2));
  }

  function log(string memory p0, bool p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string)', p0, p1, p2));
  }

  function log(string memory p0, bool p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool)', p0, p1, p2));
  }

  function log(string memory p0, bool p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address)', p0, p1, p2));
  }

  function log(string memory p0, address p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint)', p0, p1, p2));
  }

  function log(string memory p0, address p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,string)', p0, p1, p2));
  }

  function log(string memory p0, address p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool)', p0, p1, p2));
  }

  function log(string memory p0, address p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,address)', p0, p1, p2));
  }

  function log(bool p0, uint p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint)', p0, p1, p2));
  }

  function log(bool p0, uint p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string)', p0, p1, p2));
  }

  function log(bool p0, uint p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool)', p0, p1, p2));
  }

  function log(bool p0, uint p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address)', p0, p1, p2));
  }

  function log(bool p0, string memory p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint)', p0, p1, p2));
  }

  function log(bool p0, string memory p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string)', p0, p1, p2));
  }

  function log(bool p0, string memory p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool)', p0, p1, p2));
  }

  function log(bool p0, string memory p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address)', p0, p1, p2));
  }

  function log(bool p0, bool p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint)', p0, p1, p2));
  }

  function log(bool p0, bool p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string)', p0, p1, p2));
  }

  function log(bool p0, bool p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool)', p0, p1, p2));
  }

  function log(bool p0, bool p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address)', p0, p1, p2));
  }

  function log(bool p0, address p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint)', p0, p1, p2));
  }

  function log(bool p0, address p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string)', p0, p1, p2));
  }

  function log(bool p0, address p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool)', p0, p1, p2));
  }

  function log(bool p0, address p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address)', p0, p1, p2));
  }

  function log(address p0, uint p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint)', p0, p1, p2));
  }

  function log(address p0, uint p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string)', p0, p1, p2));
  }

  function log(address p0, uint p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool)', p0, p1, p2));
  }

  function log(address p0, uint p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address)', p0, p1, p2));
  }

  function log(address p0, string memory p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint)', p0, p1, p2));
  }

  function log(address p0, string memory p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,string)', p0, p1, p2));
  }

  function log(address p0, string memory p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool)', p0, p1, p2));
  }

  function log(address p0, string memory p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,address)', p0, p1, p2));
  }

  function log(address p0, bool p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint)', p0, p1, p2));
  }

  function log(address p0, bool p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string)', p0, p1, p2));
  }

  function log(address p0, bool p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool)', p0, p1, p2));
  }

  function log(address p0, bool p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address)', p0, p1, p2));
  }

  function log(address p0, address p1, uint p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint)', p0, p1, p2));
  }

  function log(address p0, address p1, string memory p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,string)', p0, p1, p2));
  }

  function log(address p0, address p1, bool p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool)', p0, p1, p2));
  }

  function log(address p0, address p1, address p2) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,address)', p0, p1, p2));
  }

  function log(uint p0, uint p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,string)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,uint,address)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,string)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,string,address)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,string)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,bool,address)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,string)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, uint p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,uint,address,address)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,string)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,uint,address)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,string)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,string,address)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,string)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,bool,address)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,string)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, string memory p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,string,address,address)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,string)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,uint,address)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,string)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,string,address)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,string)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,bool,address)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,string)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, bool p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,bool,address,address)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,string)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,uint,address)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,string)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,string,address)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,string)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,bool,address)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,uint)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,string)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,bool)', p0, p1, p2, p3));
  }

  function log(uint p0, address p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(uint,address,address,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,uint,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,string,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,bool,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, uint p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,uint,address,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,uint,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,string,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,bool,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, string memory p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,string,address,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,uint,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,string,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,bool,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, bool p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,bool,address,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,uint,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,string,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,bool,address)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,uint)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,string)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,bool)', p0, p1, p2, p3));
  }

  function log(string memory p0, address p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(string,address,address,address)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,string)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,uint,address)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,string)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,string,address)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,string)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,bool,address)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,string)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, uint p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,uint,address,address)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,string)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,uint,address)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,string)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,string,address)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,string)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,bool,address)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,string)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, string memory p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,string,address,address)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,string)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,uint,address)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,string)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,string,address)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,string)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,bool,address)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,string)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, bool p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,bool,address,address)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,string)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,uint,address)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,string)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,string,address)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,string)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,bool,address)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,uint)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,string)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,bool)', p0, p1, p2, p3));
  }

  function log(bool p0, address p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(bool,address,address,address)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,uint)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,string)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,bool)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,uint,address)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,uint)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,string)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,bool)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,string,address)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,uint)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,string)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,bool)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,bool,address)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,uint)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,string)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,bool)', p0, p1, p2, p3));
  }

  function log(address p0, uint p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,uint,address,address)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,uint)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,string)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,bool)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,uint,address)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,uint)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,string)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,bool)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,string,address)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,uint)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,string)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,bool)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,bool,address)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,uint)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,string)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,bool)', p0, p1, p2, p3));
  }

  function log(address p0, string memory p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,string,address,address)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,uint)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,string)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,bool)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,uint,address)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,uint)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,string)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,bool)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,string,address)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,uint)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,string)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,bool)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,bool,address)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,uint)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,string)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,bool)', p0, p1, p2, p3));
  }

  function log(address p0, bool p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,bool,address,address)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, uint p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,uint)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, uint p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,string)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, uint p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,bool)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, uint p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,uint,address)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, string memory p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,uint)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, string memory p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,string)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, string memory p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,bool)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, string memory p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,string,address)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, bool p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,uint)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, bool p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,string)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, bool p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,bool)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, bool p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,bool,address)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, address p2, uint p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,address,uint)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, address p2, string memory p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,address,string)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, address p2, bool p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,address,bool)', p0, p1, p2, p3));
  }

  function log(address p0, address p1, address p2, address p3) internal view {
    _sendLogPayload(abi.encodeWithSignature('log(address,address,address,address)', p0, p1, p2, p3));
  }
}


// File contracts/test/utils/test.sol

// SPDX-License-Identifier: GPL-3.0-or-later

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity >=0.4.23;

contract DSTest {
  event log(string);
  event logs(bytes);

  event log_address(address);
  event log_bytes32(bytes32);
  event log_int(int);
  event log_uint(uint);
  event log_bytes(bytes);
  event log_string(string);

  event log_named_address(string key, address val);
  event log_named_bytes32(string key, bytes32 val);
  event log_named_decimal_int(string key, int val, uint decimals);
  event log_named_decimal_uint(string key, uint val, uint decimals);
  event log_named_int(string key, int val);
  event log_named_uint(string key, uint val);
  event log_named_bytes(string key, bytes val);
  event log_named_string(string key, string val);

  bool public IS_TEST = true;
  bool public failed;

  address constant HEVM_ADDRESS = address(bytes20(uint160(uint256(keccak256('hevm cheat code')))));

  modifier mayRevert() {
    _;
  }
  modifier testopts(string memory) {
    _;
  }

  function fail() internal {
    failed = true;
  }

  modifier logs_gas() {
    uint startGas = gasleft();
    _;
    uint endGas = gasleft();
    emit log_named_uint('gas', startGas - endGas);
  }

  function assertTrue(bool condition) internal {
    if (!condition) {
      emit log('Error: Assertion Failed');
      fail();
    }
  }

  function assertTrue(bool condition, string memory err) internal {
    if (!condition) {
      emit log_named_string('Error', err);
      assertTrue(condition);
    }
  }

  function assertEq(address a, address b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [address]');
      emit log_named_address('  Expected', b);
      emit log_named_address('    Actual', a);
      fail();
    }
  }

  function assertEq(address a, address b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      assertEq(a, b);
    }
  }

  function assertEq(bytes32 a, bytes32 b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [bytes32]');
      emit log_named_bytes32('  Expected', b);
      emit log_named_bytes32('    Actual', a);
      fail();
    }
  }

  function assertEq(bytes32 a, bytes32 b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      assertEq(a, b);
    }
  }

  function assertEq32(bytes32 a, bytes32 b) internal {
    assertEq(a, b);
  }

  function assertEq32(bytes32 a, bytes32 b, string memory err) internal {
    assertEq(a, b, err);
  }

  function assertEq(int a, int b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [int]');
      emit log_named_int('  Expected', b);
      emit log_named_int('    Actual', a);
      fail();
    }
  }

  function assertEq(int a, int b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      assertEq(a, b);
    }
  }

  function assertEq(uint a, uint b) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [uint]');
      emit log_named_uint('  Expected', b);
      emit log_named_uint('    Actual', a);
      fail();
    }
  }

  function assertEq(uint a, uint b, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      assertEq(a, b);
    }
  }

  function assertEqDecimal(int a, int b, uint decimals) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [decimal int]');
      emit log_named_decimal_int('  Expected', b, decimals);
      emit log_named_decimal_int('    Actual', a, decimals);
      fail();
    }
  }

  function assertEqDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      assertEqDecimal(a, b, decimals);
    }
  }

  function assertEqDecimal(uint a, uint b, uint decimals) internal {
    if (a != b) {
      emit log('Error: a == b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Expected', b, decimals);
      emit log_named_decimal_uint('    Actual', a, decimals);
      fail();
    }
  }

  function assertEqDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a != b) {
      emit log_named_string('Error', err);
      assertEqDecimal(a, b, decimals);
    }
  }

  function assertGt(uint a, uint b) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function assertGt(uint a, uint b, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      assertGt(a, b);
    }
  }

  function assertGt(int a, int b) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function assertGt(int a, int b, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      assertGt(a, b);
    }
  }

  function assertGtDecimal(int a, int b, uint decimals) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function assertGtDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      assertGtDecimal(a, b, decimals);
    }
  }

  function assertGtDecimal(uint a, uint b, uint decimals) internal {
    if (a <= b) {
      emit log('Error: a > b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function assertGtDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a <= b) {
      emit log_named_string('Error', err);
      assertGtDecimal(a, b, decimals);
    }
  }

  function assertGe(uint a, uint b) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function assertGe(uint a, uint b, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      assertGe(a, b);
    }
  }

  function assertGe(int a, int b) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function assertGe(int a, int b, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      assertGe(a, b);
    }
  }

  function assertGeDecimal(int a, int b, uint decimals) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function assertGeDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      assertGeDecimal(a, b, decimals);
    }
  }

  function assertGeDecimal(uint a, uint b, uint decimals) internal {
    if (a < b) {
      emit log('Error: a >= b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function assertGeDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a < b) {
      emit log_named_string('Error', err);
      assertGeDecimal(a, b, decimals);
    }
  }

  function assertLt(uint a, uint b) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function assertLt(uint a, uint b, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      assertLt(a, b);
    }
  }

  function assertLt(int a, int b) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function assertLt(int a, int b, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      assertLt(a, b);
    }
  }

  function assertLtDecimal(int a, int b, uint decimals) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function assertLtDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      assertLtDecimal(a, b, decimals);
    }
  }

  function assertLtDecimal(uint a, uint b, uint decimals) internal {
    if (a >= b) {
      emit log('Error: a < b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function assertLtDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a >= b) {
      emit log_named_string('Error', err);
      assertLtDecimal(a, b, decimals);
    }
  }

  function assertLe(uint a, uint b) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [uint]');
      emit log_named_uint('  Value a', a);
      emit log_named_uint('  Value b', b);
      fail();
    }
  }

  function assertLe(uint a, uint b, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      assertLe(a, b);
    }
  }

  function assertLe(int a, int b) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [int]');
      emit log_named_int('  Value a', a);
      emit log_named_int('  Value b', b);
      fail();
    }
  }

  function assertLe(int a, int b, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      assertLe(a, b);
    }
  }

  function assertLeDecimal(int a, int b, uint decimals) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [decimal int]');
      emit log_named_decimal_int('  Value a', a, decimals);
      emit log_named_decimal_int('  Value b', b, decimals);
      fail();
    }
  }

  function assertLeDecimal(int a, int b, uint decimals, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      assertLeDecimal(a, b, decimals);
    }
  }

  function assertLeDecimal(uint a, uint b, uint decimals) internal {
    if (a > b) {
      emit log('Error: a <= b not satisfied [decimal uint]');
      emit log_named_decimal_uint('  Value a', a, decimals);
      emit log_named_decimal_uint('  Value b', b, decimals);
      fail();
    }
  }

  function assertLeDecimal(uint a, uint b, uint decimals, string memory err) internal {
    if (a > b) {
      emit log_named_string('Error', err);
      assertGeDecimal(a, b, decimals);
    }
  }

  function assertEq(string memory a, string memory b) internal {
    if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b))) {
      emit log('Error: a == b not satisfied [string]');
      emit log_named_string('  Value a', a);
      emit log_named_string('  Value b', b);
      fail();
    }
  }

  function assertEq(string memory a, string memory b, string memory err) internal {
    if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b))) {
      emit log_named_string('Error', err);
      assertEq(a, b);
    }
  }

  function checkEq0(bytes memory a, bytes memory b) internal pure returns (bool ok) {
    ok = true;
    if (a.length == b.length) {
      for (uint i = 0; i < a.length; i++) {
        if (a[i] != b[i]) {
          ok = false;
        }
      }
    } else {
      ok = false;
    }
  }

  function assertEq0(bytes memory a, bytes memory b) internal {
    if (!checkEq0(a, b)) {
      emit log('Error: a == b not satisfied [bytes]');
      emit log_named_bytes('  Expected', a);
      emit log_named_bytes('    Actual', b);
      fail();
    }
  }

  function assertEq0(bytes memory a, bytes memory b, string memory err) internal {
    if (!checkEq0(a, b)) {
      emit log_named_string('Error', err);
      assertEq0(a, b);
    }
  }
}
