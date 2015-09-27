#import "TextFielDefaultStyle.h"
#import "TextField.h"
@import Hex;

@implementation TextFielDefaultStyle

+ (void)applyStyle {
    [[TextField appearance] setActiveBackgroundColor:[[UIColor alloc] initWithHex:@"C0EAFF"]];
    [[TextField appearance] setActiveBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[TextField appearance] setBackgroundColor:[UIColor yellowColor]];
    [[TextField appearance] setBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[TextField appearance] setBorderWidth:1.0f];
    [[TextField appearance] setAccessoryColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[TextField appearance] setCornerRadius:5.0f];
    [[TextField appearance] setDisabledBackgroundColor:[[UIColor alloc] initWithHex:@"F5F5F8"]];
    [[TextField appearance] setDisabledBorderColor:[[UIColor alloc] initWithHex:@"DEDEDE"]];
    [[TextField appearance] setDisabledTextColor:[UIColor grayColor]];
    [[TextField appearance] setEnabledBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[TextField appearance] setEnabledBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[TextField appearance] setEnabledTextColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[TextField appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15.0]];
    [[TextField appearance] setInactiveBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[TextField appearance] setInactiveBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
    [[TextField appearance] setInvalidBackgroundColor:[[UIColor alloc] initWithHex:@"FFD7D7"]];
    [[TextField appearance] setInvalidBorderColor:[[UIColor alloc] initWithHex:@"EC3031"]];
    [[TextField appearance] setTextColor:[[UIColor alloc] initWithHex:@"455C73"]];
    [[TextField appearance] setValidBackgroundColor:[[UIColor alloc] initWithHex:@"E1F5FF"]];
    [[TextField appearance] setValidBorderColor:[[UIColor alloc] initWithHex:@"3DAFEB"]];
}

@end
