#import "TextFieldTypeManager.h"

@implementation TextFieldTypeManager

- (void)setUpType:(TextFieldInputType)type forTextField:(UITextField *)textField {
    switch (type) {
        case TextFieldInputTypeDefault     : [self setupDefaultTextField:textField]; break;
        case TextFieldInputTypeName        : [self setupNameTextField:textField]; break;
        case TextFieldInputTypeUsername    : [self setupUsernameTextField:textField]; break;
        case TextFieldInputTypePhoneNumber : [self setupPhoneNumberTextField:textField]; break;
        case TextFieldInputTypeNumber      : [self setupNumberTextField:textField]; break;
        case TextFieldInputTypeFloat       : [self setupNumberTextField:textField]; break;
        case TextFieldInputTypeAddress     : [self setupAddressTextField:textField]; break;
        case TextFieldInputTypeEmail       : [self setupEmailTextField:textField]; break;
        case TextFieldInputTypePassword    : [self setupPasswordTextField:textField]; break;
        case TextFieldInputTypeCount       : [self setupCountTextField:textField]; break;

        case TextFieldInputTypeUnknown:
            abort();
    }
}

#pragma mark - TextFieldType

- (void)setupDefaultTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = NO;
}

- (void)setupNameTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.secureTextEntry = NO;
}

- (void)setupUsernameTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.secureTextEntry = NO;
}

- (void)setupPhoneNumberTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.secureTextEntry = NO;
}

- (void)setupNumberTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.secureTextEntry = NO;
}

- (void)setupAddressTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeDefault;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = NO;
}

- (void)setupEmailTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.secureTextEntry = NO;
}

- (void)setupPasswordTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = YES;
}

- (void)setupCountTextField:(UITextField *)textField {
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.secureTextEntry = NO;
}

@end
