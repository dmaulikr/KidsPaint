//
//  HSL.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import "HSL.h"

@implementation HSL

@synthesize hue = _hue;
@synthesize saturation = _saturation;
@synthesize lightness = _lightness;

+(id)hslWithHue:(CGFloat)hue andSaturation:(CGFloat)saturation andLightness:(CGFloat)lightness
{
    HSL *newColor = [HSL new];
    
    newColor.hue = hue;
    newColor.saturation = saturation;
    newColor.lightness = lightness;
    
    return newColor;
}

@end
