//
//  GenericValidationRuleSet.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

/**
 Set of generic validation rules.
 */
public class GenericValidationRuleSet {
    
    /// Rules in the set.
    public var rules: [GenericValidationRule] = [GenericValidationRule]()
    
    /// Last known result of `validate()` call on this set.
    public var lastKnownResult: ValidationResult?
    
    /**
     Creates an instance of rule set with given rules.
     - Parameter rules: Initial rule array to put in this set.
     */
    public init(rules: [GenericValidationRule]? = nil) {
        
        if let rules = rules {
            self.rules = rules
        }
    }
    
    /**
     Validates all rules in this set.
     - Returns: Result of the validation.
     */
    public func validate() -> ValidationResult {
        
        var validationErrors: [NSError]? = nil
        
        ruleLoop: for rule in rules {
            
            let result = rule.validate()
            
            switch result {
            case .Failure(let errors):
                validationErrors = errors
                break ruleLoop
            default:
                break
            }
        }
        
        if let errors = validationErrors where errors.count > 0 {
            lastKnownResult = .Failure(errors: errors)
        }
        else {
            lastKnownResult = .Success
        }
        
        return lastKnownResult!
    }
}
