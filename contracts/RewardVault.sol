// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RewardVault {

    mapping(address => uint256) public rewards;
    address public owner;

    event RewardDeposited(
        address indexed receiver,
        uint256 amount
    );

    event RewardClaimed(
        address indexed receiver,
        uint256 amount
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Not owner"
        );
        _;
    }

    function depositReward(
        address receiver
    )
        external
        payable
        onlyOwner
    {
        require(
            msg.value > 0,
            "No reward"
        );

        rewards[receiver] += msg.value;

        emit RewardDeposited(
            receiver,
            msg.value
        );
    }

    function claimReward()
        external
    {
        uint256 amount =
            rewards[msg.sender];

        require(
            amount > 0,
            "Empty reward"
        );

        rewards[msg.sender] = 0;

        payable(
            msg.sender
        ).transfer(
            amount
        );

        emit RewardClaimed(
            msg.sender,
            amount
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
        return rewards[user];
    }
}
