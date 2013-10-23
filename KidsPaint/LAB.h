//
//  LAB.h
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAB : NSObject

@property (nonatomic) CGFloat l;
@property (nonatomic) CGFloat a;
@property (nonatomic) CGFloat b;

+(id)labWithL:(CGFloat)l andA:(CGFloat)a andB:(CGFloat)b;

@end
