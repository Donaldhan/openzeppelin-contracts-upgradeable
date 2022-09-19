// SPDX-License-Identifier: MIT
/**
 * 像Uniswap一样使用 Merkle 执行空投:https://learnblockchain.cn/article/4613
 * merkletreejs:https://github.com/miguelmota/merkletreejs
 */

pragma solidity ^0.8.0;

import "../utils/cryptography/MerkleProofUpgradeable.sol";
import "../proxy/utils/Initializable.sol";

contract MerkleProofWrapperUpgradeable is Initializable {
    function __MerkleProofWrapper_init() internal onlyInitializing {
    }

    function __MerkleProofWrapper_init_unchained() internal onlyInitializing {
    }
    //验证
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) public pure returns (bool) {
        return MerkleProofUpgradeable.verify(proof, root, leaf);
    }
    //调用数据验证
    function verifyCalldata(
        bytes32[] calldata proof,
        bytes32 root,
        bytes32 leaf
    ) public pure returns (bool) {
        return MerkleProofUpgradeable.verifyCalldata(proof, root, leaf);
    }
    //根据证据和叶节点计算默克尔树
    function processProof(bytes32[] memory proof, bytes32 leaf) public pure returns (bytes32) {
        return MerkleProofUpgradeable.processProof(proof, leaf);
    }
   //根据证据和叶节点计算默克尔树
    function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) public pure returns (bytes32) {
        return MerkleProofUpgradeable.processProofCalldata(proof, leaf);
    }
    //验证默克树
    function multiProofVerify(
        bytes32[] calldata proofs,
        bool[] calldata proofFlag,
        bytes32 root,
        bytes32[] calldata leaves
    ) public pure returns (bool) {
        return MerkleProofUpgradeable.multiProofVerify(proofs, proofFlag, root, leaves);
    }
    ///根据证据和叶节点计算默克尔树
    function processMultiProof(
        bytes32[] calldata proofs,
        bool[] calldata proofFlag,
        bytes32[] calldata leaves
    ) public pure returns (bytes32) {
        return MerkleProofUpgradeable.processMultiProof(proofs, proofFlag, leaves);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}
