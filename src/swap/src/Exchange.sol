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

import "./MixinMatchOrders.sol";
import "./MixinWrapperFunctions.sol";
import "./MixinTransferSimulator.sol";
import "./MixinProtocolSubProxy.sol";
import "./interfaces/IERC20.sol";
import "./libs/LibEIP712ExchangeDomain.sol";
import "./libs/SafeERC20.sol";

// solhint-disable no-empty-blocks
// MixinAssetProxyDispatcher, MixinExchangeCore, MixinSignatureValidator,
// and MixinTransactions are all inherited via the other Mixins that are
// used.
/// @dev The 0x Exchange contract.
contract Exchange is
    LibEIP712ExchangeDomain,
    MixinProtocolSubProxy,
    MixinMatchOrders,
    MixinWrapperFunctions,
    MixinTransferSimulator
{
    /// @dev Mixins are instantiated in the order they are inherited
    /// @param chainId Chain ID of the network this contract is deployed on.
    /// @param exchangeDomainName Name of the domain for the exchange (e.g. Parallel TCG)
    /// @param exchangeDomainVersion Version of the domain for the exchange (e.g. 1.0.0)
    /// @param protocolSub The protocol subscription contract address.
    constructor(
        uint256 chainId,
        string memory exchangeDomainName,
        string memory exchangeDomainVersion,
        address protocolSub
    )
        public
        LibEIP712ExchangeDomain(
            chainId,
            address(0),
            exchangeDomainName,
            exchangeDomainVersion
        )
        MixinProtocolSubProxy(protocolSub)
    {}
}
