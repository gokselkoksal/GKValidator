# GKValidator

[![CI Status](http://img.shields.io/travis/gokselkoksal/GKValidator.svg?style=flat)](https://travis-ci.org/gokselkoksal/GKValidator)
[![Version](https://img.shields.io/cocoapods/v/GKValidator.svg?style=flat)](http://cocoapods.org/pods/GKValidator)
[![License](https://img.shields.io/cocoapods/l/GKValidator.svg?style=flat)](http://cocoapods.org/pods/GKValidator)
[![Platform](https://img.shields.io/cocoapods/p/GKValidator.svg?style=flat)](http://cocoapods.org/pods/GKValidator)

## Purpose

Validation logic disappears when implemented using various `UITextFieldDelegate` methods. It generally becomes extremely hard to fulfil complicated requirements, and when you do, it becomes really hard to understand/reuse/maintain later on. `GKValidator` makes this process easier.

## Components

```
ValidationRule
      |
FieldValidator
      |
FieldValidationDelegate
      |
FormValidator
```

### Validation Rule

`ValidationRule<Type>` or `GenericValidationRule` encapsulates a rule to be used for validation. Defining rules is as simple as following:

```swift
// Define a rule to check if (string.length > 10).
let lengthRule = ValidationRule<String> { (value) -> Bool in
    return value?.characters.count > 10
}

// Define an error object to be returned upon failure. (Optional)
let matchPasswordsError = ValidationError(code: 1000, localizedDescription: "Passwords do not match.")

// Define a generic rule to check if password fields' text match.
let matchPasswordsRule = GenericValidationRule(error: matchPasswordsError) { () -> Bool in
    return passwordField.text == rePasswordField.text
}
```
### Field Validator

`FieldValidator` keeps all rules to validate a field during its lifecycle.

#### Validating Input

You should validate user input before accepting it. Use `inputRuleSet` to store your rules for this purpose.

#### Validating State

You should apply 3 type of validations to determine field's state.

- `Completeness`: Validate to see if field is complete, so that we can proceed to next field.
- `Eligibility`: Validate to see if field's value is valid, so that we can enable submit button.
- `Submission`: Validate to see if field's value matches with our criteria (for server, database, etc.) after submit button is tapped.

#### Sample Validator

If requirements are as follows:

- Should not accept more than 12 characters.
- Should only accept digits.
- Should proceed to next field if it has 12 characters already.
- Should not be eligible to submit if it has less than 8 characters.
- Should not be submittable if it does not start with digit 9. (Alert: "Number should start with 9.")

Your validator would be:

```swift
let validator = TextFieldValidator()

// Add input rules
validator.addInputRules([
    TextValidationRule(maxLength: 12),
    TextValidationRule(characterSet: NSCharacterSet.decimalDigitCharacterSet())
    ])

// Add completeness rules
validator.addValidationRules([TextValidationRule(minLength: 12)], forType: .Completeness)

// Add eligibility rules
validator.addValidationRules([TextValidationRule(minLength: 8)], forType: .Eligibility)

// Add submission rules

let firstDigitError = ValidationError(code: 1002, localizedDescription: "Number should start with 9.")
let firstDigitRule = TextValidationRule(error: firstDigitError) { (value) -> Bool in
    if let digit = Int(String(value?.characters.first)) {
        return digit == 9
    }
    else {
        return false
    }
}

validator.addValidationRules([firstDigitRule], forType: .Submission)
```

### Field Validation Delegate

`FieldValidationDelegate` expects a field of type `ValidatableField` and a validator. It simply takes care of validation.

```swift
FieldValidationDelegate<String>(field: emailField, validator: emailValidator)
```

### Form Validator

`FormValidator` encapsulates logic for field-validation and general form-validation.

- Observes `FieldValidationDelegate` objects to determine overall form state. This way you can easily see if your form is ready for submission or not.
- Defines general validation rules for form. (Like: `passwordField.text == rePasswordField.text`)

> It's recommended to create a subclass of `FormValidator` for each form you have.

#### Sample Form

Your subclass' init method should look like this:

```swift
// Create field delegates.
...

// Pass field delegates for observation.
self.fieldValidationDelegates = [
    displayNameFieldDelegate,
    usernameFieldDelegate,
    emailFieldDelegate,
    passwordFieldDelegate,
    rePasswordFieldDelegate,
    mobileNumberFieldDelegate,
    ]

// Add generic form validation rules.

let matchPasswordsError = ValidationError(code: 1000, localizedDescription: "Passwords do not match.")
let matchPasswordsRule = GenericValidationRule(error: matchPasswordsError) { () -> Bool in
    return passwordField.text == rePasswordField.text
}

let tAndCError = ValidationError(code: 1001, localizedDescription: "Please accept terms and conditions.")
let tAndCRule = GenericValidationRule(error: tAndCError) { () -> Bool in
    return tAndCSwitch.on
}

self.addValidationRules([
    matchPasswordsRule,
    tAndCRule,
    ], forType: .Submission)
```

Please see Example project for more details.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

GKValidator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GKValidator"
```

### Support

* **Swift 2.2**: Use version `0.X.X`
* **Swift 3**: Use version `1.X.X`
* **Swift 4**: Use version `2.X.X`

## Author

Göksel Köksal, gokselkoksal@gmail.com

## License

GKValidator is available under the MIT license. See the LICENSE file for more info.
