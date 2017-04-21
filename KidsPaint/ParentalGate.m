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
    UIView *containerView;
    UILabel *titleLabel;
    UILabel *messageLabel;
    UIImageView *closeButton;
}
@end

@implementation ParentalGate

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init
        
        
        // Container
        containerView = [UIView new];
        containerView.backgroundColor = UIColor.blueColor;
        
        UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleTapOnBackground:)];
        
        backgroundTap.numberOfTouchesRequired = 3;
        
        [containerView addGestureRecognizer:backgroundTap];
        
        [self addSubview:containerView];
    
        // Title
        titleLabel = [UILabel new];
        titleLabel.alpha = 0;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = UIColor.yellowColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = false;
        titleLabel.font = [UIFont systemFontOfSize:22];
        titleLabel.text = NSLocalizedString(@"ParentalGateTitle", nil);
        [containerView addSubview:titleLabel];

        // Message
        messageLabel = [UILabel new];
        messageLabel.alpha = 0;
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = UIColor.whiteColor;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.adjustsFontSizeToFitWidth = false;
        messageLabel.font = [UIFont systemFontOfSize:18];
        messageLabel.text = NSLocalizedString(@"ParentalGateType3FingerTapDesc", nil);
        [containerView addSubview:messageLabel];
        
        // Close Button
        closeButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close.png"]];
        closeButton.userInteractionEnabled = YES;
        closeButton.alpha = 0;
        
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(handleTapOnCloseButton:)];
        
        [closeButton addGestureRecognizer:closeTap];
        
        [self addSubview:closeButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    containerView.frame = CGRectMake(20, 20, self.bounds.size.width - 40, self.bounds.size.height - 40);
    
    CGRect labelRect = [titleLabel.text
                        boundingRectWithSize:CGSizeMake(containerView.bounds.size.width - 40, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22]}
                        context:nil];
    titleLabel.frame = CGRectMake(20,
                                      100,
                                      containerView.bounds.size.width - 40,
                                      labelRect.size.height);
 
    labelRect = [messageLabel.text
                        boundingRectWithSize:CGSizeMake(containerView.bounds.size.width - 40, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}
                        context:nil];
    messageLabel.frame = CGRectMake(20,
                                          titleLabel.frame.origin.y + titleLabel.frame.size.height + 20,
                                          containerView.bounds.size.width - 40,
                                          labelRect.size.height);
    
    closeButton.frame = CGRectMake(self.bounds.size.width - 35, 5, 30, 30);
}

-(void)show
{
    closeButton.alpha = 1;
    
    [UIView animateWithDuration:0.2f animations:^{
        titleLabel.alpha = 1;
        messageLabel.alpha = 1;
    }];
}

-(void)handleTapOnBackground:(UITapGestureRecognizer*)gesture
{
    if (self.delegate == nil) {
        return;
    }
    
    if (gesture.numberOfTouches != 3) {
        return;
    }
    
    [self.delegate didPassParentalGate];
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        [self removeFromSuperview];
    }
}

-(void)handleTapOnCloseButton:(UITapGestureRecognizer*)gesture
{
    if (self.delegate == nil) {
        return;
    }
    
    [self.delegate didCancelParentalGate];
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        [self removeFromSuperview];
    }
}

@end
