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

public enum ValidationType {
    
    case Eligibility
    case Completeness
    case Submission
    
    public static let allValues = [Eligibility, Completeness, Submission]
}

public struct ValidationState : OptionSetType {
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let Eligible = ValidationState(rawValue: 1 << 1)
    public static let Complete = ValidationState(rawValue: 1 << 2)
    public static let Submittable = ValidationState(rawValue: 1 << 3)
}

public enum ValidationResult {
    
    case Success
    case Failure(errors: [NSError])
    
    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        default:
            return false
        }
    }
}

// MARK: Global functions

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
