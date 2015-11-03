//
//  GenericValidationRule.swift
//  Pods
//
//  Created by Göksel Köksal on 03/11/15.
//
//

import Foundation

public struct GenericValidationRule {
    
    public var error: ValidationError
    private let validationBlock: () -> Bool
    
    public init(
        error: ValidationError = ValidationError(code: 0, localizedDescription: nil),
        validationBlock: () -> Bool)
    {
        self.error = error
        self.validationBlock = validationBlock
    }
    
    public func validate() -> ValidationResult {
        
        if validationBlock() {
            return .Success
        }
        else {
            return .Failure(errors: [error]);
        }
    }
}
