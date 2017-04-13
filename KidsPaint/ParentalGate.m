//
//  ParentalGate.m
//  KidsPaint
//
//  Created by Jonas Frid on 2017-04-13.
//
//

#import <Foundation/Foundation.h>
#import "ParentalGate.h"

@interface ParentalGate ()
{
    UILabel *titleLabel;
    UILabel *messageLabel;
}
@end

@implementation ParentalGate

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        self.backgroundColor = UIColor.blueColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleTap:)];
        
        [self addGestureRecognizer:tap];
    
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, frame.size.width - 40, 30)];
        titleLabel.textColor = UIColor.yellowColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = false;
        titleLabel.font = [UIFont systemFontOfSize:22];
        titleLabel.text = NSLocalizedString(@"ParentalGateTitle", nil);
        [self addSubview:titleLabel];

        messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = UIColor.whiteColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.adjustsFontSizeToFitWidth = false;
        messageLabel.font = [UIFont systemFontOfSize:18];
        messageLabel.text = NSLocalizedString(@"ParentalGateType3FingerTapDesc", nil);
        [self addSubview:messageLabel];
        
        CGRect labelRect = [messageLabel.text
                            boundingRectWithSize:CGSizeMake(frame.size.width - 40, 0)
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}
                            context:nil];
        messageLabel.frame = CGRectMake(20, 150, labelRect.size.width, labelRect.size.height);
    }
    return self;
}

-(void)show
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1;
    }];
}

-(void)handleTap:(UITapGestureRecognizer*)gesture
{
    if (self.delegate == nil) {
        return;
    }
    
    if (gesture.numberOfTouches == 3) {
        [self.delegate didPassParentalGate];
    } else {
        [self.delegate didCancelParentalGate];
    }
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        [self removeFromSuperview];
    }
}

@end
