//
//  PaintPadImageView.h
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-01-03.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomColor.h"
#import "Tool.h"

@interface PaintPadImageView : UIImageView

@property CustomColor *selectedColor;
@property CGFloat selectedAlpha;
@property Tool *selectedTool;

-(void)clearImage;

@end
