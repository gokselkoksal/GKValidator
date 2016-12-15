//
//  ViewController.swift
//  Registration
//
//  Created by Göksel Köksal on 28/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import UIKit
import GKValidator

class RegistrationViewController: UIViewController, FormValidatorDelegate {
    
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var registerBarButton: UIBarButtonItem!
    @IBOutlet weak var tAndCSwitch: UISwitch!
    
    var formValidator: RegistrationFormValidator!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.customizeField(displayNameField)
        self.customizeField(usernameField)
        self.customizeField(emailField)
        self.customizeField(passwordField)
        self.customizeField(rePasswordField)
        self.customizeField(mobileNumberField)
        
        self.formValidator = RegistrationFormValidator(
            displayNameField: self.displayNameField,
            usernameField: self.usernameField,
            emailField: self.emailField,
            passwordField: self.passwordField,
            rePasswordField: self.rePasswordField,
            mobileNumberField: self.mobileNumberField,
            tAndCSwitch: self.tAndCSwitch
        )
        self.formValidator.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func registerTapped(_ sender: AnyObject) {
        
        let resultPairs = self.formValidator.validateForType(ValidationType.submission)
        var success = true
        
        for resultPair in resultPairs {
            success = resultPair.result.isSuccess
        }
        
        if success {
            
            let alert = UIAlertController(title: nil, message: "Form submitted!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func fieldDidEndEditing(_ textField: UITextField!) {
        
        if let validationDelegate = self.formValidator.fieldValidationDelegateForField(textField) {
            
            if let lastKnownResult = validationDelegate.validator.validationRuleSets[.eligibility]?.lastKnownResult {
                textField.layer.borderColor = (lastKnownResult.isSuccess ? UIColor.lightGray : UIColor.red).cgColor
            }
        }
    }
    
    // MARK: FormValidatorDelegate
    
    func formValidator(_ formValidator: FormValidator, didValidateForType type: ValidationType, resultPairs: [ObjectValidationResultPair]) {
        
        switch type {
            
        case .submission:
            
            for resultPair in resultPairs {
                
                switch resultPair.result {
                case .failure(let errors):
                    if let error = errors.first {
                        self.showAlertForError(error)
                    }
                default:
                    break
                }
            }
            
        default:
            break
        }
    }
    
    func formValidator(_ formValidator: FormValidator, didChangeState state: ValidationState) {
        
        var string: String = ""
        
        if state.contains(ValidationState.Eligible) {
            
            string += ">Eligible"
            self.registerBarButton.isEnabled = true
        }
        else {
            self.registerBarButton.isEnabled = false
        }
        
        if state.contains(ValidationState.Complete) {
            string += ">Complete"
        }
        
        if state.contains(ValidationState.Submittable) {
            string += ">Submittable"
        }
        
        if (string.characters.count == 0)
        {
            string = ">Default"
        }
        
        print(string, terminator: "\n")
    }
    
    // MARK: Private
    
    fileprivate func showAlertForError(_ error: NSError) {
        
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func customizeField(_ field: UITextField) {
        
        field.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        field.rightViewMode = .always
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 5
        field.addTarget(self, action: #selector(RegistrationViewController.fieldDidEndEditing(_:)), for: .editingDidEnd)
    }
}
