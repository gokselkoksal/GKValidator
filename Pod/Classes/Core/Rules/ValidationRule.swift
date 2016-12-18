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
    
    public typealias ValidationBlock = ((ValidatableType) -> ValidationResult)
    
    /// Error to return upon failure.
    fileprivate let handler: ValidationBlock
    
    /**
     Creates an instance of this rule.
     - Parameters:
        - handler: Block to execute upon `validate()` call.
     */
    public init(handler: @escaping ValidationBlock) {
        self.handler = handler
    }
    
    /**
     Validates rule for given value.
     - Parameter value: Value to be validated.
     - Returns: Result of the validation.
     */
    public func validate(_ value: ValidatableType) -> ValidationResult {
        return handler(value)
    }
}
