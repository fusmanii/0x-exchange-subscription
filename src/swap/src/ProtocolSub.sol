/*

  Copyright 2023 Parallel Studios.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.5.9;
pragma experimental ABIEncoderV2;

import "@0x/contracts-utils/contracts/src/Ownable.sol";
import "@0x/contracts-utils/contracts/src/LibRichErrors.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IProtocolSub.sol";
import "./libs/SafeERC20.sol";
import "./libs/LibProtocolSub.sol";
import "./libs/LibProtocolSubRichErrors.sol";
import "../../prime-token/EchelonGatewaysLegacy.sol";

contract ProtocolSub is Ownable, IProtocolSub, EchelonGateways {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using LibProtocolSub for LibProtocolSub.Package;
    using LibProtocolSub for LibProtocolSub.Subscription;

    /// @dev PRIME contract address, used for verifying that correct token is used for subscription purchase.
    address public primeContract;

    /// @dev List of subscription packages.
    /// @param 0 Package index.
    /// @param 0 Package info.
    LibProtocolSub.Package[] public packageInfo;

    /// @dev Mapping of address => subscriptionInfo.
    /// @param 0 Account address.
    /// @param 0 Subscription info of the given account.
    mapping(address => LibProtocolSub.Subscription) public subscriptionInfo;

    /// @dev Mixins are instantiated in the order they are inherited
    /// @param prime The PRIME token contract address.
    constructor(address prime) public {
        primeContract = prime;
    }

    /// @dev Updates PRIME contract address.
    /// @param prime New address of PRIME contract.
    function setPrimeContract(address prime) external onlyOwner {
        primeContract = prime;

        emit PrimeContractUpdated(prime);
    }

    /// @dev Adds new subscription package.
    /// @param period Subscription period for the package.
    /// @param cost The cost of the subscription package in PRIME.
    function setNewPackage(uint256 period, uint256 cost) external onlyOwner {
        if (period == 0) {
            LibRichErrors.rrevert(LibProtocolSubRichErrors.ZeroValueError());
        }
        if (cost == 0) {
            LibRichErrors.rrevert(LibProtocolSubRichErrors.ZeroValueError());
        }

        packageInfo.push(
            LibProtocolSub.Package({ period: period, cost: cost })
        );

        emit PackageAdded(packageInfo.length - 1, period, cost);
    }

    /// @dev Update an existing package period/cost.
    /// @param period New subscription period for the package.
    /// @param cost New cost of the subscription for the package.
    function updatePackage(
        uint256 packageId,
        uint256 period,
        uint256 cost
    ) external onlyOwner {
        if (period == 0) {
            LibRichErrors.rrevert(LibProtocolSubRichErrors.ZeroValueError());
        }
        if (cost == 0) {
            LibRichErrors.rrevert(LibProtocolSubRichErrors.ZeroValueError());
        }

        packageInfo[packageId] = LibProtocolSub.Package({
            period: period,
            cost: cost
        });

        emit PackageUpdated(packageId, period, cost);
    }

    /// @dev Special handler method that is configured in the PRIME contract that enables additional
    ///      functionality to execute after the movement of PRIME and/or ETH in a single transaction (no approve necessary).
    /// @param from - The address of the caller of invokeEchelon
    /// @param primeValue - The amount of PRIME that was sent to the invokeEchelon function (and was collected to _primeDestination)
    /// @param data - Catch-all param allowing callers to pass additional data
    function handleInvokeEchelon(
        address from,
        address,
        address,
        uint256,
        uint256,
        uint256 primeValue,
        bytes memory data
    ) public {
        if (msg.sender != primeContract) {
            LibRichErrors.rrevert(
                LibProtocolSubRichErrors.InvalidInvokerError(
                    msg.sender,
                    primeContract
                )
            );
        }

        // packageId and amount have to be encoded in data param, otherwise this
        // line will fail which is expected
        (uint256 packageId, uint256 amount) = abi.decode(
            data,
            (uint256, uint256)
        );
        LibProtocolSub.Package memory package = packageInfo[packageId];
        if (amount == 0) {
            LibRichErrors.rrevert(
                LibProtocolSubRichErrors.InvalidAmountValueError(amount)
            );
        }
        if (package.cost == 0) {
            LibRichErrors.rrevert(
                LibProtocolSubRichErrors.InvalidPackageCostError(package.cost)
            );
        }
        // we assume that the PRIME contract sent the desired amount of PRIME to
        // the correct address, so we just check against the amount passed in
        if (primeValue != package.cost.mul(amount)) {
            LibRichErrors.rrevert(
                LibProtocolSubRichErrors.InvalidPrimeAmountError(
                    primeValue,
                    package.cost * amount
                )
            );
        }

        _handlePurchase(from, packageId, package, amount);
    }

    /// @dev Handles package subscription purchase for the provided account.
    /// @param account Address of the account.
    /// @param packageId Id of the package.
    /// @param package Package info.
    /// @param amount Amount of subscription period being purchased.
    function _handlePurchase(
        address account,
        uint256 packageId,
        LibProtocolSub.Package memory package,
        uint256 amount
    ) internal {
        LibProtocolSub.Subscription memory subscription = subscriptionInfo[
            account
        ];

        // If current subscription is not over, extend it. Otherwise set
        // subscription period to start from current timestamp
        uint256 endTimestamp;
        if (subscription.endTimestamp < block.timestamp) {
            endTimestamp = package.period.mul(amount).add(block.timestamp);
        } else {
            endTimestamp = package.period.mul(amount).add(
                subscription.endTimestamp
            );
        }

        subscriptionInfo[account] = LibProtocolSub.Subscription({
            endTimestamp: endTimestamp,
            purchaseTimestamp: block.timestamp,
            amount: amount,
            packageId: packageId,
            cost: package.cost,
            period: package.period
        });

        emit PackagePurchased(
            packageId,
            package.period,
            package.cost,
            amount,
            account
        );
    }

    /// @dev Checks if both maker and taker have an active subscription.
    /// @param makerAddress Address of order maker.
    /// @param makerAddress Address if order taker.
    function onlyActiveSubscription(
        address makerAddress,
        address takerAddress
    ) public view {
        LibProtocolSub.Subscription memory makerSubscription = subscriptionInfo[
            makerAddress
        ];
        LibProtocolSub.Subscription memory takerSubscription = subscriptionInfo[
            takerAddress
        ];

        if (makerSubscription.endTimestamp < block.timestamp) {
            LibRichErrors.rrevert(
                LibProtocolSubRichErrors.MakerMissingSubError(makerAddress)
            );
        }
        if (takerSubscription.endTimestamp < block.timestamp) {
            LibRichErrors.rrevert(
                LibProtocolSubRichErrors.TakerMissingSubError(takerAddress)
            );
        }
    }
}
