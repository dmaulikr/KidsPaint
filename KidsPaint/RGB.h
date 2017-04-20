//
//  RGB.h
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGB : NSObject

@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;

+(id)rgbWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

@end
