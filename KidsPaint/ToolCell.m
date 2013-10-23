//
//  ToolCell.m
//  KidsPaint
//
//  Created by Jonas Frid on 2013-09-18.
//
//

#import "ToolCell.h"

@interface ToolCell()
{
    UIImageView *imageView;
}
@end

@implementation ToolCell

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
    UIImage *image = [UIImage imageNamed:imageName];
    
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
