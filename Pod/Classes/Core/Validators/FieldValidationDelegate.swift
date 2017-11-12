//
//  FieldModel.swift
//  EruValidator
//
//  Created by Göksel Köksal on 28/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

/// Name of notification which is fired upon a field change.
public let FieldDidChangeNotification: String = "FieldDidChangeNotification"

/**
 Protocol to be adapted by validatable fields.
 */
@objc public protocol ValidatableField  {
    
    /// Value in the field. For example `self.text` for a `UITextField`.
    var fieldValue: Any? { get set }
    
    /**
     Adds a target-action for field change event.
     - Parameters:
        - target: Target object.
        - action: Selector to look for.
     */
    func addFieldValueChangedEvent(forTarget target: AnyObject?, action: Selector)
    
    /**
     Removes a target-action for field change event.
     - Parameters:
        - target: Target object.
        - action: Selector to look for.
     */
    func removeFieldValueChangedEvent(fromTarget target: AnyObject?, action: Selector)
}

/**
 `FieldValidationDelegate` binds a validator to a field to take care of validation with no effort.
 */
open class FieldValidationDelegate<ValidatableType> : NSObject {

    /// Field to be validated.
    open weak var field: ValidatableField?
    
    /// Validator to validate field with.
    open var validator: FieldValidator<ValidatableType>
    
    fileprivate var storedFieldValue: ValidatableType?
    
    /**
     Creates an instance of this class with given field and validator.
     - Parameters:
        - field: Field to be validated.
        - validator: Validator to validate field with.
     */
    public init(field: ValidatableField?, validator: FieldValidator<ValidatableType>) {
        
        self.validator = validator
        self.field = field
        super.init()
        self.field?.addFieldValueChangedEvent(forTarget: self, action: #selector(FieldValidationDelegate.fieldValueDidChange(_:)))
    }
    
    // MARK: Public methods
    
    /**
     Validates the field with its current value.
     - Parameter type: Type of the validation.
     - Returns: Result of the validation.
     */
    @discardableResult
    open func validateForType(_ type: ValidationType) -> ValidationResult {
        
        let valueToValidate = valueToValidateForField(field)
        return validator.validateValue(valueToValidate, forType: type)
    }
    
    // MARK: Actions
    
    @objc func fieldValueDidChange(_ field: ValidatableField!) {
        
        let valueToValidate = valueToValidateForField(field)
        
        switch validator.validateInput(valueToValidate) {
        case .success:
            storedFieldValue = valueToValidate
            validateForType(.eligibility)
            validateForType(.completeness)
            postFieldModelDidChangeNotification()
            
        default:
            field.fieldValue = storedFieldValue
        }
    }
    
    // MARK: Private
    
    fileprivate func valueToValidateForField(_ field: ValidatableField?) -> ValidatableType? {
        
        let value = field?.fieldValue as? ValidatableType
        let valueToValidate: ValidatableType?
        
        // Empty string should not be validated. Pass nil instead.
        if let string = value as? String, string.count == 0 {
            valueToValidate = nil
        }
        else {
            valueToValidate = value
        }
        
        return valueToValidate
    }
    
    fileprivate func postFieldModelDidChangeNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: FieldDidChangeNotification), object: self)
    }
}
