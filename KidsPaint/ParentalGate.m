//
//  ParentalGate.m
//  KidsPaint
//
//  Created by Jonas Frid on 2017-04-13.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
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
        self.backgroundColor = UIColor.blueColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleTap:)];
        
        [self addGestureRecognizer:tap];
    
        titleLabel = [UILabel new];
        titleLabel.alpha = 0;
        titleLabel.textColor = UIColor.yellowColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = false;
        titleLabel.font = [UIFont systemFontOfSize:22];
        titleLabel.text = NSLocalizedString(@"ParentalGateTitle", nil);
        [self addSubview:titleLabel];

        messageLabel = [UILabel new];
        messageLabel.alpha = 0;
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = UIColor.whiteColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.adjustsFontSizeToFitWidth = false;
        messageLabel.font = [UIFont systemFontOfSize:18];
        messageLabel.text = NSLocalizedString(@"ParentalGateType3FingerTapDesc", nil);
        [self addSubview:messageLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    titleLabel.frame = CGRectMake(20, 100, self.bounds.size.width - 40, 30);
 
    CGRect labelRect = [messageLabel.text
                        boundingRectWithSize:CGSizeMake(self.bounds.size.width - 40, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}
                        context:nil];
    messageLabel.frame = CGRectMake(20, 150, labelRect.size.width, labelRect.size.height);
}

-(void)show
{
    [UIView animateWithDuration:0.2f animations:^{
        titleLabel.alpha = 1;
        messageLabel.alpha = 1;
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
