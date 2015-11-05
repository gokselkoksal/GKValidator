//
//  GenericValidationRule.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

/**
 Encapsulates a rule to be used for validation. 
 You can validate anything using this rule, its validation block doesn't even have a parameter.
 */
public struct GenericValidationRule {
    
    /// Error to return upon failure.
    public var error: ValidationError
    private let validationBlock: () -> Bool
    
    /**
     Creates an instance of this rule.
     - Parameters:
        - error: Error to return upon failure.
        - validationBlock: Block to execute upon `validate()` call.
     */
    public init(
        error: ValidationError = ValidationError(code: 0, localizedDescription: nil),
        validationBlock: () -> Bool)
    {
        self.error = error
        self.validationBlock = validationBlock
    }
    
    /**
     Validates the rule.
     - Returns: Result of the validation.
     */
    public func validate() -> ValidationResult {
        
        return validationBlock() ? .Success : .Failure(errors: [error]);
    }
}
