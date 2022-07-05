// SPDX-License-Identifier: Apache-2.0
// OpenZeppelin Contracts (last updated v4.6.0) (vendor/arbitrum/IOutbox.sol)

/*
 * Copyright 2021, Offchain Labs, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.8.0;

interface IOutboxUpgradeable {
    event OutboxEntryCreated(
        uint256 indexed batchNum,
        uint256 outboxEntryIndex,
        bytes32 outputRoot,
        uint256 numInBatch
    );
    event OutBoxTransactionExecuted(
        address indexed destAddr,
        address indexed l2Sender,
        uint256 indexed outboxEntryIndex,
        uint256 transactionIndex
    );

    /**
     * L2到L1 发送者
     */
    function l2ToL1Sender() external view returns (address);

    /**
     *  L2到L1 区块
     */
    function l2ToL1Block() external view returns (uint256);

    /**
     *L2到L1 以太坊区块
     */
    function l2ToL1EthBlock() external view returns (uint256);

    /**
     **L2到L1 时间戳
     */
    function l2ToL1Timestamp() external view returns (uint256);

    /**
     *
     */
    function l2ToL1BatchNum() external view returns (uint256);

    /**
     *
     */
    function l2ToL1OutputId() external view returns (bytes32);

    /**
     *
     */
    function processOutgoingMessages(bytes calldata sendsData, uint256[] calldata sendLengths) external;

    /**
     *
     */
    function outboxEntryExists(uint256 batchNum) external view returns (bool);
}
