// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ITravelInsurance} from "./ITravelInsurance.sol";

contract TravelInsurance is ITravelInsurance {

    /// @notice Stockage des polices d’assurance par ID
    mapping(uint256 => Policy) private policies;

    /// @notice Stockage des ID de police d’assurance par assuré
    mapping(address => uint256[]) private policiesByInsured;

    /// @notice Compteur de polices d’assurance
    uint256 private policyCount;

    /**
     * @dev See {ITravelInsurance-subscribe}.
     */
    function subscribe(
        string memory flightNumber,
        uint256 departureTime,
        InsuranceType insuranceType
    ) external payable override {
        require(msg.value > 0, "Premium must be paid");
        require(uint(insuranceType) <= uint(type(InsuranceType).max), "Invalid type");

        // Implementation here
        policyCount++;
    }

    /**
     * @dev See {ITravelInsurance-triggerPayout}.
     */
    function triggerPayout(uint256 policyId) external override {
        // Implementation here
    }

    /**
     * @dev See {ITravelInsurance-getPolicy}.
     */
    function getPolicy(uint256 policyId) external view override returns (Policy memory) {
         return policies[policyId];
    }

    /**
     * @dev See {ITravelInsurance-getPolicyCount}.
     */
    function getPolicyCount() external view override returns (uint256) {
        return policyCount;
    }

    /**
     * @dev See {ITravelInsurance-cancelPolicy}.
     */
    function cancelPolicy(uint256 policyId) external override {
        Policy storage policy = policies[policyId];
        require(policy.insured == msg.sender, "Only the insured can cancel the policy");
        require(policy.active, "Policy is not active");
        require(!policy.paidOut, "Policy has already been paid out");
        
        policy.active = false;
    }

    /**
     * @dev See {ITravelInsurance-getMyPolicies}.
     */
    function getMyPolicies() external view override returns (uint256[] memory) {
        return policiesByInsured[msg.sender];
    }
}