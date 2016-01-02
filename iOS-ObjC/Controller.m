#import "Controller.h"
@import FormTextField;
@import Hex;

@interface Controller () <FormTextFieldDelegate>

@property (nonatomic) FormTextField *emailField;

@end

@implementation Controller

- (FormTextField *)emailField {
    if (!_emailField) {
        CGFloat margin = 20;
        _emailField = [[FormTextField alloc] initWithFrame:CGRectMake(margin, 40, self.view.frame.size.width - (margin * 2), 60)];
        _emailField.textFieldDelegate = self;
    }

    return _emailField;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor alloc] initWithHex:@"D4F3FF"];
    [self.view addSubview:self.emailField];
    [self.emailField becomeFirstResponder];
}

#pragma mark - FormTextFieldDelegate

- (void)formTextFieldDidBeginEditing:(FormTextField * __nonnull)textField {

}

- (void)formTextFieldDidEndEditing:(FormTextField * __nonnull)textField {

}

- (void)formTextField:(FormTextField * __nonnull)textField didUpdateWithText:(NSString * __nullable)text {
    NSLog(@"updated text: %@", text);
}

- (void)formTextFieldDidReturn:(FormTextField * __nonnull)textField {

}

@end
