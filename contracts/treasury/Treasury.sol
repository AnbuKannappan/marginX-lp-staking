// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { SafeERC20 } from "openzeppelin-contracts/token/ERC20/SafeERC20.sol";
import { IERC20 } from 'openzeppelin-contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';

/**
 * @title Treasury
 * @author MarginX
 *
 * @notice Holds an ERC-20 token. Allows the owner to transfer the token or set allowances.
 */
contract Treasury is
    Initializable,
  OwnableUpgradeable
{
  using SafeERC20 for IERC20;

  uint256 public constant REVISION = 1;

  function getRevision() internal pure returns (uint256) {
    return REVISION;
  }

  function initialize()
    external
    initializer
  {
    __Ownable_init();
  }

  function approve(
    IERC20 token,
    address recipient,
    uint256 amount
  )
    external
    onlyOwner
  {
    // SafeERC20 safeApprove() requires setting the allowance to zero first.
    token.safeApprove(recipient, 0);
    token.safeApprove(recipient, amount);
  }

  function transfer(
    IERC20 token,
    address recipient,
    uint256 amount
  )
    external
    onlyOwner
  {
    token.safeTransfer(recipient, amount);
  }

  
}
