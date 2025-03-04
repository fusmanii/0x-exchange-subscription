pragma solidity ^0.5.9;

library LibProtocolSub {
    using LibProtocolSub for Package;
    using LibProtocolSub for Subscription;

    struct Package {
        uint256 period;
        uint256 cost;
    }

    struct Subscription {
        uint256 endTimestamp;
        uint256 purchaseTimestamp;
        uint256 amount;
        uint256 packageId;
        uint256 period;
        uint256 cost;
    }
}
