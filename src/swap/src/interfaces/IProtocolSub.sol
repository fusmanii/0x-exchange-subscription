pragma solidity ^0.5.9;

contract IProtocolSub {
    event PrimeContractUpdated(address prime);
    event PackageAdded(uint256 packageId, uint256 period, uint256 cost);
    event PackageUpdated(uint256 packageId, uint256 period, uint256 cost);
    event PackagePurchased(
        uint256 packageId,
        uint256 period,
        uint256 cost,
        uint256 amount,
        address account
    );

    function setPrimeContract(address prime) external;

    function setNewPackage(uint256 period, uint256 cost) external;

    function updatePackage(
        uint256 packageId,
        uint256 period,
        uint256 cost
    ) external;

    function handleInvokeEchelon(
        address from,
        address ethDestination,
        address primeDestination,
        uint256 id,
        uint256 ethValue,
        uint256 primeValue,
        bytes calldata data
    ) external;
}
