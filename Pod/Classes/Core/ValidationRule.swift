//
//  ValidationRule.swift
//  EruValidator
//
//  Created by Göksel Köksal on 15/07/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

public typealias TextValidationRule = ValidationRule<String>

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

// MARK: String validation rules

public extension ValidationRule where ValidatableType: StringLiteralConvertible {
    
    public init(minLength: UInt) {
        
        self.init(validationBlock: { value in
            if let string = value as? NSString {
                return string.length >= Int(minLength)
            }
            else {
                return false
            }
        });
    }
    
    public init(maxLength: UInt) {
        
        self.init(validationBlock: { value in
            if let string = value as? NSString {
                return string.length <= Int(maxLength)
            }
            else {
                return false
            }
        });
    }
    
    public init(characterSet: NSCharacterSet) {
        
        self.init(validationBlock: { value in
            if let string = value as? NSString {
                let trimmedString: NSString = string.stringByTrimmingCharactersInSet(characterSet)
                return trimmedString.length == 0
            }
            else {
                return false;
            }
            
        });
    }
}
