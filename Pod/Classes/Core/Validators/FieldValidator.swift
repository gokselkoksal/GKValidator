//
//  FieldValidator.swift
//  EruValidator
//
//  Created by Göksel Köksal on 20/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

enum FieldValidatorException: Error {
    case fieldCannotBeEmpty
}

/**
 This class keeps all rules to validate a field during its lifecycle.
 */
open class FieldValidator<ValidatableType> {
    
    /// Rule set to be validated before accepting user input.
    open var inputRuleSet: ValidationRuleSet<ValidatableType> = ValidationRuleSet<ValidatableType>(rules: nil)
    
    /// Rule sets to be validated to determine if the field is `Completed`, `Eligible` or `Submittable`.
    open var validationRuleSets: [ValidationType: ValidationRuleSet<ValidatableType>] = [ValidationType: ValidationRuleSet<ValidatableType>]()
    
    /// Field becomes `Eligible` and `Submittable` when empty if this flag is true.
    open var optional: Bool = false
    
    /// State of the validator.
    open fileprivate(set) var state: ValidationState = [] {
        didSet {
            if oldValue.rawValue == self.state.rawValue {
                return
            }
            if state.contains(ValidationState.Submittable) && !state.contains(ValidationState.Eligible) {
                self.state.remove(ValidationState.Submittable)
            }
            didChangeStateBlock?(state);
        }
    }
    
    /// Block to be called upon state change.
    open var didChangeStateBlock: ((_ state: ValidationState) -> ())?
    
    /// Block to be called upon validation.
    open var didValidateBlock: ((_ type: ValidationType, _ result: ValidationResult) -> ())?
    
    // MARK: Lifecycle
    
    public init() { }
    
    // MARK: Public methods - Convenience
    
    /**
     Adds rules into `inputRuleSet` to validate user input.
     - Parameter rules: Rules to add.
     */
    open func addInputRules(_ rules: [ValidationRule<ValidatableType>]) {
        inputRuleSet.rules.append(contentsOf: rules)
    }
    
    /**
     Adds rules into `validationRuleSets` for given type of validation.
     - Parameters:
        - rules: Rules to add.
        - type: Type of validation to add rules for.
     */
    open func addValidationRules(_ rules: [ValidationRule<ValidatableType>], forType type: ValidationType) {
        if let ruleSet = validationRuleSets[type] {
            ruleSet.rules.append(contentsOf: rules)
        }
        else {
            validationRuleSets[type] = ValidationRuleSet<ValidatableType>(rules: rules)
        }
    }
    
    // MARK: Public methods - Validation
    
    /**
     Validates given input.
     - Parameter input: Input to be validated.
     - Returns: Result of the validation.
     */
    @discardableResult
    open func validateInput(_ input: ValidatableType?) -> ValidationResult {
        guard let input = input else {
            return .success
        }
        return inputRuleSet.validate(input)
    }
    
    /**
     Validates given type of rules with given value.
     - Parameters:
        - value: Value to be validated.
        - type: Type of validation.
     - Returns: Result of the validation.
     */
    @discardableResult
    open func validateValue(_ value: ValidatableType?, forType type: ValidationType) -> ValidationResult {
        guard let ruleSet = validationRuleSets[type] else {
            return .success
        }
        guard let value = value else {
            if optional {
                return .success
            } else {
                return .failure([FieldValidatorException.fieldCannotBeEmpty])
            }
        }
        let result = ruleSet.validate(value)
        let affectedState = affectedStateForValidationType(type)
        switch result {
        case .success:
            state.insert(affectedState)
        case .failure:
            state.remove(affectedState)
        }
        didValidateBlock?(type, result)
        return result
    }
}
