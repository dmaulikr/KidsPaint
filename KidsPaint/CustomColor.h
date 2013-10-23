//
//  CustomColor.h
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-01-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMYK.h"
#import "RGB.h"
#import "LAB.h"
#import "HSL.h"

@interface CustomColor : NSObject

@property (nonatomic, strong) RGB *rgb;
@property (nonatomic, strong) HSL *hsl;

+(id)colorWithRGB:(RGB*)rgb;

-(CustomColor*)copyColor;

-(UIColor*)getUIColor;

-(RGB*)convertToRGBfromCMYK:(CMYK*)cmyk;
-(RGB*)convertToRGBfromLAB:(LAB*)lab;
-(RGB*)convertToRGBfromHSL:(HSL*)hsl;

-(CMYK*)convertToCMYKfromRGB:(RGB*)rgb;

-(LAB*)convertToLABfromRGB:(RGB*)rgb;

-(HSL*)convertToHSLfromRGB:(RGB*)rgb;

-(RGB*)mixWithColor:(RGB*)mixColor;

-(CGFloat)hueToRGBWithV1:(CGFloat)v1 andV2:(CGFloat)v2 andVH:(CGFloat)vH;

@end
