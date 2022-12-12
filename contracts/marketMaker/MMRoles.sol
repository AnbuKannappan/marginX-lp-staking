
pragma solidity ^0.8.2;
pragma abicoder v2;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title MMRoles
 * @author
 *
 */
abstract contract MMRoles is AccessControl

{
  bytes32 public constant OWNER_ROLE = keccak256('OWNER_ROLE');
  bytes32 public constant MARKET_MAKER_ROLE = keccak256('MARKET_MAKER_ROLE');
  bytes32 public constant BORROWER_ADMIN_ROLE = keccak256('BORROWER_ADMIN_ROLE');

  function __MMRoles_init() internal {
    _setupRole(OWNER_ROLE, msg.sender);
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

    // Set OWNER_ROLE as the admin of all roles.
    _setRoleAdmin(OWNER_ROLE, OWNER_ROLE);
    _setRoleAdmin(DEFAULT_ADMIN_ROLE, OWNER_ROLE);
    _setRoleAdmin(MARKET_MAKER_ROLE, OWNER_ROLE);
    _setRoleAdmin(BORROWER_ADMIN_ROLE, OWNER_ROLE);
  }


}
