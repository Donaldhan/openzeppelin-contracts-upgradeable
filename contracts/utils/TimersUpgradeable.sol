// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Timers.sol)

pragma solidity ^0.8.0;

/**
 * @dev Tooling for timepoints, timers and delays
 * 时间戳、块高延迟计数器
 */
library TimersUpgradeable {
    //时间戳
    struct Timestamp {
        uint64 _deadline;
    }
    //获取截止时间
    function getDeadline(Timestamp memory timer) internal pure returns (uint64) {
        return timer._deadline;
    }
    //设置截止时间
    function setDeadline(Timestamp storage timer, uint64 timestamp) internal {
        timer._deadline = timestamp;
    }
    //重置
    function reset(Timestamp storage timer) internal {
        timer._deadline = 0;
    }
    //是否重置
    function isUnset(Timestamp memory timer) internal pure returns (bool) {
        return timer._deadline == 0;
    }
    //是否开始
    function isStarted(Timestamp memory timer) internal pure returns (bool) {
        return timer._deadline > 0;
    }
    //是否处于pending状态
    function isPending(Timestamp memory timer) internal view returns (bool) {
        return timer._deadline > block.timestamp;
    }
    //是否过期
    function isExpired(Timestamp memory timer) internal view returns (bool) {
        return isStarted(timer) && timer._deadline <= block.timestamp;
    }
    //区块号
    struct BlockNumber {
        uint64 _deadline;
    }

    function getDeadline(BlockNumber memory timer) internal pure returns (uint64) {
        return timer._deadline;
    }

    function setDeadline(BlockNumber storage timer, uint64 timestamp) internal {
        timer._deadline = timestamp;
    }

    function reset(BlockNumber storage timer) internal {
        timer._deadline = 0;
    }

    function isUnset(BlockNumber memory timer) internal pure returns (bool) {
        return timer._deadline == 0;
    }

    function isStarted(BlockNumber memory timer) internal pure returns (bool) {
        return timer._deadline > 0;
    }

    function isPending(BlockNumber memory timer) internal view returns (bool) {
        return timer._deadline > block.number;
    }

    function isExpired(BlockNumber memory timer) internal view returns (bool) {
        return isStarted(timer) && timer._deadline <= block.number;
    }
}
