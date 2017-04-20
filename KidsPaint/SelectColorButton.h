//
//  SelectColorButton.h
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-02-06.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomColor.h"

@interface SelectColorButton : UIButton

@property (nonatomic, retain) CustomColor* color;
@property (nonatomic) CGFloat contentMargin;
@property (nonatomic) CGSize size;
@property (nonatomic) BOOL isSystemColor;

+(id)buttonWithColor:(CustomColor*)color andSize:(CGSize)size andContentMargin:(CGFloat)margin;

-(UIColor*)getUIColor;

@end
