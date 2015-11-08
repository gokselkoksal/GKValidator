//
//  RegistrationFormValidator.swift
//  Registration
//
//  Created by Göksel Köksal on 28/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import UIKit
import GKValidator

class RegistrationFormValidator : FormValidator {
    
    var displayNameFieldDelegate: TextFieldValidationDelegate
    var usernameFieldDelegate: TextFieldValidationDelegate
    var emailFieldDelegate: TextFieldValidationDelegate
    var passwordFieldDelegate: TextFieldValidationDelegate
    var rePasswordFieldDelegate: TextFieldValidationDelegate
    var mobileNumberFieldDelegate: TextFieldValidationDelegate
    var tAndCSwitch: UISwitch
    
    init(displayNameField: UITextField,
        usernameField: UITextField,
        emailField: UITextField,
        passwordField: UITextField,
        rePasswordField: UITextField,
        mobileNumberField: UITextField,
        tAndCSwitch: UISwitch
        )
    {
        self.displayNameFieldDelegate = TextFieldValidationDelegate(
            field: displayNameField,
            validator: RegistrationFormValidator.displayNameFieldValidator())
        self.usernameFieldDelegate = TextFieldValidationDelegate(
            field: usernameField,
            validator: RegistrationFormValidator.usernameFieldValidator())
        self.emailFieldDelegate = TextFieldValidationDelegate(
            field: emailField,
            validator: RegistrationFormValidator.emailFieldValidator())
        self.passwordFieldDelegate = TextFieldValidationDelegate(
            field: passwordField,
            validator: RegistrationFormValidator.passwordFieldValidator())
        self.rePasswordFieldDelegate = TextFieldValidationDelegate(
            field: rePasswordField,
            validator: RegistrationFormValidator.passwordFieldValidator())
        self.mobileNumberFieldDelegate = TextFieldValidationDelegate(
            field: mobileNumberField,
            validator: RegistrationFormValidator.mobileNumberFieldValidator())
        self.tAndCSwitch = tAndCSwitch
        
        super.init()
        
        self.fieldValidationDelegates = [
            self.displayNameFieldDelegate,
            self.usernameFieldDelegate,
            self.emailFieldDelegate,
            self.passwordFieldDelegate,
            self.rePasswordFieldDelegate,
            self.mobileNumberFieldDelegate,
        ]
        
        let matchPasswordsError = ValidationError(code: 1000, localizedDescription: "Passwords do not match.")
        let matchPasswordsRule = GenericValidationRule(error: matchPasswordsError) { () -> Bool in
            
            if let passwordField = self.passwordFieldDelegate.field as? UITextField,
                let rePasswordField = self.rePasswordFieldDelegate.field as? UITextField {
                    return passwordField.text == rePasswordField.text
            }
            else {
                return false
            }
        }
        
        let tAndCError = ValidationError(code: 1001, localizedDescription: "Please accept terms and conditions.")
        let tAndCRule = GenericValidationRule(error: tAndCError) { () -> Bool in
            return tAndCSwitch.on
        }
        
        self.addValidationRules([
            matchPasswordsRule,
            tAndCRule,
            ], forType: .Submission)
    }
    
    // MARK: Field validators
    
    private class func displayNameFieldValidator() -> TextFieldValidator {
        
        let validator = TextFieldValidator()
        let characterSet = NSMutableCharacterSet.letterCharacterSet()
        characterSet.formUnionWithCharacterSet(NSCharacterSet.whitespaceCharacterSet())
        
        validator.addInputRules([
            TextValidationRule(maxLength: 20),
            TextValidationRule(characterSet: characterSet)
            ])
        
        validator.addValidationRules([
            TextValidationRule(minLength: 5)
            ], forType: .Eligibility)
        
        validator.optional = true
        
        return validator
    }
    
    private class func usernameFieldValidator() -> TextFieldValidator {
        
        let validator = TextFieldValidator()
        
        validator.addInputRules([
            TextValidationRule(maxLength: 10),
            TextValidationRule(characterSet: NSMutableCharacterSet.alphanumericCharacterSet())
            ]);
        
        validator.addValidationRules([
            TextValidationRule(minLength: 5)
            ], forType: .Eligibility);
        
        return validator
    }
    
    private class func emailFieldValidator() -> TextFieldValidator {
        
        let validator = TextFieldValidator()
        
        validator.addInputRules([
            TextValidationRule(maxLength: 255),
            TextValidationRule(characterSet: NSMutableCharacterSet.alphanumericCharacterSet())
            ]);
        
        validator.addValidationRules([
            TextValidationRule(minLength: 8)
            ], forType: .Eligibility);
        
        return validator
    }
    
    private class func passwordFieldValidator() -> TextFieldValidator {
        
        let validator = TextFieldValidator()
        
        validator.addInputRules([
            TextValidationRule(maxLength: 15),
            TextValidationRule(characterSet: NSMutableCharacterSet.alphanumericCharacterSet())
            ]);
        
        validator.addValidationRules([
            TextValidationRule(minLength: 8)
            ], forType: .Eligibility);
        
        return validator
    }
    
    private class func mobileNumberFieldValidator() -> TextFieldValidator {
        
        let validator = TextFieldValidator()
        
        validator.addInputRules([
            TextValidationRule(maxLength: 11),
            TextValidationRule(characterSet: NSMutableCharacterSet.decimalDigitCharacterSet())
            ]);
        
        validator.addValidationRules([
            TextValidationRule(minLength: 11)
            ], forType: .Eligibility);
        
        return validator
    }
}
