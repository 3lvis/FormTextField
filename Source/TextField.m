#import "TextField.h"

#import "TextFieldTypeManager.h"
#import "TextFieldClearButton.h"

@import Hex;

static const CGFloat FieldCellLeftMargin = 10.0f;
static const CGFloat TextFieldClearButtonWidth = 30.0f;
static const CGFloat TextFieldClearButtonHeight = 20.0f;

static BOOL enabledProperty;

@interface TextField () <UITextFieldDelegate>

@property (nonatomic) UIButton *clearButton;

// Style Properties
@property (nonatomic) UIColor *activeBackgroundColor;
@property (nonatomic) UIColor *activeBorderColor;
@property (nonatomic) UIColor *inactiveBackgroundColor;
@property (nonatomic) UIColor *inactiveBorderColor;

@property (nonatomic) UIColor *enabledBackgroundColor;
@property (nonatomic) UIColor *enabledBorderColor;
@property (nonatomic) UIColor *enabledTextColor;
@property (nonatomic) UIColor *disabledBackgroundColor;
@property (nonatomic) UIColor *disabledBorderColor;
@property (nonatomic) UIColor *disabledTextColor;

@property (nonatomic) UIColor *validBackgroundColor;
@property (nonatomic) UIColor *validBorderColor;
@property (nonatomic) UIColor *invalidBackgroundColor;
@property (nonatomic) UIColor *invalidBorderColor;

@end

@implementation TextField

@synthesize rawText = _rawText;

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    enabledProperty = YES;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.delegate = self;

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FieldCellLeftMargin, 0.0f)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;

    [self addTarget:self action:@selector(textFieldDidUpdate:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];

    self.returnKeyType = UIReturnKeyDone;

    [self createClearButton];
    [self addClearButton];

    return self;
}

#pragma mark - Setters

- (NSRange)currentRange {
    NSInteger startOffset = [self offsetFromPosition:self.beginningOfDocument
                                          toPosition:self.selectedTextRange.start];
    NSInteger endOffset = [self offsetFromPosition:self.beginningOfDocument
                                        toPosition:self.selectedTextRange.end];
    NSRange range = NSMakeRange(startOffset, endOffset-startOffset);

    return range;
}

- (void)setText:(NSString *)text {
    UITextRange *textRange = self.selectedTextRange;
    NSString *newRawText = [self.formatter formatString:text
                                                reverse:YES];
    NSRange range = [self currentRange];

    BOOL didAddText  = (newRawText.length > self.rawText.length);
    BOOL didFormat   = (text.length > super.text.length);
    BOOL cursorAtEnd = (newRawText.length == range.location);

    if ((didAddText && didFormat) || (didAddText && cursorAtEnd)) {
        self.selectedTextRange = textRange;
        [super setText:text];
    } else {
        [super setText:text];
        self.selectedTextRange = textRange;
    }
}

- (void)setRawText:(NSString *)rawText {
    BOOL shouldFormat = (self.formatter && (rawText.length >= _rawText.length ||
                                            ![rawText isEqualToString:_rawText]));

    if (shouldFormat) {
        self.text = [self.formatter formatString:rawText reverse:NO];
    } else {
        self.text = rawText;
    }

    _rawText = rawText;
}

- (void)setInputTypeString:(NSString *)inputTypeString {
    _inputTypeString = inputTypeString;

    TextFieldInputType inputType;
    if ([inputTypeString isEqualToString:@"name"]) {
        inputType = TextFieldInputTypeName;
    } else if ([inputTypeString isEqualToString:@"username"]) {
        inputType = TextFieldInputTypeUsername;
    } else if ([inputTypeString isEqualToString:@"phone"]) {
        inputType = TextFieldInputTypePhoneNumber;
    } else if ([inputTypeString isEqualToString:@"number"]) {
        inputType = TextFieldInputTypeNumber;
    } else if ([inputTypeString isEqualToString:@"float"]) {
        inputType = TextFieldInputTypeFloat;
    } else if ([inputTypeString isEqualToString:@"address"]) {
        inputType = TextFieldInputTypeAddress;
    } else if ([inputTypeString isEqualToString:@"email"]) {
        inputType = TextFieldInputTypeEmail;
    } else if ([inputTypeString isEqualToString:@"text"]) {
        inputType = TextFieldInputTypeDefault;
    } else if ([inputTypeString isEqualToString:@"password"]) {
        inputType = TextFieldInputTypePassword;
    } else if ([inputTypeString isEqualToString:@"count"]) {
        inputType = TextFieldInputTypeCount;
    } else if (!inputTypeString.length) {
        inputType = TextFieldInputTypeDefault;
    } else {
        inputType = TextFieldInputTypeUnknown;
    }

    self.inputType = inputType;
}

- (void)setInputType:(TextFieldInputType)inputType {
    _inputType = inputType;

    TextFieldTypeManager *typeManager = [TextFieldTypeManager new];
    [typeManager setUpType:inputType forTextField:self];
}

#pragma mark - Getters

