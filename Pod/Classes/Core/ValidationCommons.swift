//
//  ValidationCommons.swift
//  Pods
//
//  Created by Göksel Köksal on 16/07/15.
//
//

import Foundation

// MARK: Typealiases

public typealias TextValidationRule = ValidationRule<String>
public typealias TextValidationRuleSet = ValidationRuleSet<String>
public typealias TextFieldValidator = FieldValidator<String>
public typealias TextFieldValidationDelegate = FieldValidationDelegate<String>

// MARK: Enums

/// Type of validations.
public enum ValidationType {
    
    /// Validates to see if field's value is valid, so that we can enable submit button.
    case Eligibility
    
    /// Validates to see if field is complete, so that we can proceed to next field or even submit automatically if possible.
    case Completeness
    
    /// Validates to see if field's value matches with our criteria (for server, database, etc.) after submit button is tapped.
    case Submission
    
    /// All of available types in an array.
    public static let allValues = [Eligibility, Completeness, Submission]
}

/**
 State of the validation. Used by validators to keep current state.
 */
public struct ValidationState : OptionSetType {
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// Means that the field is eligible for submission attempt.
    public static let Eligible = ValidationState(rawValue: 1 << 1)
    
    /// Means that the field is complete and can proceed to next field or submit if possible.
    public static let Complete = ValidationState(rawValue: 1 << 2)
    
    /// Means that the field passed final validation for submission and matches every criteria we have. Safe to make a server call, database operation, etc.
    public static let Submittable = ValidationState(rawValue: 1 << 3)
}

/// Enum to represent a validation result.
public enum ValidationResult {
    
    case Success
    case Failure(errors: [NSError])
    
    // MARK: Convenience
    
    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        default:
            return false
        }
    }
    
    public var errors: [NSError]? {
        switch self {
        case .Failure(let resultingErrors):
            return resultingErrors
        default:
            return nil
        }
    }
}

// MARK: Global functions

/**
 Returns a state that might be affected in a way for given validation type.
 - Parameter type: Type of the validation.
 */
func affectedStateForValidationType(type: ValidationType) -> ValidationState {
    
    switch type {
    case ValidationType.Eligibility:
        return ValidationState.Eligible
    case ValidationType.Submission:
        return ValidationState.Submittable
    case ValidationType.Completeness:
        return ValidationState.Complete
    }
}
