// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ITravelInsurance.sol";

contract TravelInsurance is ITravelInsurance {

    /**
     * @dev See {ITravelInsurance-subscribe}.
     */
    function subscribe(
        string memory flightNumber,
        uint256 departureTime,
        InsuranceType insType
    ) external payable override {
        // Implementation here
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
        // Implementation here
    }

    /**
     * @dev See {ITravelInsurance-getPolicyCount}.
     */
    function getPolicyCount() external view override returns (uint256) {
        // Implementation here
    }
}