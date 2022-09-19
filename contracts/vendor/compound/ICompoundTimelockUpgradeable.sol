// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (vendor/compound/ICompoundTimelock.sol)

pragma solidity ^0.8.0;

/**
 * https://github.com/compound-finance/compound-protocol/blob/master/contracts/Timelock.sol[Compound's timelock] interface
 */
interface ICompoundTimelockUpgradeable {
    event NewAdmin(address indexed newAdmin);
    event NewPendingAdmin(address indexed newPendingAdmin);
    event NewDelay(uint256 indexed newDelay);
    //取消，执行，缓存交易
    event CancelTransaction(
        bytes32 indexed txHash,
        address indexed target,
        uint256 value,
        string signature,
        bytes data,
        uint256 eta
    );
    event ExecuteTransaction(
        bytes32 indexed txHash,
        address indexed target,
        uint256 value,
        string signature,
        bytes data,
        uint256 eta
    );
    event QueueTransaction(
        bytes32 indexed txHash,
        address indexed target,
        uint256 value,
        string signature,
        bytes data,
        uint256 eta
    );

    receive() external payable;

    // solhint-disable-next-line func-name-mixedcase
    function GRACE_PERIOD() external view returns (uint256);

    // solhint-disable-next-line func-name-mixedcase
    function MINIMUM_DELAY() external view returns (uint256);

    // solhint-disable-next-line func-name-mixedcase
    function MAXIMUM_DELAY() external view returns (uint256);

    function admin() external view returns (address);

    function pendingAdmin() external view returns (address);

    function delay() external view returns (uint256);

    function queuedTransactions(bytes32) external view returns (bool);

    function setDelay(uint256) external;

    function acceptAdmin() external;
    //
    function setPendingAdmin(address) external;
    //缓存交易
    function queueTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data,
        uint256 eta
    ) external returns (bytes32);
    //取消交易
    function cancelTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data,
        uint256 eta
    ) external;
    //执行交易
    function executeTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data,
        uint256 eta
    ) external payable returns (bytes memory);
}
