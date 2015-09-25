@import UIKit;

typedef NS_ENUM(NSInteger, TextFieldButtonType) {
    TextFieldButtonTypeClear = 0,
    TextFieldButtonTypePlus,
    TextFieldButtonTypeMinus
};

@interface TextFieldClearButton : UIView

- (instancetype)initWithFrame:(CGRect)frame andButtonType:(TextFieldButtonType)type;

@end
