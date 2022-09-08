// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (finance/VestingWallet.sol)
pragma solidity ^0.8.0;

import "../token/ERC20/utils/SafeERC20Upgradeable.sol";
import "../utils/AddressUpgradeable.sol";
import "../utils/ContextUpgradeable.sol";
import "../utils/math/MathUpgradeable.sol";
import "../proxy/utils/Initializable.sol";

/**
 * @title VestingWallet  受益人钱包
 * @dev This contract handles the vesting of Eth and ERC20 tokens for a given beneficiary. Custody of multiple tokens
 * can be given to this contract, which will release the token to the beneficiary following a given vesting schedule.
 * The vesting schedule is customizable through the {vestedAmount} function.
 * 处理给定受益人地址的eth和erc20收益
 * Any token transferred to this contract will follow the vesting schedule as if they were locked from the beginning.
 * Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly)
 * be immediately releasable.
 *  该合约处理给定受益人的 Eth 和 ERC20 代币的归属。该合约可以托管多个代币，这将按照给定的归属时间表将代币释放给受益人。
 *  归属时间表可通过该vestedAmount功能进行自定义。任何转移到该合约的代币都将遵循归属时间表，就好像它们从一开始就被锁定一样。
 *  因此，如果归属已经开始，发送到该合约的任何数量的代币都将（至少部分）立即释放。
 * @custom:storage-size 52
 */
contract VestingWalletUpgradeable is Initializable, ContextUpgradeable {
    event EtherReleased(uint256 amount);//eth收款
    event ERC20Released(address indexed token, uint256 amount);//20收款

    uint256 private _released;//eth余额
    mapping(address => uint256) private _erc20Released;//20token的收益
    address private _beneficiary;//受益人地址
    uint64 private _start;//开始时间
    uint64 private _duration;//持续时间

    /**
     * @dev Set the beneficiary, start timestamp and vesting duration of the vesting wallet.
     */
    function __VestingWallet_init(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds
    ) internal onlyInitializing {
        __VestingWallet_init_unchained(beneficiaryAddress, startTimestamp, durationSeconds);
    }

    function __VestingWallet_init_unchained(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds
    ) internal onlyInitializing {
        require(beneficiaryAddress != address(0), "VestingWallet: beneficiary is zero address");
        _beneficiary = beneficiaryAddress;
        _start = startTimestamp;
        _duration = durationSeconds;
    }

    /**
     * @dev The contract should be able to receive Eth.
     * 接收eth
     */
    receive() external payable virtual {}

    /**
     * @dev Getter for the beneficiary address. 受益人地址
     */
    function beneficiary() public view virtual returns (address) {
        return _beneficiary;
    }

    /**
     * @dev Getter for the start timestamp. 开始时间
     */
    function start() public view virtual returns (uint256) {
        return _start;
    }

    /**
     * @dev Getter for the vesting duration. 获取收益持久时间
     */
    function duration() public view virtual returns (uint256) {
        return _duration;
    }

    /**
     * @dev Amount of eth already released 已经收到的eth
     */
    function released() public view virtual returns (uint256) {
        return _released;
    }

    /**
     * @dev Amount of token already released 收到erc20对应的数量
     */
    function released(address token) public view virtual returns (uint256) {
        return _erc20Released[token];
    }

    /**
     * @dev Release the native token (ether) that have already vested.
     * 结算已经获得eth
     * Emits a {EtherReleased} event.
     */
    function release() public virtual {
        uint256 releasable = vestedAmount(uint64(block.timestamp)) - released();
        _released += releasable;
        emit EtherReleased(releasable);
        AddressUpgradeable.sendValue(payable(beneficiary()), releasable);
    }

    /**
     * @dev Release the tokens that have already vested.
     * 结算ERC20的收益
     * Emits a {ERC20Released} event.
     */
    function release(address token) public virtual {
        //当前可获得的收益
        uint256 releasable = vestedAmount(token, uint64(block.timestamp)) - released(token);
        _erc20Released[token] += releasable;
        emit ERC20Released(token, releasable);
        //转账
        SafeERC20Upgradeable.safeTransfer(IERC20Upgradeable(token), beneficiary(), releasable);
    }

    /**
     * @dev Calculates the amount of ether that has already vested. Default implementation is a linear vesting curve.
     * 获取总投资收益
     */
    function vestedAmount(uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(address(this).balance + released(), timestamp);
    }

    /**
     * @dev Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
     * 获取
     */
    function vestedAmount(address token, uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(IERC20Upgradeable(token).balanceOf(address(this)) + released(token), timestamp);
    }

    /**
     * @dev Virtual implementation of the vesting formula. This returns the amount vested, as a function of time, for
     * an asset given its total historical allocation.
     * 根据开始时间，持续时间及总分配数量计算应得份额
     */
    function _vestingSchedule(uint256 totalAllocation, uint64 timestamp) internal view virtual returns (uint256) {
        if (timestamp < start()) {
            return 0;
        } else if (timestamp > start() + duration()) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start())) / duration();
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[48] private __gap;
}
