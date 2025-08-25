// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITravelInsurance {
    enum InsuranceType { FULL, HALF, CUSTOM }

    struct Policy {
        address insured;
        string flightNumber;
        uint256 departureTime;
        uint256 premiumPaid;
        InsuranceType insType;
        uint256 payoutAmount;
        bool active;
        bool paidOut;
    }

    /// @notice Souscrire à une assurance voyage
    /// @param flightNumber Numéro de vol (IATA)
    /// @param departureTime Timestamp prévu du vol
    /// @param insType Type d’assurance choisi (FULL, HALF, CUSTOM)
    function subscribe(
        string memory flightNumber,
        uint256 departureTime,
        InsuranceType insType
    ) external payable;

    /// @notice Déclencher un paiement (sera automatisé via oracle dans le futur)
    /// @param policyId Identifiant de la police
    function triggerPayout(uint256 policyId) external;

    /// @notice Lire une police d’assurance
    /// @param policyId Identifiant de la police
    function getPolicy(uint256 policyId) external view returns (Policy memory);

    /// @notice Nombre total de polices
    function getPolicyCount() external view returns (uint256);
}
