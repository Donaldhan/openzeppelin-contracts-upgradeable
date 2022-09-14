// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (governance/compatibility/IGovernorCompatibilityBravo.sol)

pragma solidity ^0.8.0;

import "../IGovernorUpgradeable.sol";
import "../../proxy/utils/Initializable.sol";

/**
 * @dev Interface extension that adds missing functions to the {Governor} core to provide `GovernorBravo` compatibility.
 * IGovernorUpgradeable拓展接口
 * _Available since v4.3._
 */
abstract contract IGovernorCompatibilityBravoUpgradeable is Initializable, IGovernorUpgradeable {
    function __IGovernorCompatibilityBravo_init() internal onlyInitializing {
    }

    function __IGovernorCompatibilityBravo_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev Proposal structure from Compound Governor Bravo. Not actually used by the compatibility layer, as
     * {{proposal}} returns a very different structure.
     * https://view.inews.qq.com/a/20211025A040Z500
     *  Compound Governor Bravo 模式提案
     */
    struct Proposal {
        uint256 id;
        address proposer; //提议者
        uint256 eta;
        address[] targets; //提案目标地址
        uint256[] values; // 提案值
        string[] signatures; //提案签名
        bytes[] calldatas; //提案调用数据
        uint256 startBlock; //开始区块
        uint256 endBlock;// 结束区块
        uint256 forVotes; //赞成投票数
        uint256 againstVotes; //反对投票数
        uint256 abstainVotes; //弃权投票数
        bool canceled; //是否取消提案
        bool executed; //是否执行提案
        mapping(address => Receipt) receipts;//投票回执
    }

    /**
     * @dev Receipt structure from Compound Governor Bravo
     * 投票回执
     */
    struct Receipt {
        bool hasVoted;//是否投票
        uint8 support;//是否支持
        uint96 votes;//投票份额
    }

    /**
     * @dev Part of the Governor Bravo's interface.
     * 法定投票数
     */
    function quorumVotes() public view virtual returns (uint256);

    /**
     * @dev Part of the Governor Bravo's interface: _"The official record of all proposals ever proposed"_.
     * 提案查询
     */
    function proposals(uint256)
        public
        view
        virtual
        returns (
            uint256 id,
            address proposer,
            uint256 eta,
            uint256 startBlock,
            uint256 endBlock,
            uint256 forVotes,
            uint256 againstVotes,
            uint256 abstainVotes,
            bool canceled,
            bool executed
        );

    /**
     * @dev Part of the Governor Bravo's interface: _"Function used to propose a new proposal"_.
     * 发起提案
     */
    function propose(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) public virtual returns (uint256);

    /**
     * @dev Part of the Governor Bravo's interface: _"Queues a proposal of state succeeded"_.
     * 成功提案入队列
     */
    function queue(uint256 proposalId) public virtual;

    /**
     * @dev Part of the Governor Bravo's interface: _"Executes a queued proposal if eta has passed"_.
     * 执行通过的提案
     */
    function execute(uint256 proposalId) public payable virtual;

    /**
     * @dev Cancels a proposal only if sender is the proposer, or proposer delegates dropped below proposal threshold.
     * 提案者，或提案代理者，在提案门限下，取消提案
     */
    function cancel(uint256 proposalId) public virtual;

    /**
     * @dev Part of the Governor Bravo's interface: _"Gets actions of a proposal"_.
     * 获取提案动作
     */
    function getActions(uint256 proposalId)
        public
        view
        virtual
        returns (
            address[] memory targets,
            uint256[] memory values,
            string[] memory signatures,
            bytes[] memory calldatas
        );

    /**
     * @dev Part of the Governor Bravo's interface: _"Gets the receipt for a voter on a given proposal"_.
     * 获取提案投票的回执
     */
    function getReceipt(uint256 proposalId, address voter) public view virtual returns (Receipt memory);

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}
