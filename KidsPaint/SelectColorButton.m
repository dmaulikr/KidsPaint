//
//  SelectColorButton.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectColorButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation SelectColorButton

@synthesize color = _color;
@synthesize contentMargin = _contentMargin;
@synthesize size = _size;
@synthesize isSystemColor = _isSystemColor;

+(id)buttonWithColor:(CustomColor*)color andSize:(CGSize)size andContentMargin:(CGFloat)margin
{
    // Create the button
    SelectColorButton *button = (SelectColorButton*)[super buttonWithType:UIButtonTypeCustom];
    
    // Store the params
    button.color = color;
    button.contentMargin = margin;
    button.size = size;
    
    // Create a gradient background for the button
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = { 0.0, 0.3, 1.0 };
    
    UIColor *startColor = [UIColor colorWithRed:color.rgb.red green:color.rgb.green blue:color.rgb.blue alpha:0.1];
    UIColor *mainColor = [UIColor colorWithRed:color.rgb.red green:color.rgb.green blue:color.rgb.blue alpha:0.5];
    UIColor *endColor = [UIColor colorWithRed:color.rgb.red green:color.rgb.green blue:color.rgb.blue alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects: 
                       (id)[startColor CGColor], 
                       (id)[mainColor CGColor], 
                       (id)[endColor CGColor], 
                       nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(margin, margin);
    CGPoint endPoint = CGPointMake(size.width - (2 * margin), size.height - (2 * margin));
    
    CGContextAddEllipseInRect(context, 
                              CGRectMake(margin, margin, size.width - (2 * margin), size.height - (2 * margin)));
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *buttonImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    
	UIGraphicsEndImageContext();
    
    // Create a drop shadow
    button.layer.shadowOffset = CGSizeMake(3, 3);
    button.layer.shadowRadius = 3;
    button.layer.shadowOpacity = 0.7;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(3, 3, size.width - 7, size.height - 7)];
    button.layer.shadowPath = path.CGPath;
    
    // Return the button
    return button;
}

-(UIColor*)getUIColor
{
    if (_color != nil)
    {
        return [_color getUIColor];
    }
    else
    {
        return nil;
    }
}

@end
