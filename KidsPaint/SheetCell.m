//
//  SheetCell.m
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import "SheetCell.h"

@interface SheetCell()
{
    UIImageView *imageView;
}
@end

@implementation SheetCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupCellWithName:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:[imageName stringByAppendingString:@"_thumb.png"]];
    
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame = CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 40);
        
        [self addSubview:imageView];
    }
    else
    {
        imageView.image = image;
    }
}

@end
