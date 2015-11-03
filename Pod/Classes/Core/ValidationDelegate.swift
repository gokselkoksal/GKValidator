//
//  FieldModel.swift
//  EruValidator
//
//  Created by Göksel Köksal on 28/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

public let FieldDidChangeNotification: String = "FieldDidChangeNotification"

public class FieldValidationDelegate<ValidatableType> : NSObject {
    
    public weak var field: AnyObject?
    public var validator: FieldValidator<ValidatableType>
    
    public init(field: AnyObject?, validator: FieldValidator<ValidatableType>) {
        
        self.field = field
        self.validator = validator
    }
    
    public func validateForType(type: ValidationType) -> ValidationResult {
        
        // Subclasses should override.
        return .Success
    }
}

public protocol Validatable {
    
    typealias ValidatableType
    var validatableValue: ValidatableType? { get }
}
