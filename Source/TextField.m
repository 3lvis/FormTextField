#import "TextField.h"

#import "TextFieldTypeManager.h"
#import "TextFieldClearButton.h"

@import Hex;

static const CGFloat FieldCellLeftMargin = 10.0f;
static const CGFloat TextFieldClearButtonWidth = 30.0f;
static const CGFloat TextFieldClearButtonHeight = 20.0f;
static const CGFloat TextFieldMinusButtonWidth = 30.0f;
static const CGFloat TextFieldMinusButtonHeight = 20.0f;
static const CGFloat TextFieldPlusButtonWidth = 30.0f;
static const CGFloat TextFieldPlusButtonHeight = 20.0f;

static BOOL enabledProperty;

static NSString * const TextFieldFontKey = @"font";
static NSString * const TextFieldFontSizeKey = @"font_size";
static NSString * const TextFieldBorderWidthKey = @"border_width";
static NSString * const TextFieldBorderColorKey = @"border_color";
static NSString * const TextFieldBackgroundColorKey = @"background_color";
static NSString * const TextFieldCornerRadiusKey = @"corner_radius";
static NSString * const TextFieldActiveBackgroundColorKey = @"active_background_color";
static NSString * const TextFieldActiveBorderColorKey = @"active_border_color";
static NSString * const TextFieldInactiveBackgroundColorKey = @"inactive_background_color";
static NSString * const TextFieldInactiveBorderColorKey = @"inactive_border_color";
static NSString * const TextFieldEnabledBackgroundColorKey = @"enabled_background_color";
static NSString * const TextFieldEnabledBorderColorKey = @"enabled_border_color";
static NSString * const TextFieldEnabledTextColorKey = @"enabled_text_color";
static NSString * const TextFieldDisabledBackgroundColorKey = @"disabled_background_color";
static NSString * const TextFieldDisabledBorderColorKey = @"disabled_border_color";
static NSString * const TextFieldDisabledTextColorKey = @"disabled_text_color";
static NSString * const TextFieldValidBackgroundColorKey = @"valid_background_color";
static NSString * const TextFieldValidBorderColorKey = @"valid_border_color";
static NSString * const TextFieldInvalidBackgroundColorKey = @"invalid_background_color";
static NSString * const TextFieldInvalidBorderColorKey = @"invalid_border_color";
static NSString * const TextFieldClearButtonColorKey = @"clear_button_color";
static NSString * const TextFieldMinusButtonColorKey = @"minus_button_color";
static NSString * const TextFieldPlusButtonColorKey = @"plus_button_color";

@interface TextField () <UITextFieldDelegate>

