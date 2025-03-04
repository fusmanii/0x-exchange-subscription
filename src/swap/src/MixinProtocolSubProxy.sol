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
import "./libs/LibProtocolSubRichErrors.sol";
import "./ProtocolSub.sol";

contract MixinProtocolSubProxy is Ownable {
    /// @dev Address of the protocol subscription smart contract
    address public protocolSubContract;

    event ProtocolSubContractUpdated(address protocolSub);

    /// @dev Mixins are instantiated in the order they are inherited
    /// @param protocolSub The protocol subscription contract address.
    constructor(address protocolSub) public {
        protocolSubContract = protocolSub;
    }

    /// @dev Updates protocol subscription contract address.
    /// @param protocolSub New protocol subscription contract address.
    function setProtocolSubContract(address protocolSub) external onlyOwner {
        if (protocolSub == address(0)) {
            LibRichErrors.rrevert(LibProtocolSubRichErrors.ZeroAddressError());
        }
        protocolSubContract = protocolSub;

        emit ProtocolSubContractUpdated(protocolSub);
    }

    /// @dev Checks if both maker and taker have an active subscription.
    /// @param makerAddress Address of order maker.
    /// @param makerAddress Address of order taker.
    function _onlyActiveSubscription(
        address makerAddress,
        address takerAddress
    ) internal view {
        ProtocolSub(protocolSubContract).onlyActiveSubscription(
            makerAddress,
            takerAddress
        );
    }
}
