//
//  MainViewController.h
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <ParentalGate/PGView.h>
#import "CustomColor.h"
#import "PaintPadImageView.h"
#import "ToolsViewController.h"
#import "ColorViewController.h"
#import "SheetTabBarViewController.h"

@interface MainViewController : UIViewController<UIActionSheetDelegate,
                                                 ToolsDelegate,
                                                 ColorDelegate,
                                                 SheetDelegate,
                                                 ParentalLockSuccessDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *sheetView;
@property (weak, nonatomic) IBOutlet PaintPadImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)clear:(id)sender;
- (IBAction)share:(id)sender;

@end
