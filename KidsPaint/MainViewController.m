//
//  MainViewController.m
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//
//

#import "MainViewController.h"

@interface MainViewController ()
{
    CGRect imageViewNormalFrame;
    NSMutableArray *popovers;
    UIActionSheet *deleteActionSheet;
    BOOL drawingIsEnabled;
    UIView *blockingView;
}

@end

// -----------------------------------------------------------------

@implementation MainViewController

@synthesize imageView = _imageView;
@synthesize sheetView = _sheetView;
@synthesize shareButton = _shareButton;
@synthesize toolbar = _toolbar;

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init
    drawingIsEnabled = YES;
    
    // Init the selected color
    _imageView.selectedColor = [CustomColor colorWithRGB:[RGB rgbWithRed:0.0 andGreen:0.0 andBlue:0.0]];
    
    // Init the selected line width
    _imageView.selectedTool = [Tool new];
    _imageView.selectedTool.type = kDrawToolLine10;
    
    // Init the selected alpha
    _imageView.selectedAlpha = 1.0;
    
    // Handle app reactivation - Check for changed sharing options
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkEnabledSharingOptions) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // DO THE FOLLOWING ONLY WHEN CREATING LAUNCH IMAGES
    //_toolbar.items = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Save the image view normal frame
    imageViewNormalFrame = _imageView.frame;
    
    // Check for changed sharing options
    [self checkEnabledSharingOptions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]])
    {
        if (popovers == nil)
        {
            popovers = [[NSMutableArray alloc] init];
        }
        
        [popovers addObject:[(UIStoryboardPopoverSegue *)segue popoverController]];
    }
    
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)segue.destinationViewController;
        
        if (nav.viewControllers.count > 0)
        {
            if ([nav.viewControllers[0] isKindOfClass:[ToolsViewController class]])
            {
                [(ToolsViewController*)nav.viewControllers[0] setDelegate:self];
                return;
            }
        }
    }
    
    if ([segue.destinationViewController isKindOfClass:[ToolsViewController class]])
    {
        [(ToolsViewController*)segue.destinationViewController setDelegate:self];
        return;
    }
    
    if ([segue.destinationViewController isKindOfClass:[ColorViewController class]])
    {
        [(ColorViewController*)segue.destinationViewController setDelegate:self];
        return;
    }
    
    if ([segue.destinationViewController isKindOfClass:[SheetTabBarViewController class]])
    {
        [(SheetTabBarViewController*)segue.destinationViewController setDelegate2:self];
        return;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self closeAllPopovers];
    
    return YES;
}

// -----------------------------------------------------------------

#pragma mark - Events

- (IBAction)clear:(id)sender
{
    if (deleteActionSheet == nil)
    {
        [self closeAllPopovers];
        
        deleteActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"DeleteImageConfirmQuestion", nil)
                                                        delegate:self
                                               cancelButtonTitle:nil
                                          destructiveButtonTitle:NSLocalizedString(@"YES", nil)
                                               otherButtonTitles:NSLocalizedString(@"NO", nil), nil];
        
        [deleteActionSheet showFromBarButtonItem:sender animated:YES];
    }
}

