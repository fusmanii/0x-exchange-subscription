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

import "@0x/contracts-utils/contracts/src/LibEIP712.sol";

contract LibEIP712ExchangeDomain {
    // EIP712 Exchange Domain Name value
    // TODO: uncomment before deploy
    string internal _EIP712_EXCHANGE_DOMAIN_NAME = "Parallel TCG";

    // EIP712 Exchange Domain Version value
    // TODO: uncomment before deploy
    string internal _EIP712_EXCHANGE_DOMAIN_VERSION = "1.0.0";

    // solhint-disable var-name-mixedcase
    /// @dev Hash of the EIP712 Domain Separator data
    /// @return 0 Domain hash.
    bytes32 public EIP712_EXCHANGE_DOMAIN_HASH;

    // solhint-enable var-name-mixedcase

    /// @param chainId Chain ID of the network this contract is deployed on.
    /// @param verifyingContractAddressIfExists Address of the verifying contract (null if the address of this contract)
    /// @param exchangeDomainName Name of the domain for the exchange (e.g. Parallel TCG)
    /// @param exchangeDomainVersion Version of the domain for the exchange (e.g. 1.0.0)
    constructor(
        uint256 chainId,
        address verifyingContractAddressIfExists,
        string memory exchangeDomainName,
        string memory exchangeDomainVersion
    ) public {
        address verifyingContractAddress = verifyingContractAddressIfExists ==
            address(0)
            ? address(this)
            : verifyingContractAddressIfExists;
        _EIP712_EXCHANGE_DOMAIN_NAME = exchangeDomainName;
        _EIP712_EXCHANGE_DOMAIN_VERSION = exchangeDomainVersion;
        EIP712_EXCHANGE_DOMAIN_HASH = LibEIP712.hashEIP712Domain(
            _EIP712_EXCHANGE_DOMAIN_NAME,
            _EIP712_EXCHANGE_DOMAIN_VERSION,
            chainId,
            verifyingContractAddress
        );
    }
}
