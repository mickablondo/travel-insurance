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
        // vérifications
        require(msg.value > 0, "Premium must be paid");
        require(uint(insuranceType) <= uint(type(InsuranceType).max), "Invalid type");
        require(bytes(flightNumber).length > 0, "Flight number is required");
        require(departureTime > block.timestamp, "Departure time must be in the future");

        // création de la police d'assurance
        Policy memory newPolicy = Policy({
            insured: msg.sender,
            flightNumber: flightNumber,
            departureTime: departureTime,
            premiumPaid: msg.value,
            insType: insuranceType,
            payoutAmount: 0, // doit-on le calculer ici ?
            active: true,
            paidOut: false
        });

        // stockage de la police
        policies[policyCount] = newPolicy;
        policiesByInsured[msg.sender].push(policyCount);
        policyCount++;
    }

    /**
     * @dev See {ITravelInsurance-triggerPayout}.
     */
    function triggerPayout(uint256 policyId) external override {
        Policy storage policy = policies[policyId];
        require(policy.active, "Policy is not active");
        require(!policy.paidOut, "Policy has already been paid out");
        require(block.timestamp >= policy.departureTime, "Flight has not departed yet");
        require(policy.insured != address(0), "Invalid insured address");
        require(policy.insured != address(this), "Cannot transfer to contract itself");

        // TODO : via un oracle, vérifier si le vol a été annulé ou retardé via un oracle

        policy.paidOut = true;
        policy.active = false;

        uint256 payoutAmount = 0;
        if(policy.insType == InsuranceType.HALF) {
            payoutAmount = policy.premiumPaid * 3 / 2;
        } else if(policy.insType == InsuranceType.FULL) {
            payoutAmount = policy.premiumPaid * 2;
        } else {
            payoutAmount = policy.premiumPaid; // TODO : gérer le cas CUSTOM
        }
        policy.payoutAmount = payoutAmount;

        // Transfert des fonds à l'assuré
        require(payoutAmount > 0, "Payout amount must be greater than zero");
        payable(policy.insured).transfer(payoutAmount);
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