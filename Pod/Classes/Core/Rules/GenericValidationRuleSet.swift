//
//  GenericValidationRuleSet.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

public class GenericValidationRuleSet {
    
    public var rules: [GenericValidationRule] = [GenericValidationRule]()
    public var lastKnownResult: ValidationResult?
    
    public init(rules: [GenericValidationRule]? = nil) {
        
        if let rules = rules {
            self.rules = rules
        }
    }
    
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
