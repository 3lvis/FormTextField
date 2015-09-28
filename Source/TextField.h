@import UIKit;

@import InputValidator;
@import Formatter;

typedef NS_ENUM(NSInteger, TextFieldInputType) {
    TextFieldInputTypeDefault = 0,
    TextFieldInputTypeName,
    TextFieldInputTypeUsername,
    TextFieldInputTypePhoneNumber,
    TextFieldInputTypeNumber,
    TextFieldInputTypeFloat,
    TextFieldInputTypeAddress,
    TextFieldInputTypeEmail,
    TextFieldInputTypePassword,
    TextFieldInputTypeCount,
    TextFieldInputTypeUnknown
};

@protocol TextFieldDelegate;

@interface TextField : UITextField

@property (nonatomic, copy) NSString *rawText;

@property (nonatomic) InputValidator *inputValidator;
@property (nonatomic) Formatter *formatter;

@property (nonatomic, copy) NSString *inputTypeString;
@property (nonatomic) TextFieldInputType inputType;

@property (nonatomic, getter = isValid)    BOOL valid;

@property (nonatomic, weak) id <TextFieldDelegate> textFieldDelegate;

- (void)updateActive:(BOOL)active;

- (BOOL)validate;

- (void)setCustomFont:(UIFont *)font  UI_APPEARANCE_SELECTOR;
- (void)setBorderWidth:(CGFloat)borderWidth UI_APPEARANCE_SELECTOR;
- (void)setBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setCornerRadius:(CGFloat)cornerRadius UI_APPEARANCE_SELECTOR;

- (void)setActiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setActiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInactiveBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setEnabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setEnabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setDisabledTextColor:(UIColor *)textColor UI_APPEARANCE_SELECTOR;

- (void)setValidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setValidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setInvalidBorderColor:(UIColor *)borderColor UI_APPEARANCE_SELECTOR;

- (void)setClearButtonColor:(UIColor *)color UI_APPEARANCE_SELECTOR;

@end

@protocol TextFieldDelegate <NSObject>

@optional

- (void)textFormFieldDidBeginEditing:(TextField *)textField;

- (void)textFormFieldDidEndEditing:(TextField *)textField;

- (void)textFormField:(TextField *)textField didUpdateWithText:(NSString *)text;

- (void)textFormFieldDidReturn:(TextField *)textField;

@end
