// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RewardVault {

    address public owner;

    mapping(address => uint256)
        public pendingRewards;

    uint256
        public totalDistributed;

    event RewardAssigned(
        address indexed user,
        uint256 amount
    );

    event RewardClaimed(
        address indexed user,
        uint256 amount
    );

    constructor() {
        owner =
            msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender ==
            owner,
            "Owner only"
        );
        _;
    }

    function assignReward(
        address user
    )
        external
        payable
        onlyOwner
    {
        require(
            msg.value > 0,
            "Empty reward"
        );

        pendingRewards[user]
            +=
            msg.value;

        totalDistributed
            +=
            msg.value;

        emit RewardAssigned(
            user,
            msg.value
        );
    }

    function claim()
        external
    {
        uint256 reward =
            pendingRewards[
                msg.sender
            ];

        require(
            reward > 0,
            "No reward"
        );

        pendingRewards[
            msg.sender
        ] = 0;

        (bool sent,) =
            payable(
                msg.sender
            ).call{
                value: reward
            }("");

        require(
            sent,
            "Transfer failed"
        );

        emit RewardClaimed(
            msg.sender,
            reward
        );
    }

    function rewardOf(
        address user
    )
        external
        view
        returns (
            uint256
        )
    {
        return
            pendingRewards[
                user
            ];
    }
}
