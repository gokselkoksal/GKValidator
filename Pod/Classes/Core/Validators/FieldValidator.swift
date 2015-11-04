//
//  FieldValidator.swift
//  EruValidator
//
//  Created by Göksel Köksal on 20/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

public class FieldValidator<ValidatableType> {
    
    public var inputRuleSet: ValidationRuleSet<ValidatableType> = ValidationRuleSet<ValidatableType>(rules: nil, validatesNil: true)
    public var validationRuleSets: [ValidationType: ValidationRuleSet<ValidatableType>] = [ValidationType: ValidationRuleSet<ValidatableType>]()
    
    public var optional: Bool = false {
        didSet {
            for type in ValidationType.allValues {
                if let ruleSet = validationRuleSets[type] {
                    ruleSet.validatesNil = optional
                }
            }
        }
    }
    
    public var didChangeStateBlock: ((state: ValidationState) -> ())?
    public var didValidateBlock: ((type: ValidationType, result: ValidationResult) -> ())?
    
    public private(set) var state: ValidationState = [] {
        
        didSet {
            if oldValue.rawValue == self.state.rawValue {
                return
            }
            
            if state.contains(ValidationState.Submittable) && !state.contains(ValidationState.Eligible) {
                self.state.remove(ValidationState.Submittable)
            }
            didChangeStateBlock?(state: state);
        }
    }
    
    // MARK: Lifecycle
    
    public init() { }
    
    // MARK: Public methods - Convenience
    
    public func addInputRules(rules: [ValidationRule<ValidatableType>]) {
        
        inputRuleSet.rules.appendContentsOf(rules)
    }
    
    public func addValidationRules(rules: [ValidationRule<ValidatableType>], forType type: ValidationType) {
        
        if let ruleSet = validationRuleSets[type] {
            ruleSet.rules.appendContentsOf(rules)
        }
        else {
            validationRuleSets[type] = ValidationRuleSet<ValidatableType>(rules: rules, validatesNil: optional)
        }
    }
    
    // MARK: Public methods - Validation
    
    public func validateInput(input: ValidatableType?) -> ValidationResult {
        
        let result = self.inputRuleSet.validateValue(input)
        return result
    }
    
    public func validateValue(value: ValidatableType?, forType type: ValidationType) -> ValidationResult {
        
        guard let ruleSet = validationRuleSets[type] else {
            return .Success
        }
        
        let result = ruleSet.validateValue(value)
        
        let affectedState = affectedStateForValidationType(type)
        switch result {
        case .Success:
            state.insert(affectedState)
        case .Failure:
            state.remove(affectedState)
        }
        
        didValidateBlock?(type: type, result: result)
        return result
    }
}
