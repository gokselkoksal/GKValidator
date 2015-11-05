//
//  FieldValidator.swift
//  EruValidator
//
//  Created by Göksel Köksal on 20/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

/**
 This class keeps all rules to validate a field during its lifecycle.
 */
public class FieldValidator<ValidatableType> {
    
    /// Rule set to be validated before accepting user input.
    public var inputRuleSet: ValidationRuleSet<ValidatableType> = ValidationRuleSet<ValidatableType>(rules: nil, validatesNil: true)
    
    /// Rule sets to be validated to determine if the field is `Completed`, `Eligible` or `Submittable`.
    public var validationRuleSets: [ValidationType: ValidationRuleSet<ValidatableType>] = [ValidationType: ValidationRuleSet<ValidatableType>]()
    
    /// Field becomes `Eligible` and `Submittable` when empty if this flag is true.
    public var optional: Bool = false {
        didSet {
            for type in ValidationType.allValues {
                if let ruleSet = validationRuleSets[type] {
                    ruleSet.validatesNil = optional
                }
            }
        }
    }
    
    /// State of the validator.
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
    
    /// Block to be called upon state change.
    public var didChangeStateBlock: ((state: ValidationState) -> ())?
    
    /// Block to be called upon validation.
    public var didValidateBlock: ((type: ValidationType, result: ValidationResult) -> ())?
    
    // MARK: Lifecycle
    
    public init() { }
    
    // MARK: Public methods - Convenience
    
    /**
     Adds rules into `inputRuleSet` to validate user input.
     - Parameter rules: Rules to add.
     */
    public func addInputRules(rules: [ValidationRule<ValidatableType>]) {
        
        inputRuleSet.rules.appendContentsOf(rules)
    }
    
    /**
     Adds rules into `validationRuleSets` for given type of validation.
     - Parameters:
        - rules: Rules to add.
        - type: Type of validation to add rules for.
     */
    public func addValidationRules(rules: [ValidationRule<ValidatableType>], forType type: ValidationType) {
        
        if let ruleSet = validationRuleSets[type] {
            ruleSet.rules.appendContentsOf(rules)
        }
        else {
            validationRuleSets[type] = ValidationRuleSet<ValidatableType>(rules: rules, validatesNil: optional)
        }
    }
    
    // MARK: Public methods - Validation
    
    /**
     Validates given input.
     - Parameter input: Input to be validated.
     - Returns: Result of the validation.
     */
    public func validateInput(input: ValidatableType?) -> ValidationResult {
        
        let result = self.inputRuleSet.validateValue(input)
        return result
    }
    
    /**
     Validates given type of rules with given value.
     - Parameters:
        - value: Value to be validated.
        - type: Type of validation.
     - Returns: Result of the validation.
     */
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