@property (nonatomic, getter = isModified) BOOL modified;
@property (nonatomic) UIButton *clearButton;
@property (nonatomic) UIButton *minusButton;
@property (nonatomic) UIButton *plusButton;

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

    self.delegate = self;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FieldCellLeftMargin, 0.0f)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;

    [self addTarget:self action:@selector(textFieldDidUpdate:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];

    self.returnKeyType = UIReturnKeyDone;

    [self createClearButton];
    [self addClearButton];
    [self createCountButtons];

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

- (void)setTypeString:(NSString *)typeString {
    _typeString = typeString;

    TextFieldType type;
    if ([typeString isEqualToString:@"name"]) {
        type = TextFieldTypeName;
    } else if ([typeString isEqualToString:@"username"]) {
        type = TextFieldTypeUsername;
    } else if ([typeString isEqualToString:@"phone"]) {
        type = TextFieldTypePhoneNumber;
    } else if ([typeString isEqualToString:@"number"]) {
        type = TextFieldTypeNumber;
    } else if ([typeString isEqualToString:@"float"]) {
        type = TextFieldTypeFloat;
    } else if ([typeString isEqualToString:@"address"]) {
        type = TextFieldTypeAddress;
    } else if ([typeString isEqualToString:@"email"]) {
        type = TextFieldTypeEmail;
    } else if ([typeString isEqualToString:@"date"]) {
        type = TextFieldTypeDate;
    } else if ([typeString isEqualToString:@"select"]) {
        type = TextFieldTypeSelect;
    } else if ([typeString isEqualToString:@"text"]) {
        type = TextFieldTypeDefault;
    } else if ([typeString isEqualToString:@"password"]) {
        type = TextFieldTypePassword;
    } else if ([typeString isEqualToString:@"count"]) {
        type = TextFieldTypeCount;
        [self addCountButtons];
    } else if (!typeString.length) {
        type = TextFieldTypeDefault;
    } else {
        type = TextFieldTypeUnknown;
    }

    self.type = type;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(TextField *)textField {
    BOOL selectable = (textField.type == TextFieldTypeSelect ||
                       textField.type == TextFieldTypeDate);

    if (selectable &&
        [self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidBeginEditing:)]) {
        [self.textFieldDelegate textFormFieldDidBeginEditing:self];
    }

    return !selectable;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.active = YES;
    self.modified = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.active = NO;
    if ([self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidEndEditing:)]) {
        [self.textFieldDelegate textFormFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string || [string isEqualToString:@"\n"]) return YES;

    BOOL validator = (self.inputValidator &&
                      [self.inputValidator respondsToSelector:@selector(validateReplacementString:withText:withRange:)]);

    if (validator) return [self.inputValidator validateReplacementString:string
                                                                withText:self.rawText withRange:range];

    return YES;
}

#pragma mark - UIResponder Overwritables

- (BOOL)becomeFirstResponder {
    if ([self.textFieldDelegate respondsToSelector:@selector(textFormFieldDidBeginEditing:)]) {
        [self.textFieldDelegate textFormFieldDidBeginEditing:self];
    }

    return [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    BOOL isTextField = (self.type != TextFieldTypeSelect &&
                        self.type != TextFieldTypeDate);

    return (isTextField && self.enabled) ?: [super canBecomeFirstResponder];
}

#pragma mark - Notifications

- (void)textFieldDidUpdate:(UITextField *)textField {
    if (!self.isValid) {
        self.valid = YES;
    }

    self.modified = YES;
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

- (void)createCountButtons {
    // Minus Button
    UIImage *minusImage = [TextFieldClearButton imageForSize:CGSizeMake(18, 18) andButtonType:TextFieldButtonTypeMinus];
    UIImage *minusImageTemplate = [minusImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusButton setImage:minusImageTemplate forState:UIControlStateNormal];

    [self.minusButton addTarget:self action:@selector(minusButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.minusButton.frame = CGRectMake(0.0f, 0.0f, TextFieldMinusButtonWidth, TextFieldMinusButtonHeight);

    // Plus Button
    UIImage *plusImage = [TextFieldClearButton imageForSize:CGSizeMake(18, 18) andButtonType:TextFieldButtonTypePlus];
    UIImage *plusImageTemplate = [plusImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.plusButton setImage:plusImageTemplate forState:UIControlStateNormal];

    [self.plusButton addTarget:self action:@selector(plusButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.plusButton.frame = CGRectMake(0.0f, 0.0f, TextFieldPlusButtonWidth, TextFieldPlusButtonHeight);
}

- (void)addCountButtons {
    self.leftView = self.minusButton;
    self.leftViewMode = UITextFieldViewModeAlways;

    self.rightView = self.plusButton;
    self.rightViewMode = UITextFieldViewModeAlways;

    self.textAlignment = NSTextAlignmentCenter;
}

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

- (void)minusButtonAction {
    NSNumber *number = @([self.rawText integerValue] - 1);
    if ([number integerValue] < 0) {
        self.rawText = @"0";
    } else {
        self.rawText = [number stringValue];
    }

    if ([self.textFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
	[self.textFieldDelegate textFormField:self
			    didUpdateWithText:self.rawText];
    }
}

- (void)plusButtonAction {
    NSNumber *number = @([self.rawText integerValue] + 1);
    self.rawText = [number stringValue];

    if ([self.textFieldDelegate respondsToSelector:@selector(textFormField:didUpdateWithText:)]) {
	[self.textFieldDelegate textFormField:self
			    didUpdateWithText:self.rawText];
    }
}

#pragma mark - Appearance

- (void)setActive:(BOOL)active {
    _active = active;

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

- (void)setCustomFont:(UIFont *)font {
    NSString *styleFont = [self.styles valueForKey:TextFieldFontKey];
    NSString *styleFontSize = [self.styles valueForKey:TextFieldFontSizeKey];
    if ([styleFont length] > 0) {
        if ([styleFontSize length] > 0) {
            font = [UIFont fontWithName:styleFont size:[styleFontSize floatValue]];
        } else {
            font = [UIFont fontWithName:styleFont size:font.pointSize];
        }
    }
    self.font = font;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    NSString *style = [self.styles valueForKey:TextFieldBorderWidthKey];
    if ([style length] > 0) {
        borderWidth = [style floatValue];
    }
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    NSString *style = [self.styles valueForKey:TextFieldBorderColorKey];
    if ([style length] > 0) {
        borderColor = [[UIColor alloc] initWithHex:style];
    }
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSString *style = [self.styles valueForKey:TextFieldBackgroundColorKey];
    if ([style length] > 0) {
        backgroundColor = [[UIColor alloc] initWithHex:style];
    }
    self.layer.backgroundColor = backgroundColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    NSString *style = [self.styles valueForKey:TextFieldCornerRadiusKey];
    if ([style length] > 0) {
        cornerRadius = [style floatValue];
    }
    self.layer.cornerRadius = cornerRadius;
}

- (void)setActiveBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldActiveBackgroundColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _activeBackgroundColor = color;
}

- (void)setActiveBorderColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldActiveBorderColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _activeBorderColor = color;
}

- (void)setInactiveBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldInactiveBackgroundColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _inactiveBackgroundColor = color;
}

- (void)setInactiveBorderColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldInactiveBorderColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _inactiveBorderColor = color;
}

- (void)setEnabledBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldEnabledBackgroundColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _enabledBackgroundColor = color;
}

- (void)setEnabledBorderColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldEnabledBorderColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _enabledBorderColor = color;
}

- (void)setEnabledTextColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldEnabledTextColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _enabledTextColor = color;
}

- (void)setDisabledBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldDisabledBackgroundColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _disabledBackgroundColor = color;
}

- (void)setDisabledBorderColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldDisabledBorderColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _disabledBorderColor = color;
}

- (void)setDisabledTextColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldDisabledTextColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _disabledTextColor = color;
    self.enabled = enabledProperty;
}

- (void)setValidBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldValidBackgroundColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _validBackgroundColor = color;
}

- (void)setValidBorderColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldValidBorderColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _validBorderColor = color;
}

- (void)setInvalidBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldInvalidBackgroundColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _invalidBackgroundColor = color;
}

- (void)setInvalidBorderColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldInvalidBorderColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    _invalidBorderColor = color;
    self.enabled = enabledProperty;
}

- (void)setClearButtonColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldClearButtonColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    self.clearButton.tintColor = color;
}

- (void)setMinusButtonColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldMinusButtonColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    self.minusButton.tintColor = color;
}

- (void)setPlusButtonColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:TextFieldPlusButtonColorKey];
    if ([style length] > 0) {
        color = [[UIColor alloc] initWithHex:style];
    }
    self.plusButton.tintColor = color;
}

@end
