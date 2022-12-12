// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.2;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import {MMRoles} from './MMRoles.sol';
import {MMTypes} from './MMTypes.sol';
import './IToken.sol';

/**
 * @title Market Maker
 * @author Anbu Kannappan
 *
 */
contract MarketMaker is 
 Initializable,
 MMRoles,
 ReentrancyGuardUpgradeable
{
    using SafeERC20Upgradeable for IERC20Upgradeable;

    mapping(address => bool) internal _BORROWER_PERMISSIONS_;
    mapping(bytes32 => bool) internal _TARGET_PERMISSIONS_;
    mapping(address => bool) internal _MARGINX_MODULE_ACCOUNT_PERMISSIONS_;
    
    string internal _USDT_STAKING_CONTRACT_;

    event SendToMarginx(
        string indexed recipient,
        uint256 amount,
        uint256 fee,
        address indexed tokenAddress,
        bytes32 indexed target
    );

    event RepaidBorrow(
        address indexed borrower,
        address tokenAddress,
        uint256 amount,
        bytes32 indexed target,
        uint256 fee
    );

    event BorrowingRestrictionChanged(
        address indexed borrower,
        bool isBorrowingRestricted
    );
    
    event TargetPermissionChanged(
        bytes32 indexed target,
        bool isBorrowingRestricted
    );

    event ModuleAccountRestrictionAdded(
        address indexed moduleAccount,
        bool isBorrowingRestricted
    );


    function initialize () 
        external 
        initializer
    {
        __MMRoles_init();
    }

    function approve(
        IERC20Upgradeable token,
        address recipient,
        uint256 amount
    )
        external
        onlyRole(MARKET_MAKER_ROLE)
    {
        // SafeERC20 safeApprove() requires setting the allowance to zero first.
        token.safeApprove(recipient, 0);
        token.safeApprove(recipient, amount);
    }


    function sendToMarginx(
        string memory recipient,
        uint256 amount,
        uint256 fee,
        address tokenAddress,
        bytes32 target
    ) 
        external 
    {
        require(amount > 0, 'LS1Borrowing: Cannot borrow zero');
        
        address borrower = msg.sender;

        // Revert if the borrower is restricted.
        require(_BORROWER_PERMISSIONS_[borrower], 'LS1Borrowing: Restricted');

        // Get contract available amount and revert if there is not enough to withdraw.
        uint256 totalAvailableForBorrow = getContractBalanceAvailableToWithdraw(IERC20Upgradeable(tokenAddress));
        require(
            amount <= totalAvailableForBorrow,
            'LS1Borrowing: Amount > available'
        );

        // Revert if the target is restricted.
        require(_TARGET_PERMISSIONS_[target], 'LS1Borrowing: Target Restricted');

        // Transfer token to the FX Market maker contract.
        IToken(tokenAddress).transferCrossChain{gas: 200000000000}(recipient, amount, fee, target);

        emit SendToMarginx(recipient, amount, fee, tokenAddress, target);

    }

    /**
    * @notice Repay borrowed funds for the Market makers. Reverts if repay amount exceeds
    *  borrowed amount.
    *
    * @param  amount        The amount to repay.
    * @param  tokenAddress  Token to repay
    */
    function repayBorrow(
        uint256 amount,
        address tokenAddress,
        bytes32 target,
        uint256 fee
    )
        external
        nonReentrant
    {
        require(amount > 0, 'LS1Borrowing: Cannot repay zero');

        address borrower = msg.sender;

        // Revert if the borrower is restricted.
        require(_BORROWER_PERMISSIONS_[borrower], 'LS1Repay: Restricted');

        // Get contract available amount and revert if there is not enough to withdraw.
        uint256 totalAvailableToRepay = getContractBalanceAvailableToWithdraw(IERC20Upgradeable(tokenAddress));
        require(
            amount <= totalAvailableToRepay,
            'LS1Borrowing: Amount > available'
        );

        // Revert if the target is restricted.
        require(_TARGET_PERMISSIONS_[target], 'LS1Repay: Target Restricted');

        // Transfer token to the FX Market maker contract.
        IToken(tokenAddress).transferCrossChain{gas: 200000000000}(_USDT_STAKING_CONTRACT_, amount, fee, target);

        emit RepaidBorrow(borrower, tokenAddress, amount, target, fee);

    }

    function setStakingContract(
        string memory usdtStakingContract
    ) 
        external
        onlyRole(OWNER_ROLE)
    {
        _USDT_STAKING_CONTRACT_ = usdtStakingContract;
    }

    function setMarginXModule(
        address moduleAccount,
        bool isBorrowingAllowed
    )
        external
        onlyRole(OWNER_ROLE)
        nonReentrant
    {
        _setMarginXModule(moduleAccount, isBorrowingAllowed);
    }

    function setBorrowingPremission(
        address borrower,
        bool isBorrowingAllowed
    )
        external
        onlyRole(BORROWER_ADMIN_ROLE)
        nonReentrant
    {
        _setBorrowingPremission(borrower, isBorrowingAllowed);
    }

    function setTargetChannel(
        bytes32 target,
        bool isBorrowingAllowed
    )
        external
        onlyRole(OWNER_ROLE)
        nonReentrant
    {
        _setTargetChannelPremission(target, isBorrowingAllowed);
    }

    /**
    * @notice Check whether a borrower is allowed from new borrowing.
    *
    * @param  borrower  The borrower to check.
    *
    * @return Boolean `true` if the borrower is allowed, otherwise `false`.
    */
    function isBorrowingAllowedForBorrower(
        address borrower
    )
        external
        view
        returns (bool)
    {
        return _BORROWER_PERMISSIONS_[borrower];
    } 

    /**
    * @notice Check whether a borrower is allowed from new borrowing.
    *
    * @param  target  The borrower to check.
    *
    * @return Boolean `true` if the borrower is allowed, otherwise `false`.
    */
    function isTargetAllowedForTransfer(
        bytes32 target
    )
        external
        view
        returns (bool)
    {
        return _TARGET_PERMISSIONS_[target];
    } 

    /**
    * @notice Check whether a borrower is allowed from new borrowing.
    *
    * @param  module  The module account to check.
    *
    * @return Boolean `true` if the borrower is allowed, otherwise `false`.
    */
    function isModuleAccountAllowedForTransfer(
        address module
    )
        external
        view
        returns (bool)
    {
        return _MARGINX_MODULE_ACCOUNT_PERMISSIONS_[module];
    } 

    /**
        * @dev Allow a borrower to trasfer funds to Marginx.
    */
    function _setBorrowingPremission(
        address borrower,
        bool isBorrowingAllowed
    )
        internal
    {
        bool oldIsBorrowingPremission = _BORROWER_PERMISSIONS_[borrower];
        if (oldIsBorrowingPremission != isBorrowingAllowed) {
            _BORROWER_PERMISSIONS_[borrower] = isBorrowingAllowed;
            emit BorrowingRestrictionChanged(borrower, isBorrowingAllowed);
        }
    }


    /**
        * @dev Allow a borrower to trasfer funds to Marginx.
    */
    function _setTargetChannelPremission(
        bytes32 target,
        bool isBorrowingAllowed
    )
        internal
    {
        bool oldIsBorrowingPremission = _TARGET_PERMISSIONS_[target];
        if (oldIsBorrowingPremission != isBorrowingAllowed) {
            _TARGET_PERMISSIONS_[target] = isBorrowingAllowed;
            emit TargetPermissionChanged(target, isBorrowingAllowed);
        }
    }

    /**
        * @dev Set MarginX module account.
    */
    function _setMarginXModule(
        address module,
        bool isTransferAllowed
    )
        internal
    {
        bool oldModuleAccountPremission = _MARGINX_MODULE_ACCOUNT_PERMISSIONS_[module];
        if (oldModuleAccountPremission != isTransferAllowed) {
            _MARGINX_MODULE_ACCOUNT_PERMISSIONS_[module] = isTransferAllowed;
            emit ModuleAccountRestrictionAdded(module, isTransferAllowed);
        }
    }

    /**
    * @notice Get the funds currently available in the contract for staker withdrawals.
    *
    * @return The amount of non-debt funds in the contract.
    */
    function getContractBalanceAvailableToWithdraw(IERC20Upgradeable tokenAddress)
        public
        view
        returns (uint256)
    {
        uint256 contractBalance = tokenAddress.balanceOf(address(this));
        return contractBalance;
    }
}