- (NSString *)rawText {
    if (self.formatter) {
        return [self.formatter formatString:_rawText reverse:YES];
    }

    return _rawText;
}

#pragma mark - Public

- (BOOL)validate {
    BOOL isValid = [self.inputValidator validateString:self.text];
    self.valid = isValid;
    return isValid;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(TextField *)textField {
    [self updateActive:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateActive:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string || [string isEqualToString:@"\n"]) return YES;

    BOOL validator = (self.inputValidator &&
                      [self.inputValidator respondsToSelector:@selector(validateReplacementString:withText:withRange:)]);

    if (validator) return [self.inputValidator validateReplacementString:string
                                                                withText:self.text withRange:range];

    return YES;
}

#pragma mark - Notifications

- (void)textFieldDidUpdate:(UITextField *)textField {
    if (!self.isValid) {
        self.valid = YES;
    }

    self.rawText = self.text;

    if ([self.textFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
        [self.textFieldDelegate textFormField:self
                            didUpdateWithText:self.rawText];
    }
}

- (void)textFieldDidReturn:(UITextField *)textField {
    if ([self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidReturn:)]) {
        [self.textFieldDelegate textFormFieldDidReturn:self];
    }
}

#pragma mark - Buttons

- (void)createClearButton {
    UIImage *clearImage = [TextFieldClearButton imageForSize:CGSizeMake(18, 18) andButtonType:TextFieldButtonTypeClear];
    UIImage *clearImageTemplate = [clearImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setImage:clearImageTemplate forState:UIControlStateNormal];

    [self.clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.frame = CGRectMake(0.0f, 0.0f, TextFieldClearButtonWidth, TextFieldClearButtonHeight);
}

- (void)addClearButton {
    self.rightView = self.clearButton;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - Actions

- (void)clearButtonAction {
    self.rawText = nil;

    if ([self.textFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
        [self.textFieldDelegate textFormField:self
                            didUpdateWithText:self.rawText];
    }
}

#pragma mark - Appearance

- (void)updateActive:(BOOL)active {
    if (active) {
        self.backgroundColor = self.activeBackgroundColor;
        self.layer.backgroundColor = self.activeBackgroundColor.CGColor;
        self.layer.borderColor = self.activeBorderColor.CGColor;
    } else {
        self.backgroundColor = self.inactiveBackgroundColor;
        self.layer.backgroundColor = self.inactiveBackgroundColor.CGColor;
        self.layer.borderColor = self.inactiveBorderColor.CGColor;
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];

    enabledProperty = enabled;

    if (enabled) {
        self.backgroundColor = self.enabledBackgroundColor;
        self.layer.borderColor = self.enabledBorderColor.CGColor;
        self.textColor = self.enabledTextColor;
    } else {
        self.backgroundColor = self.disabledBackgroundColor;
        self.layer.borderColor = self.disabledBorderColor.CGColor;
        self.textColor = self.disabledTextColor;
    }
}

- (void)setValid:(BOOL)valid {
    _valid = valid;

    if (!self.isEnabled) return;

    if (valid) {
        self.backgroundColor = self.validBackgroundColor;
        self.layer.borderColor = self.validBorderColor.CGColor;
    } else {
        self.backgroundColor = self.invalidBackgroundColor;
        self.layer.borderColor = self.invalidBorderColor.CGColor;
    }
}

#pragma mark - Styling

- (void)setCustomFont:(UIFont *)font {
    self.font = font;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.layer.backgroundColor = backgroundColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (void)setActiveBackgroundColor:(UIColor *)color {
    _activeBackgroundColor = color;
}

- (void)setActiveBorderColor:(UIColor *)color {
    _activeBorderColor = color;
}

- (void)setInactiveBackgroundColor:(UIColor *)color {
    _inactiveBackgroundColor = color;
}

- (void)setInactiveBorderColor:(UIColor *)color {
    _inactiveBorderColor = color;
}

- (void)setEnabledBackgroundColor:(UIColor *)color {
    _enabledBackgroundColor = color;
}

- (void)setEnabledBorderColor:(UIColor *)color {
    _enabledBorderColor = color;
}

- (void)setEnabledTextColor:(UIColor *)color {
    _enabledTextColor = color;
}

- (void)setDisabledBackgroundColor:(UIColor *)color {
    _disabledBackgroundColor = color;
}

- (void)setDisabledBorderColor:(UIColor *)color {
    _disabledBorderColor = color;
}

- (void)setDisabledTextColor:(UIColor *)color {
    _disabledTextColor = color;
    self.enabled = enabledProperty;
}

- (void)setValidBackgroundColor:(UIColor *)color {
    _validBackgroundColor = color;
}

- (void)setValidBorderColor:(UIColor *)color {
    _validBorderColor = color;
}

- (void)setInvalidBackgroundColor:(UIColor *)color {
    _invalidBackgroundColor = color;
}

- (void)setInvalidBorderColor:(UIColor *)color {
    _invalidBorderColor = color;
    self.enabled = enabledProperty;
}

- (void)setClearButtonColor:(UIColor *)color {
    self.clearButton.tintColor = color;
}

@end
