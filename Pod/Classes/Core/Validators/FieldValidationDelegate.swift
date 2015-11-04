//
//  FieldModel.swift
//  EruValidator
//
//  Created by Göksel Köksal on 28/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

public let FieldDidChangeNotification: String = "FieldDidChangeNotification"

@objc public protocol ValidatableField  {
    
    var fieldValue: AnyObject? { get set }
    func addFieldValueChangedEventForTarget(target: AnyObject?, action: Selector)
    func removeFieldValueChangedEventFromTarget(target: AnyObject?, action: Selector)
}

public class FieldValidationDelegate<ValidatableType> : NSObject {

    public weak var field: ValidatableField?
    public var validator: FieldValidator<ValidatableType>
    
    private var storedFieldValue: ValidatableType?
    
    public init(field: ValidatableField?, validator: FieldValidator<ValidatableType>) {
        
        self.validator = validator
        self.field = field
        super.init()
        self.field?.addFieldValueChangedEventForTarget(self, action: "fieldValueDidChange:")
    }
    
    // MARK: Public methods
    
    public func validateForType(type: ValidationType) -> ValidationResult {
        
        let valueToValidate = valueToValidateForField(field)
        return validator.validateValue(valueToValidate, forType: type)
    }
    
    // MARK: Actions
    
    func fieldValueDidChange(field: ValidatableField!) {
        
        let valueToValidate = valueToValidateForField(field)
        
        switch validator.validateInput(valueToValidate) {
        case .Success:
            storedFieldValue = valueToValidate
            validateForType(.Eligibility)
            validateForType(.Completeness)
            postFieldModelDidChangeNotification()
            
        default:
            field.fieldValue = storedFieldValue as? AnyObject
        }
    }
    
    // MARK: Private
    
    private func valueToValidateForField(field: ValidatableField?) -> ValidatableType? {
        
        let value = field?.fieldValue as? ValidatableType
        let valueToValidate: ValidatableType?
        
        // Empty string should not be validated. Pass nil instead.
        if let string = value as? String where string.characters.count == 0 {
            valueToValidate = nil
        }
        else {
            valueToValidate = value
        }
        
        return valueToValidate
    }
    
    private func postFieldModelDidChangeNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(FieldDidChangeNotification, object: self)
    }
}
