/*

  Copyright 2019 ZeroEx Intl.

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

import "./MixinAssetProxyDispatcher.sol";

contract MixinTransferSimulator is MixinAssetProxyDispatcher {
    /// @dev This function may be used to simulate any amount of transfers
    /// As they would occur through the Exchange contract. Note that this function
    /// will always revert, even if all transfers are successful. However, it may
    /// be used with eth_call or with a try/catch pattern in order to simulate
    /// the results of the transfers.
    /// @param assetData Asset details, encoded per the AssetProxy contract specification.
    /// @param fromAddress The `from` addresses that corresponds with transfer.
    /// @param toAddress The `to` addresses that corresponds with transfer.
    /// @param amount The amounts that corresponds to transfer.
    /// @return This function does not return a value. However, it will always revert with
    /// `Error("TRANSFERS_SUCCESSFUL")` if the transfer is successful.
    function simulateDispatchTransferFromCalls(
        bytes memory assetData,
        address fromAddress,
        address toAddress,
        uint256 amount
    ) public {
        _dispatchTransferFrom(
            // The index is passed in as `orderHash` so that a failed transfer can be quickly identified when catching the error
            bytes32(0),
            assetData,
            fromAddress,
            toAddress,
            amount
        );
        revert("TRANSFERS_SUCCESSFUL");
    }
}
