//
//  CMYK.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CMYK.h"

@implementation CMYK

@synthesize cyan = _cyan;
@synthesize magenta = _magenta;
@synthesize yellow = _yellow;
@synthesize key = _key;

+(id)cmykWithCyan:(CGFloat)cyan andMagenta:(CGFloat)magenta andYellow:(CGFloat)yellow andKey:(CGFloat)key
{
    CMYK *newColor = [CMYK new];
    
    newColor.cyan = cyan;
    newColor.magenta = magenta;
    newColor.yellow = yellow;
    newColor.key = key;
    
    return newColor;
}

@end
