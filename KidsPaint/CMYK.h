//
//  CMYK.h
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMYK : NSObject

@property (nonatomic) CGFloat cyan;
@property (nonatomic) CGFloat magenta;
@property (nonatomic) CGFloat yellow;
@property (nonatomic) CGFloat key;

+(id)cmykWithCyan:(CGFloat)cyan andMagenta:(CGFloat)magenta andYellow:(CGFloat)yellow andKey:(CGFloat)key;

@end
