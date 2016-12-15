//
//  ValidationRule+String.swift
//  Pods
//
//  Created by Göksel Köksal on 04/11/15.
//
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


public extension ValidationRule where ValidatableType: ExpressibleByStringLiteral {
    
    /**
     Creates a text validation rule for minimum length check.
     - Parameters:
        - error: Error to return upon failure.
        - minLength: Minimum length of the string.
     */
    public init(
        error: ValidationError = ValidationError(code: 0, localizedDescription: nil),
        minLength: UInt)
    {
        self.init(error: error, validationBlock: { value in
            
            let string: String? = value as? String
            let length = string?.gk_length
            return length >= minLength;
        });
    }
    
    /**
     Creates a text validation rule for maximum length check.
     - Parameters:
        - error: Error to return upon failure.
        - maxLength: Maximum length of the string.
     */
    public init(
        error: ValidationError = ValidationError(code: 0, localizedDescription: nil),
        maxLength: UInt)
    {
        self.init(error: error, validationBlock: { value in
            
            let string: String? = value as? String
            let length = string?.gk_length
            return length <= maxLength;
        });
    }
    
    /**
     Creates a text validation rule for character set matching.
     - Parameters:
        - error: Error to return upon failure.
        - maxLength: Character set to match.
     */
    public init(
        error: ValidationError = ValidationError(code: 0, localizedDescription: nil),
        characterSet: CharacterSet)
    {
        
        self.init(error: error, validationBlock: { value in
            
            let string = value as? String
            let trimmedString = string?.trimmingCharacters(in: characterSet)
            return trimmedString?.gk_length == 0
        });
    }
}

public extension String {
    
    /// Length of the string.
    public var gk_length: UInt {
        let length: Int = self.characters.count
        return (length >= 0) ? UInt(length) : 0;
    }
}
