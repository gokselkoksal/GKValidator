//
//  UITextFieldModel.swift
//  EruValidator
//
//  Created by Göksel Köksal on 27/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

/// Text field model. Implements only ```textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool``` in ```UITextFieldDelegate``` protocol.
public class UITextFieldValidationDelegate: FieldValidationDelegate<String>, UITextFieldDelegate {
    
    public weak var textField: UITextField? {
        return field as? UITextField
    }
    
    public init(field: UITextField, validator: FieldValidator<String>) {
        
        super.init(field: field, validator: validator)
        field.delegate = self
        addTextDidChangeObserver()
    }
    
    // MARK: UITextFieldDelegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let fieldText: NSString? = textField.text
        let finalText = fieldText?.stringByReplacingCharactersInRange(range, withString: string)
        
        switch validator.validateInput(finalText) {
        case .Success:
            return true
        default:
            return false
        }
    }
    
    public func textFieldTextDidChange(notification: NSNotification) {
        
        guard let object = notification.object as? UITextField where object === textField else {
            return
        }
        
        validateForType(.Eligibility)
        validateForType(.Completeness)
        postFieldModelDidChangeNotification()
    }
    
    override public func validateForType(type: ValidationType) -> ValidationResult {
        
        let text: String? = textField?.text
        let textToValidate: String? = text?.characters.count > 0 ? text : nil
        let result = validator.validateValue(textToValidate, forType: type)
        return result
    }
    
    // MARK: Private
    
    private func addTextDidChangeObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("textFieldTextDidChange:"),
            name: UITextFieldTextDidChangeNotification,
            object: field
        )
    }
    
    private func postFieldModelDidChangeNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(FieldDidChangeNotification, object: self)
    }
}

