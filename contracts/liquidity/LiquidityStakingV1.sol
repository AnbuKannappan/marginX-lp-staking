// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.2;
pragma abicoder v2;

import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { LS1Admin } from './impl/LS1Admin.sol';
import { LS1Borrowing } from './impl/LS1Borrowing.sol';
import { LS1DebtAccounting } from './impl/LS1DebtAccounting.sol';
import { LS1ERC20 } from './impl/LS1ERC20.sol';
import { LS1Failsafe } from './impl/LS1Failsafe.sol';
import { LS1Getters } from './impl/LS1Getters.sol';
import { LS1Operators } from './impl/LS1Operators.sol';

/**
 * @title LiquidityStakingV1
 * @author MarginX
 *
 * @notice Contract for staking tokens, which may then be borrowed by pre-approved borrowers.
 *
 *  NOTE: Most functions will revert if epoch zero has not started.
 */
contract LiquidityStakingV1 is
  LS1Borrowing,
  LS1DebtAccounting,
  LS1Admin,
  LS1Operators,
  LS1Getters,
  LS1Failsafe
{
  // ============ Constructor ============

  constructor(
    IERC20 stakedToken,
    IERC20 rewardsToken,
    address fxBridge,
    address rewardsTreasury,
    uint256 distributionStart,
    uint256 distributionEnd
  )
    LS1Borrowing(stakedToken, rewardsToken, fxBridge, rewardsTreasury, distributionStart, distributionEnd)
  {}

  // ============ External Functions ============

  function initialize(
    uint256 interval,
    uint256 offset,
    uint256 blackoutWindow
  )
    external
    initializer
  {
    __LS1Roles_init();
    __LS1EpochSchedule_init(interval, offset, blackoutWindow);
    __LS1Rewards_init();
    __LS1BorrowerAllocations_init();
  }

  // ============ Internal Functions ============

  /**
   * @dev Returns the revision of the implementation contract.
   *
   * @return The revision number.
   */
  function getRevision()
    internal
    pure
    returns (uint256)
  {
    return 1;
  }
}
