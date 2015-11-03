//
//  ValidationRuleSet.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

public typealias TextValidationRuleSet = ValidationRuleSet<String>

public class ValidationRuleSet<ValidatableType> {
    
    public var rules: [ValidationRule<ValidatableType>] = [ValidationRule<ValidatableType>]()
    public var validatesNil: Bool = false
    public var lastKnownResult: ValidationResult?
    
    public init(rules: [ValidationRule<ValidatableType>]? = nil, validatesNil: Bool = false) {
        
        if let rules = rules {
            self.rules = rules
        }
        self.validatesNil = validatesNil
    }
    
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
