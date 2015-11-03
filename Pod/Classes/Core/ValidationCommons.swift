//
//  ValidationCommons.swift
//  Pods
//
//  Created by Göksel Köksal on 16/07/15.
//
//

import Foundation

public typealias ObjectValidationResultPair = (object: AnyObject, result: ValidationResult)

public struct ErrorIdentifiers {
    public struct Domains {
        public static let ValidationRule = "GK.Validity.ValidationRule"
        public static let FieldValidationDelegate = "GK.Validity.FieldValidationDelegate"
        public static let FormValidator = "GK.Validity.FormValidator"
    }
}

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

public class ValidationError: NSError {
    
    convenience public init(
        domain: String = ErrorIdentifiers.Domains.ValidationRule,
        code: Int,
        localizedDescription: String?,
        userInfo dict: [NSObject: AnyObject]? = nil)
    {
        var userInfoDict: [NSObject: AnyObject]
        
        if let dict = dict {
            userInfoDict = dict
        }
        else {
            userInfoDict = [NSObject: AnyObject]()
        }
        
        if let localizedDescription = localizedDescription {
            userInfoDict[NSLocalizedDescriptionKey] = localizedDescription
        }
        
        self.init(domain: domain, code: code, userInfo: userInfoDict)
    }
}

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
