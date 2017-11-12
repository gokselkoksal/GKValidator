//
//  ValidationRuleSet.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

/**
 Set of validation rules.
 */
open class ValidationRuleSet<ValidatableType> {
    
    /// Rules in the set.
    open var rules: [ValidationRule<ValidatableType>] = [ValidationRule<ValidatableType>]()
    
    /// Last known result of `validateValue(_:)` call on this set.
    open var lastKnownResult: ValidationResult?
    
    /**
     Creates an instance of rule set with given rules.
     - Parameters: 
        - rules: Initial rule array to put in this set.
     */
    public init(rules: [ValidationRule<ValidatableType>]? = nil) {
        if let rules = rules {
            self.rules = rules
        }
    }
    
    /**
     Validates all rules in this set for given value.
     - Parameter value: Value to be validated.
     - Returns: Result of the validation.
     */
    open func validate(_ value: ValidatableType) -> ValidationResult {
        var loopResult = ValidationResult.success
        for rule in rules {
            let result = rule.validate(value)
            if result.isSuccess == false {
                loopResult = result
                break
            }
        }
        lastKnownResult = loopResult
        return loopResult
    }
}
