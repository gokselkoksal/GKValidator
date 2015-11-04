//
//  FormValidator.swift
//  EruValidator
//
//  Created by Göksel Köksal on 28/06/15.
//  Copyright © 2015 Eru. All rights reserved.
//

import Foundation

public typealias ObjectValidationResultPair = (object: AnyObject, result: ValidationResult)

public protocol FormValidatorDelegate {
    
    func formValidator(formValidator: FormValidator, didChangeState state: ValidationState)
    func formValidator(formValidator: FormValidator, didValidateForType type: ValidationType, resultPairs: [ObjectValidationResultPair])
}

public class FormValidator : NSObject {
    
    public var delegate: FormValidatorDelegate?
    public var validationRuleSets: [ValidationType: GenericValidationRuleSet] = [ValidationType: GenericValidationRuleSet]()
    
    public private(set) var state: ValidationState = [] {
        didSet {
            
            if oldValue.rawValue == state.rawValue {
                return
            }
            
            if state.contains(.Submittable) && !state.contains(.Eligible) {
                state.remove(.Submittable)
                
            }
            
            delegate?.formValidator(self, didChangeState: state)
        }
    }
    
    // TODO: Change FieldValidationDelegate<String> to FieldValidationDelegate<AnyObject> when Swift supports type covariance.
    public var fieldValidationDelegates: [FieldValidationDelegate<String>]? {
        didSet {
            
            if let fieldDelegates = fieldValidationDelegates {
                
                NSNotificationCenter.defaultCenter().removeObserver(self,
                    name: FieldDidChangeNotification,
                    object: nil)
                
                for fieldDelegate in fieldDelegates {
                    NSNotificationCenter.defaultCenter().addObserver(self,
                        selector: "fieldDidChange:",
                        name: FieldDidChangeNotification,
                        object: fieldDelegate)
                }
            }
        }
    }
    
    // MARK: Public methods
    
    public func fieldValidationDelegateForField(field: AnyObject) -> FieldValidationDelegate<String>? {
        
        if let fieldValidationDelegates = fieldValidationDelegates {
            for fieldDelegate in fieldValidationDelegates {
                if field === fieldDelegate.field {
                    return fieldDelegate
                }
            }
        }
        
        return nil
    }
    
    public func addValidationRules(rules: [GenericValidationRule], forType type: ValidationType) {
        
        if let ruleSet = validationRuleSets[type] {
            ruleSet.rules.appendContentsOf(rules)
        }
        else {
            validationRuleSets[type] = GenericValidationRuleSet(rules: rules)
        }
    }
    
    public func validateForType(type: ValidationType) -> [ObjectValidationResultPair] {
        
        guard let fieldDelegates = fieldValidationDelegates
            where (type == ValidationType.Submission ? state.contains(ValidationState.Eligible) : true) else {
            return []
        }
        
        var resultPairs = [ObjectValidationResultPair]()
        var success = true
        
        // Validate field rules.
        
        for fieldDelegate in fieldDelegates {
            
            if let field = fieldDelegate.field {
                
                let result = fieldDelegate.validateForType(type)
                
                if success {
                    success = result.isSuccess
                }
                
                resultPairs.append((object: field, result: result));
            }
        }
            
        // Validate form rules.
            
        if let ruleSet = validationRuleSets[type] where success {
            
            let result = ruleSet.validate()
            success = result.isSuccess
            resultPairs.append((object: self, result: result))
        }
        
        // Determine state and return.
        
        let formState = affectedStateForValidationType(type)
        
        if success {
            state.insert(formState)
        }
        else {
            state.remove(formState)
        }
        
        delegate?.formValidator(self, didValidateForType: type, resultPairs: resultPairs)
        return resultPairs
    }
    
    // MARK: Private
    
    func fieldDidChange(notification: NSNotification) {
        
        validateForType(ValidationType.Eligibility)
    }
}
