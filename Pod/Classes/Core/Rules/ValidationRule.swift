//
//  ValidationRule.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

public struct ValidationRule<ValidatableType> {
    
    public var error: ValidationError
    private let validationBlock: (value: ValidatableType?) -> Bool
    
    public init(error: ValidationError = ValidationError(code: 0, localizedDescription: nil), validationBlock: (value: ValidatableType?) -> Bool) {
        
        self.error = error
        self.validationBlock = validationBlock
    }
    
    public func validateValue(value: ValidatableType?) -> ValidationResult {
        
        if validationBlock(value: value) {
            return .Success
        }
        else {
            return .Failure(errors: [error]);
        }
    }
}
