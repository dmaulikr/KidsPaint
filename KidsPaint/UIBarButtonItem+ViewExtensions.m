//
//  UIBarButtonItem+ViewExtensions.m
//  KidsPaint
//
//  Created by Jonas Frid on 2017-04-20.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import "UIBarButtonItem+ViewExtensions.h"

@implementation UIBarButtonItem (ViewExtensions)

- (CGRect)frameInView:(UIView *)v {
    
    UIView *theView = self.customView;
    if (!theView.superview && [self respondsToSelector:@selector(view)]) {
        theView = [self performSelector:@selector(view)];
    }
    
    UIView *parentView = theView.superview;
    NSArray *subviews = parentView.subviews;
    
    NSUInteger indexOfView = [subviews indexOfObject:theView];
    NSUInteger subviewCount = subviews.count;
    
    if (subviewCount > 0 && indexOfView != NSNotFound) {
        UIView *button = [parentView.subviews objectAtIndex:indexOfView];
        return [button convertRect:button.bounds toView:v];
    } else {
        return CGRectZero;
    }
}

@end
