//
//  HSL.h
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSL : NSObject

@property (nonatomic) CGFloat hue;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat lightness;

+(id)hslWithHue:(CGFloat)hue andSaturation:(CGFloat)saturation andLightness:(CGFloat)lightness;

@end
