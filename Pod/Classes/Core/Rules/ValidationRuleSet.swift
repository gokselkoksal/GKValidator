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
public class ValidationRuleSet<ValidatableType> {
    
    /// Rules in the set.
    public var rules: [ValidationRule<ValidatableType>] = [ValidationRule<ValidatableType>]()
    
    /// Validates nil successfully when set to true. Defaults to false.
    public var validatesNil: Bool = false
    
    /// Last known result of `validateValue(_:)` call on this set.
    public var lastKnownResult: ValidationResult?
    
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
    public func validateValue(value: ValidatableType?) -> ValidationResult {
        
        var validationErrors: [NSError]? = nil
        
        ruleLoop: for rule: ValidationRule in rules {
            
            let result = rule.validateValue(value)
            
            switch result {
            case .Failure(let errors):
                validationErrors = errors
                break ruleLoop
            default:
                break
            }
        }
        
        if let errors = validationErrors where errors.count > 0 {
            lastKnownResult = (validatesNil && value == nil) ? .Success : .Failure(errors: errors)
        }
        else {
            lastKnownResult = .Success
        }
        
        return lastKnownResult!
    }
}