- (IBAction)share:(id)sender
{
    // Disable drawing
    [self disableDrawing];
    
    // Close all popovers
    [self closeAllPopovers];
    
    // Fire up the parental gate!
    //CGSize gateSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGSizeMake(680, 850) : CGSizeMake(285, 380);
    
    //TODO: Create new parental gate solution
    /*
    PGView *pgView = [[PGView alloc]initWithSize:gateSize andParentalGate:ParentalGateType3FingerTap];
    pgView.delegate = self;
    [self.view addSubview:pgView];
    [pgView show];
    */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    deleteActionSheet = nil;
    
    if(buttonIndex == [actionSheet destructiveButtonIndex])
    {
        // Init the transition
        [UIView animateWithDuration:0 animations:^{
            // Combine the images
            _imageView.image = [self combineImage:_imageView andImage:_sheetView];
            
        } completion:^(BOOL finished) {
            // Clear the drawings
            [_imageView clearImage];
            
            // Animate the transition
            [UIView transitionWithView:_imageView duration:1.5 options:UIViewAnimationOptionTransitionCurlUp animations:^ {}
                            completion:^(BOOL finished){}];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (drawingIsEnabled)
    {
        [_imageView touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (drawingIsEnabled)
    {
        [_imageView touchesMoved:touches withEvent:event];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didSelectTool:(Tool*)selectedTool
{
    // Store the selected tool
    _imageView.selectedTool = selectedTool;
    
    // Dismiss the dialog
    [self closeAllPopovers];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didCancelToolsView
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didSelectColor:(CustomColor *)selectedColor
{
    // Store the selected color
    _imageView.selectedColor = selectedColor;
    
    // Dismiss the dialog
    [self closeAllPopovers];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didCancelColorView
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didSelectSheet:(NSString *)selectedSheetName
{
    // Dismiss the dialog
    [self closeAllPopovers];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    // Init the transition
    [UIView animateWithDuration:0 animations:^{
        // Combine the images
        _sheetView.image = [self combineImage:_imageView andImage:_sheetView];
        
        // Set the back color to solid white
        _sheetView.backgroundColor = [UIColor whiteColor];
        
    } completion:^(BOOL finished) {
        // Clear the drawings
        [_imageView clearImage];
        
        // Set the new sheet
        _sheetView.image = [UIImage imageNamed:selectedSheetName];
        
        // Animate the transition
        [UIView transitionWithView:_sheetView duration:1.5 options:UIViewAnimationOptionTransitionCurlUp animations:^  {}
                        completion:^(BOOL finished)
         {
             // Restore the back color to transparent
             _sheetView.backgroundColor = [UIColor clearColor];
         }];
    }];
}

- (void)didRemoveSheet
{
    // Dismiss the dialog
    [self closeAllPopovers];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    // Init the transition
    [UIView animateWithDuration:0 animations:^{
        // Combine the images
        _sheetView.image = [self combineImage:_imageView andImage:_sheetView];
        
        // Set the back color to solid white
        _sheetView.backgroundColor = [UIColor whiteColor];
        
    } completion:^(BOOL finished) {
        // Clear the drawings
        [_imageView clearImage];
        
        // Set the new sheet
        _sheetView.image = nil;
        
        // Animate the transition
        [UIView transitionWithView:_sheetView duration:1.5 options:UIViewAnimationOptionTransitionCurlUp animations:^  {}
                        completion:^(BOOL finished)
         {
             // Restore the back color to transparent
             _sheetView.backgroundColor = [UIColor clearColor];
         }];
    }];
}

- (void)didCancelSheetView
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//TODO: Create new parental gate solution

/*
- (void)ParentalLockSucceeded:(PGView *)sender
{
    // Enable drawing
    [self enableDrawing];
    
    // Go ahead with the sharing features
    UIImage *combinedImage = [self combineImage:_imageView andImage:_sheetView];
    NSArray *itemsToShare = @[combinedImage];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    
    [activityViewController setValue:@"Drawing from Kids Paint Book" forKey:@"subject"];
    
    // Check for older versions og iOS
    NSMutableArray *excludedActivityTypes = [NSMutableArray new];
    
    [excludedActivityTypes addObject:UIActivityTypeAssignToContact];
    [excludedActivityTypes addObject:UIActivityTypePostToTwitter];
    [excludedActivityTypes addObject:UIActivityTypePostToWeibo];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
    {
        [excludedActivityTypes addObject:UIActivityTypeAddToReadingList];
        [excludedActivityTypes addObject:UIActivityTypeAirDrop];
        [excludedActivityTypes addObject:UIActivityTypePostToTencentWeibo];
        [excludedActivityTypes addObject:UIActivityTypePostToVimeo];
    }
    
    // Read user settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"enableShareMessage"] == NO)
    {
        [excludedActivityTypes addObject:UIActivityTypeMessage];
    }
    
    if ([defaults boolForKey:@"enableShareMail"] == NO)
    {
        [excludedActivityTypes addObject:UIActivityTypeMail];
    }
    
    if ([defaults boolForKey:@"enableShareFacebook"] == NO)
    {
        [excludedActivityTypes addObject:UIActivityTypePostToFacebook];
    }
    
    if ([defaults boolForKey:@"enableSharePhotos"] == NO)
    {
        [excludedActivityTypes addObject:UIActivityTypeSaveToCameraRoll];
    }
    
    if ([defaults boolForKey:@"enableShareCopy"] == NO)
    {
        [excludedActivityTypes addObject:UIActivityTypeCopyToPasteboard];
    }
    
    if ([defaults boolForKey:@"enableSharePrint"] == NO)
    {
        [excludedActivityTypes addObject:UIActivityTypePrint];
    }
    
    activityViewController.excludedActivityTypes = excludedActivityTypes;
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed)
    {
        if (completed)
        {
            // Play animation
            [UIView animateWithDuration:0.5 animations:^{
                _sheetView.frame = CGRectMake((self.view.frame.size.width - 100) / 2, (self.view.frame.size.height - 100) / 2, 100, 100);
                _imageView.frame = CGRectMake((self.view.frame.size.width - 100) / 2, (self.view.frame.size.height - 100) / 2, 100, 100);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    _sheetView.frame = CGRectMake(1000, (self.view.frame.size.height - 100) / 2, 100, 100);
                    _imageView.frame = CGRectMake(1000, (self.view.frame.size.height - 100) / 2, 100, 100);
                } completion:^(BOOL finished) {
                    _imageView.frame = imageViewNormalFrame;
                    _sheetView.frame = imageViewNormalFrame;
                }];
            }];
        }
    }];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)ParentalLockCancelled:(PGView *)sender
{
    // Enable drawing
    [self enableDrawing];
}
*/

// -----------------------------------------------------------------

#pragma mark - Private Methods

- (void)disableDrawing
{
    // Block redirection of touch from the view to the image view
    drawingIsEnabled = NO;
    
    // Block touch on the image view
    _imageView.userInteractionEnabled = NO;
    
    // Show the block UI
    blockingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    blockingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    [self.view addSubview:blockingView];
}

- (void)enableDrawing
{
    // Remove all blocks and enable everything...
    [blockingView removeFromSuperview];
    blockingView = nil;
    drawingIsEnabled = YES;
    _imageView.userInteractionEnabled = YES;
}

- (void)checkEnabledSharingOptions
{
    BOOL oneIsYes = NO;
    
    // Synchronize
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Read user settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"enableShareMessage"] == YES)
    {
        oneIsYes = YES;
    }
    
    if ([defaults boolForKey:@"enableShareMail"] == YES)
    {
        oneIsYes = YES;
    }
    
    if ([defaults boolForKey:@"enableShareFacebook"] == YES)
    {
        oneIsYes = YES;
    }
    
    if ([defaults boolForKey:@"enableSharePhotos"] == YES)
    {
        oneIsYes = YES;
    }
    
    if ([defaults boolForKey:@"enableShareCopy"] == YES)
    {
        oneIsYes = YES;
    }
    
    if ([defaults boolForKey:@"enableSharePrint"] == YES)
    {
        oneIsYes = YES;
    }
    
    // Enable/Disable the sharing button
    if (oneIsYes)
    {
        _shareButton.enabled = YES;
    }
    else
    {
        _shareButton.enabled = NO;
    }
}

- (void)closeAllPopovers
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (popovers != nil)
        {
            for (int i = 0; i < popovers.count; i++)
            {
                UIPopoverController *popover = [popovers objectAtIndex:i];
                
                if (popover != nil && popover.isPopoverVisible)
                {
                    [popover dismissPopoverAnimated:YES];
                }
            }
            
            popovers = nil;
        }
        
        if (deleteActionSheet != nil)
        {
            [deleteActionSheet dismissWithClickedButtonIndex:1 animated:YES];
            deleteActionSheet = nil;
        }
    }
}

- (UIImage*)combineImage:(UIImageView*)imageView1 andImage:(UIImageView*)imageView2
{
    //NSLog(@"%f, %f, %f, %f", imageView1.frame.origin.x, imageView1.frame.origin.y, imageView1.frame.size.width, imageView1.frame.size.height);
    //NSLog(@"%f, %f, %f, %f", imageView2.frame.origin.x, imageView2.frame.origin.y, imageView2.frame.size.width, imageView2.frame.size.height);
    
    // Combine the drawing and the coloring sheet
	UIGraphicsBeginImageContext(imageView1.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, imageView1.frame);
    
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    
    if (imageView2.image != nil)
    {
        [imageView2.image drawInRect:CGRectMake(0, 0 , imageView1.frame.size.width, imageView1.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    }
    
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
    return combinedImage;
}

@end
