#import "TextFieldClearButton.h"
@import Hex;

@interface TextFieldClearButton()

@property (nonatomic) TextFieldButtonType type;

@end

@implementation TextFieldClearButton

- (instancetype)initWithFrame:(CGRect)frame andButtonType:(TextFieldButtonType)type {
    self = [super initWithFrame:frame];

    _type = type;

    return self;
}

- (void)drawRect:(CGRect)rect {
    UIColor* color = [[UIColor alloc] initWithHex:@"3DAFEB"];
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.5, 0.5, rect.size.width - 1.0, rect.size.height - 1.0)];
    [color setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];

    if (self.type == TextFieldButtonTypeClear) {
        UIBezierPath *leftHandle = [UIBezierPath bezierPath];
        [leftHandle moveToPoint: CGPointMake(5.5, 12.5)];
        [leftHandle addCurveToPoint: CGPointMake(12.5, 5.5) controlPoint1: CGPointMake(12.5, 5.5) controlPoint2: CGPointMake(12.5, 5.5)];
        [color setStroke];
        leftHandle.lineWidth = 1;
        [leftHandle stroke];

        UIBezierPath* rightHandle = [UIBezierPath bezierPath];
        [rightHandle moveToPoint: CGPointMake(5.5, 5.5)];
        [rightHandle addCurveToPoint: CGPointMake(12.5, 12.5) controlPoint1: CGPointMake(12.5, 12.5) controlPoint2: CGPointMake(12.5, 12.5)];
        [color setStroke];
        rightHandle.lineWidth = 1;
        [rightHandle stroke];
    } else {
        UIBezierPath *horizontalHandle = [UIBezierPath bezierPath];
        [horizontalHandle moveToPoint: CGPointMake(5, 9)];
        [horizontalHandle addCurveToPoint: CGPointMake(13, 9) controlPoint1: CGPointMake(14, 9) controlPoint2: CGPointMake(11, 9)];
        [color setStroke];
        horizontalHandle.lineWidth = 1;
        [horizontalHandle stroke];

        if (self.type == TextFieldButtonTypePlus) {
            UIBezierPath* verticalHandle = [UIBezierPath bezierPath];
            [verticalHandle moveToPoint: CGPointMake(9, 5)];
            [verticalHandle addCurveToPoint: CGPointMake(9, 13) controlPoint1: CGPointMake(9, 14) controlPoint2: CGPointMake(9, 11)];
            [color setStroke];
            verticalHandle.lineWidth = 1;
            [verticalHandle stroke];
        }
    }
}

+ (UIImage *)imageForSize:(CGSize)size andButtonType:(TextFieldButtonType)type {
    TextFieldClearButton *view = [[TextFieldClearButton alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height) andButtonType:type];
    view.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
