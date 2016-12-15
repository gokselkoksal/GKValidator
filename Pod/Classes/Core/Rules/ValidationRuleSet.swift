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
    
    /// Validates nil successfully when set to true. Defaults to false.
    open var validatesNil: Bool = false
    
    /// Last known result of `validateValue(_:)` call on this set.
    open var lastKnownResult: ValidationResult?
    
    /**
     Creates an instance of rule set with given rules.
     - Parameters: 
        - rules: Initial rule array to put in this set.
        - validatesNil: Validates nil successfully when set to true.
     */
    public init(rules: [ValidationRule<ValidatableType>]? = nil, validatesNil: Bool = false) {
        
        if let rules = rules {
            self.rules = rules
        }
        self.validatesNil = validatesNil
    }
    
    /**
     Validates all rules in this set for given value.
     - Parameter value: Value to be validated.
     - Returns: Result of the validation.
     */
    open func validateValue(_ value: ValidatableType?) -> ValidationResult {
        
        var validationErrors: [NSError]? = nil
        
        ruleLoop: for rule: ValidationRule in rules {
            
            let result = rule.validateValue(value)
            
            switch result {
            case .failure(let errors):
                validationErrors = errors
                break ruleLoop
            default:
                break
            }
        }
        
        if let errors = validationErrors, errors.count > 0 {
            lastKnownResult = (validatesNil && value == nil) ? .success : .failure(errors: errors)
        }
        else {
            lastKnownResult = .success
        }
        
        return lastKnownResult!
    }
}
