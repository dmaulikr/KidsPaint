//
//  LAB.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import "LAB.h"

@implementation LAB

@synthesize l = _l;
@synthesize a = _a;
@synthesize b = _b;

+(id)labWithL:(CGFloat)l andA:(CGFloat)a andB:(CGFloat)b
{
    LAB *newColor = [LAB new];
    
    newColor.l = l;
    newColor.a = a;
    newColor.b = b;
    
    return newColor;
}

@end
