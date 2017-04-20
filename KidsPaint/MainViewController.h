//
//  MainViewController.h
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CustomColor.h"
#import "PaintPadImageView.h"
#import "ToolsViewController.h"
#import "ColorViewController.h"
#import "SheetTabBarViewController.h"
#import "ParentalGate.h"

@interface MainViewController : UIViewController<UIActionSheetDelegate,
                                                 ToolsDelegate,
                                                 ColorDelegate,
                                                 SheetDelegate,
                                                 ParentalGateDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *sheetView;
@property (weak, nonatomic) IBOutlet PaintPadImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)clear:(id)sender;
- (IBAction)share:(id)sender;

@end
