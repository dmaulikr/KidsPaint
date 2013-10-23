//
//  RGB.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RGB.h"

@implementation RGB

@synthesize red = _red;
@synthesize green = _green;
@synthesize blue = _blue;

+(id)rgbWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    RGB *newColor = [RGB new];
    
    newColor.red = red;
    newColor.green = green;
    newColor.blue = blue;
    
    return newColor;
}

@end
