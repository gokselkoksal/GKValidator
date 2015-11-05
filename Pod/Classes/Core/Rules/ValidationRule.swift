//
//  ValidationRule.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

/**
 Encapsulates a rule to be used for validation.
 You can validate value of any type using this rule.
 */
public struct ValidationRule<ValidatableType> {
    
    /// Error to return upon failure.
    public var error: ValidationError
    private let validationBlock: (value: ValidatableType?) -> Bool
    
    /**
     Creates an instance of this rule.
     - Parameters:
        - error: Error to return upon failure.
        - validationBlock: Block to execute upon `validate()` call.
     */
    public init(
        error: ValidationError = ValidationError(code: 0, localizedDescription: nil),
        validationBlock: (value: ValidatableType?) -> Bool)
    {
        self.error = error
        self.validationBlock = validationBlock
    }
    
    /**
     Validates rule for given value.
     - Parameter value: Value to be validated.
     - Returns: Result of the validation.
     */
    public func validateValue(value: ValidatableType?) -> ValidationResult {
        
        return validationBlock(value: value) ? .Success : .Failure(errors: [error])
    }
}
