pragma solidity ^0.5.9;

import "@0x/contracts-utils/contracts/src/LibRichErrors.sol";

library LibProtocolSubRichErrors {
    enum ProtocolSubErrorCodes {
        INVALID_ASSET_DATA_LENGTH,
        UNKNOWN_ASSET_PROXY
    }

    // bytes4(keccak256("InvalidInvokerError(address,address)"))
    bytes4 internal constant INVALID_INVOKER_ERROR_SELECTOR = 0xc475fbbd;

    // bytes4(keccak256("InvalidPrimeAmountError(uint256,uint256)"))
    bytes4 internal constant INVALID_PRIME_AMOUNT_ERROR_SELECTOR = 0xb275ca58;

    // bytes4(keccak256("InvalidAmountValueError(uint256)"))
    bytes4 internal constant INVALID_AMOUNT_VALUE_ERROR_SELECTOR = 0x59f044da;

    // bytes4(keccak256("InvalidPackageCostError(uint256)"))
    bytes4 internal constant INVALID_PACKAGE_COST_ERROR_SELECTOR = 0x2c872ea5;

    // bytes4(keccak256("MakerMissingSubError(address)"))
    bytes4 internal constant MAKER_MISSING_SUB_ERROR_SELECTOR = 0x8e2638ab;

    // bytes4(keccak256("TakerMissingSubError(address)"))
    bytes4 internal constant TAKER_MISSING_SUB_ERROR_SELECTOR = 0x1b3b3542;

    // bytes4(keccak256("ZeroAddressError()"))
    bytes4 internal constant ZERO_ADDRESS_ERROR_SELECTOR = 0x3efa09af;

    // bytes4(keccak256("ZeroValueError()"))
    bytes4 internal constant ZERO_VALUE_ERROR_SELECTOR = 0x08927dbf;

    // solhint-disable func-name-mixedcase
    function InvalidInvokerErrorSelector() internal pure returns (bytes4) {
        return INVALID_INVOKER_ERROR_SELECTOR;
    }

    function InvalidPrimeAmountErrorSelector() internal pure returns (bytes4) {
        return INVALID_PRIME_AMOUNT_ERROR_SELECTOR;
    }

    function InvalidAmountValueErrorSelector() internal pure returns (bytes4) {
        return INVALID_AMOUNT_VALUE_ERROR_SELECTOR;
    }

    function InvalidPackageCostErrorSelector() internal pure returns (bytes4) {
        return INVALID_PACKAGE_COST_ERROR_SELECTOR;
    }

    function MakerMissingSubErrorSelector() internal pure returns (bytes4) {
        return MAKER_MISSING_SUB_ERROR_SELECTOR;
    }

    function TakerMissingSubErrorSelector() internal pure returns (bytes4) {
        return TAKER_MISSING_SUB_ERROR_SELECTOR;
    }

    function ZeroAddressErrorSelector() internal pure returns (bytes4) {
        return ZERO_ADDRESS_ERROR_SELECTOR;
    }

    function ZeroValueErrorSelector() internal pure returns (bytes4) {
        return ZERO_VALUE_ERROR_SELECTOR;
    }

    function InvalidInvokerError(
        address msgSender,
        address prime
    ) internal pure returns (bytes memory) {
        return
            abi.encodeWithSelector(
                INVALID_INVOKER_ERROR_SELECTOR,
                msgSender,
                prime
            );
    }

    function InvalidPrimeAmountError(
        uint256 givenAmount,
        uint256 desiredAmount
    ) internal pure returns (bytes memory) {
        return
            abi.encodeWithSelector(
                INVALID_PRIME_AMOUNT_ERROR_SELECTOR,
                givenAmount,
                desiredAmount
            );
    }

    function InvalidAmountValueError(
        uint256 amount
    ) internal pure returns (bytes memory) {
        return
            abi.encodeWithSelector(INVALID_AMOUNT_VALUE_ERROR_SELECTOR, amount);
    }

    function InvalidPackageCostError(
        uint256 cost
    ) internal pure returns (bytes memory) {
        return
            abi.encodeWithSelector(INVALID_PACKAGE_COST_ERROR_SELECTOR, cost);
    }

    function MakerMissingSubError(
        address makerAddress
    ) internal pure returns (bytes memory) {
        return
            abi.encodeWithSelector(
                MAKER_MISSING_SUB_ERROR_SELECTOR,
                makerAddress
            );
    }

    function TakerMissingSubError(
        address takerAddress
    ) internal pure returns (bytes memory) {
        return
            abi.encodeWithSelector(
                TAKER_MISSING_SUB_ERROR_SELECTOR,
                takerAddress
            );
    }

    function ZeroAddressError() internal pure returns (bytes memory) {
        return abi.encodeWithSelector(ZERO_ADDRESS_ERROR_SELECTOR);
    }

    function ZeroValueError() internal pure returns (bytes memory) {
        return abi.encodeWithSelector(ZERO_VALUE_ERROR_SELECTOR);
    }
}
