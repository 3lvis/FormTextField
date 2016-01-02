#import "CustomStyle.h"
@import Hex;
@import FormTextField;

@implementation CustomStyle

+ (void)apply {
    UIColor *enabledBackgroundColor = [UIColor whiteColor];
    UIColor *enabledBorderColor = [[UIColor alloc] initWithHex:@"DFDFDF"];
    UIColor *enabledTextColor = [[UIColor alloc] initWithHex:@"455C73"];
    UIColor *activeBorderColor = [[UIColor alloc] initWithHex:@"70D7FF"];

    [[FormTextField appearance] setBorderWidth:2];
    [[FormTextField appearance] setCornerRadius:10];
    [[FormTextField appearance] setAccessoryButtonColor:activeBorderColor];
    [[FormTextField appearance] setFont:[UIFont fontWithName:@"AvenitNext-Regular" size:15]];

    [[FormTextField appearance] setEnabledBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setEnabledBorderColor:enabledBorderColor];
    [[FormTextField appearance] setEnabledTextColor:enabledTextColor];

    [[FormTextField appearance] setValidBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setValidBorderColor:enabledBorderColor];
    [[FormTextField appearance] setValidTextColor:enabledTextColor];

    [[FormTextField appearance] setActiveBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setActiveBorderColor:activeBorderColor];
    [[FormTextField appearance] setActiveTextColor:enabledTextColor];

    [[FormTextField appearance] setInactiveBackgroundColor:enabledBackgroundColor];
    [[FormTextField appearance] setInactiveBorderColor:enabledBorderColor];
    [[FormTextField appearance] setInactiveTextColor:enabledTextColor];

    [[FormTextField appearance] setDisabledBackgroundColor:[[UIColor alloc] initWithHex:@"DFDFDF"]];
    [[FormTextField appearance] setDisabledBorderColor:[[UIColor alloc] initWithHex:@"DFDFDF"]];
    [[FormTextField appearance] setDisabledTextColor:[UIColor whiteColor]];

    [[FormTextField appearance] setInvalidBackgroundColor:[[UIColor alloc] initWithHex:@"FFC9C8"]];
    [[FormTextField appearance] setInvalidBorderColor:[[UIColor alloc] initWithHex:@"FF4B47"]];
    [[FormTextField appearance] setInvalidTextColor:[[UIColor alloc] initWithHex:@"FF4B47"]];
}

@end
