//
//  ParentalGate.h
//  KidsPaint
//
//  Created by Jonas Frid on 2017-04-13.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParentalGateDelegate <NSObject>

@optional
- (void)didPassParentalGate;
- (void)didCancelParentalGate;

@end

@interface ParentalGate : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<ParentalGateDelegate> delegate;

-(void)show;

@end
