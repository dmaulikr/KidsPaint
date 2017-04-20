//
//  ColorViewController.h
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomColor.h"
#import "SelectColorButton.h"

@protocol ColorDelegate <NSObject>

@optional
- (void)didSelectColor:(CustomColor*)selectedColor;
- (void)didCancelColorView;

@end

@interface ColorViewController : UIViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) id<ColorDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;

- (IBAction)selectColor:(id)sender;
- (IBAction)cancel:(id)sender;

@end
