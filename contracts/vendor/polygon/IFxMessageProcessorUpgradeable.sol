// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (vendor/polygon/IFxMessageProcessor.sol)
pragma solidity ^0.8.0;

interface IFxMessageProcessorUpgradeable {

    /**
     * 处理跨链消息
     * @param stateId 状态id
     * @param rootMessageSender  原始消息发送者
     * @param data 调用数据
     */
    function processMessageFromRoot(
        uint256 stateId,
        address rootMessageSender,
        bytes calldata data
    ) external;
}
