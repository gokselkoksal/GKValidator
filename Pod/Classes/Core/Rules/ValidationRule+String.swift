//
//  ValidationRule+String.swift
//  Pods
//
//  Created by Göksel Köksal on 04/11/15.
//
//

import Foundation

public extension ValidationRule where ValidatableType: CustomStringConvertible {
    
    /**
     Creates a text validation rule for minimum length check.
     - Parameters:
        - error: Error to return upon failure.
        - minLength: Minimum length of the string.
     */
    public init(minLength: UInt, error: Error? = nil) {
        self.init(handler: { value in
            let condition = value.description.count >= Int(minLength)
            return ValidationResult(condition: condition, error: error)
        })
    }
    
    /**
     Creates a text validation rule for maximum length check.
     - Parameters:
        - error: Error to return upon failure.
        - maxLength: Maximum length of the string.
     */
    public init(maxLength: UInt, error: Error? = nil) {
        self.init(handler: { value in
            let condition = value.description.count <= Int(maxLength)
            return ValidationResult(condition: condition, error: error)
        })
    }
    
    /**
     Creates a text validation rule for character set matching.
     - Parameters:
        - error: Error to return upon failure.
        - maxLength: Character set to match.
     */
    public init(characterSet: CharacterSet, error: Error? = nil) {
        self.init(handler: { value in
            let trimmedString = value.description.trimmingCharacters(in: characterSet)
            let condition = (trimmedString.count == 0)
            return ValidationResult(condition: condition, error: error)
        })
    }
}
