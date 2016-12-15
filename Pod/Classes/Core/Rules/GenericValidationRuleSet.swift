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
open class GenericValidationRuleSet {
    
    /// Rules in the set.
    open var rules: [GenericValidationRule] = [GenericValidationRule]()
    
    /// Last known result of `validate()` call on this set.
    open var lastKnownResult: ValidationResult?
    
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
    open func validate() -> ValidationResult {
        
        var validationErrors: [NSError]? = nil
        
        ruleLoop: for rule in rules {
            
            let result = rule.validate()
            
            switch result {
            case .failure(let errors):
                validationErrors = errors
                break ruleLoop
            default:
                break
            }
        }
        
        if let errors = validationErrors, errors.count > 0 {
            lastKnownResult = .failure(errors: errors)
        }
        else {
            lastKnownResult = .success
        }
        
        return lastKnownResult!
    }
}
