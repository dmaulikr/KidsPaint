//
//  ColorViewController.m
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//
//

#import "ColorViewController.h"

@interface ColorViewController ()
{
    CustomColor *currentMixedColor;
    NSMutableArray *colors;
    UIImageView *mixer;
    int numberOfColorsPerRow;
    UIImageView *trashCan;
    int customColorIndex;
}

- (void)initView;
- (void)saveUserColor:(CustomColor*)color;
- (void)deleteColorAndButton:(SelectColorButton*)button;
- (NSMutableArray*)loadUserColors;
- (CGPoint)getFreeCell;

@end

// -----------------------------------------------------------------

@implementation ColorViewController

@synthesize delegate = _delegate;
@synthesize imagesScrollView = _imagesScrollView;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Init
    mixer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    trashCan = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    trashCan.image = [UIImage imageNamed:@"TrashCircle.png"];
    
    // Draw the view
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -----------------------------------------------------------------

#pragma mark - Events

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet destructiveButtonIndex])
    {
        // Remove the color from the mixer UIImageView
        mixer.backgroundColor = [UIColor whiteColor];
        
        // Reset the variable that holds the currently mixed color
        currentMixedColor = nil;
    }
}

-(void)handleDoubleTapForMixer:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded && currentMixedColor)
    {
        // Show an action sheet for removing the current color in the mixer UIImageView
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"DeleteColorConfirmQuestion", nil)
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:NSLocalizedString(@"YES", nil)
                                                        otherButtonTitles:NSLocalizedString(@"NO", nil), nil];
        
        [actionSheet showFromRect:CGRectMake(0, 0, 0, 0) inView:mixer animated:YES];
    }
}

-(void)handleTapForMixer:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded && currentMixedColor)
    {
        // Save the color
        [colors addObject:currentMixedColor];
        [self saveUserColor:currentMixedColor];
        
        // The user selected the color in the mixer -> Create a new user color button
        SelectColorButton *newButton = [SelectColorButton
                                        buttonWithColor: currentMixedColor
                                        andSize:CGSizeMake(45, 45)
                                        andContentMargin:3];
        
        [newButton addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(handleLongPressForButton:)];
        [newButton addGestureRecognizer:longPress];
        
        newButton.frame = mixer.frame;
        newButton.tag = customColorIndex;
        customColorIndex++;
        
        [_imagesScrollView addSubview:newButton];
        
        // Get the next free cell
        CGPoint nextFreeCell = [self getFreeCell];
        
        // Move the mixer
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^
         {
             [mixer setFrame:CGRectMake(10 + (nextFreeCell.x * 50), 10 + (nextFreeCell.y * 50), 45, 45)];
         } completion:^(BOOL finished)
         {
             
         }];
        
        // Update the content size of the scroll view
        _imagesScrollView.contentSize = CGSizeMake(20 + (numberOfColorsPerRow * 50),
                                                  20 + ((nextFreeCell.y + 1) * 50));
        
        // Clear the mixer
        currentMixedColor = nil;
        mixer.backgroundColor = [UIColor whiteColor];
    }
}

-(void)handleLongPressForButton:(UILongPressGestureRecognizer*)gesture
{
    // Handles drag and drop operation for a color button (both system and user)
    static SelectColorButton *newButton;
    static BOOL dragStarted = NO;
    static float startY = 0;
    static float endY = 0;
    
    // Get the button
    SelectColorButton *button = (SelectColorButton *)[gesture view];
    
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            // Start the drag operation -> Create a dummy button used for dragging
            newButton = [SelectColorButton
                         buttonWithColor:[button.color copyColor]
                         andSize:CGSizeMake(45, 45)
                         andContentMargin:3];
            
            [newButton setFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
            
            [self.view addSubview:newButton];
            
            // Get the current position
            CGPoint point = [gesture locationInView:self.view];
            
            // Move the dummy button
            newButton.center = point;
            
            [UIView animateWithDuration:0.2 animations:^
            {
                [newButton setTransform:CGAffineTransformMakeScale(2, 2)];
            }];
            
            dragStarted = YES;
            
            if (!button.isSystemColor)
            {
                if (CGRectContainsPoint(CGRectMake(0, self.view.frame.size.height - 90, self.view.frame.size.width, 90), point) ||
                    CGRectContainsRect(CGRectMake(0, self.view.frame.size.height - 90, self.view.frame.size.width, 90), mixer.frame))
                {
                    startY = -20;
                    endY = 100;
                }
                else
                {
                    startY = self.view.frame.size.height + 20;
                    endY = self.view.frame.size.height - 50;
                }
                
                // Show the trash can
                trashCan.center = CGPointMake(self.view.frame.size.width / 2, startY);
                [self.view addSubview:trashCan];
                
                [UIView animateWithDuration:0.2 animations:^{
                    trashCan.center = CGPointMake(self.view.frame.size.width / 2, endY);
                }];
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            // Handle dragging over the view -> Get the current position
            CGPoint point = [gesture locationInView:self.view];
            
            // Move the dummy button
            newButton.center = point;
            
            // Get the position
            CGPoint pointInScrollView = [gesture locationInView:_imagesScrollView];
            
            // Check if we intersect with the mixer UIImageView
            if (CGRectContainsPoint(mixer.frame, pointInScrollView) == YES && dragStarted == YES)
            {
                // We intersect -> Stop the drag operation
                dragStarted = NO;
                
                // Handle color mixing
                if (currentMixedColor == nil)
                {
                    // First color dropped -> Init the start color
                    currentMixedColor = [button.color copyColor];
                }
                else
                {
                    // Mix the current color with the new color
                    currentMixedColor.rgb = [currentMixedColor mixWithColor:[button.color copyColor].rgb];
                }
                
                // Change the background in the mixer to the new mixed color
                mixer.backgroundColor = [currentMixedColor getUIColor];
                
                // Remove the dummy button
                [UIView animateWithDuration:0.2 animations:^
                 {
                     [newButton setTransform:CGAffineTransformIdentity];
                 } completion:^(BOOL finished)
                 {
                     [newButton removeFromSuperview];
                     newButton = nil;
                 }];
            }
            
            // Check if we intersect with the trash can
            if (CGRectContainsPoint(trashCan.frame, point) == YES && dragStarted == YES)
            {
                // We intersect -> Stop the drag operation
                dragStarted = NO;
                
                // Remove the dummy button
                [UIView animateWithDuration:0.2 animations:^
                 {
                     [newButton setTransform:CGAffineTransformIdentity];
                 } completion:^(BOOL finished)
                 {
                     [newButton removeFromSuperview];
                     newButton = nil;
                 }];
                
                // Hide the trash can
                [UIView animateWithDuration:0.2 animations:^{
                    trashCan.center = CGPointMake(self.view.frame.size.width / 2, startY);
                } completion:^(BOOL finished) {
                    [trashCan removeFromSuperview];
                }];
                
                // Delete the color
                [self deleteColorAndButton:button];
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            // Handle drop operation -> Stop the drag
            dragStarted = NO;
            
            // Remove the dummy button
            [UIView animateWithDuration:0.2 animations:^
             {
                 [newButton setTransform:CGAffineTransformIdentity];
                 [newButton setAlpha:1.0];
             } completion:^(BOOL finished)
             {
                 [newButton removeFromSuperview];
                 newButton = nil;
             }];
            
            if (!button.isSystemColor)
            {
                // Hide the trash can
                [UIView animateWithDuration:0.2 animations:^{
                    trashCan.center = CGPointMake(self.view.frame.size.width / 2, startY);
                } completion:^(BOOL finished) {
                    [trashCan removeFromSuperview];
                }];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)cancel:(id)sender
{
    if (_delegate != nil) {
        [_delegate didCancelColorView];
    }
}

-(IBAction)selectColor:(id)sender
{
    // Get the clicked button
    SelectColorButton *button = (SelectColorButton*)sender;
    
    // Animate the selection
    [UIView animateWithDuration:0.1 animations:^
     {
         [button setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [button setTransform:CGAffineTransformIdentity];
          } completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.1 animations:^
               {
                   [button setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
               } completion:^(BOOL finished)
               {
                   [UIView animateWithDuration:0.1 animations:^
                    {
                        [button setTransform:CGAffineTransformIdentity];
                    } completion:^(BOOL finished)
                    {
                        if (_delegate != nil) {
                            [_delegate didSelectColor:button.color];
                        }
                    }];
               }];
          }];
     }];
}

// -----------------------------------------------------------------

#pragma mark - Private Methods

- (void)initView
{
    // Init
    currentMixedColor = nil;
    customColorIndex = 0;
    
    // Define the system colors
    colors = [NSMutableArray arrayWithObjects:
              [CustomColor colorWithRGB:[RGB rgbWithRed:0.0 andGreen:0.0 andBlue:0.0]], // Black
              [CustomColor colorWithRGB:[RGB rgbWithRed:1.0 andGreen:1.0 andBlue:1.0]], // White
              [CustomColor colorWithRGB:[RGB rgbWithRed:0.7 andGreen:0.7 andBlue:0.7]], // Light Gray
              [CustomColor colorWithRGB:[RGB rgbWithRed:0.3 andGreen:0.3 andBlue:0.3]], // Dark Gray
              [CustomColor colorWithRGB:[RGB rgbWithRed:1.0 andGreen:0.0 andBlue:0.0]], // Red
              [CustomColor colorWithRGB:[RGB rgbWithRed:0.0 andGreen:1.0 andBlue:0.0]], // Green
              [CustomColor colorWithRGB:[RGB rgbWithRed:0.0 andGreen:0.0 andBlue:1.0]], // Blue
              [CustomColor colorWithRGB:[RGB rgbWithRed:1.0 andGreen:0.0 andBlue:0.7]], // Pink
              [CustomColor colorWithRGB:[RGB rgbWithRed:1.0 andGreen:1.0 andBlue:0.0]], // Yellow
              [CustomColor colorWithRGB:[RGB rgbWithRed:1.0 andGreen:0.5 andBlue:0.0]], // Orange
              [CustomColor colorWithRGB:[RGB rgbWithRed:0.6 andGreen:0.0 andBlue:0.8]], // Purple
              [CustomColor colorWithRGB:[RGB rgbWithRed:0.6 andGreen:0.3 andBlue:0.1]], // Brown
              nil];
    
    int numberOfSystemColors = colors.count;
    
    // Load user colors
    NSMutableArray *userColors = [self loadUserColors];
    
    // Add the user colors to the color array
    [colors addObjectsFromArray:userColors];
    
    // Set the number of colors per row
    numberOfColorsPerRow = 6;
    
    // Calculate the number of rows
    int numberOfRows = colors.count / numberOfColorsPerRow;
    
    if (colors.count % numberOfColorsPerRow > 0)
    {
        numberOfRows++;
    }
    
    // Create the color buttons
    int i = 0;
    
    for (int row = 0; row < numberOfRows; row++)
    {
        for (int col = 0; col < numberOfColorsPerRow; col++)
        {
            if (i >= colors.count)
            {
                // Finished -> Break!
                break;
            }
            
            SelectColorButton *newButton = [SelectColorButton
                                            buttonWithColor:[colors objectAtIndex:i]
                                            andSize:CGSizeMake(45, 45)
                                            andContentMargin:3];
            
            [newButton addTarget:self
                          action:@selector(selectColor:)
                forControlEvents:UIControlEventTouchUpInside];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(handleLongPressForButton:)];
            if (i < numberOfSystemColors)
            {
                newButton.isSystemColor = YES;
                newButton.tag = 0;
            }
            else
            {
                newButton.tag = customColorIndex;
                customColorIndex++;
            }
            
            [newButton addGestureRecognizer:longPress];
            
            [newButton setFrame:CGRectMake(10 + (col * 50), 10 + (row * 50), 45, 45)];
            
            [_imagesScrollView addSubview:newButton];
            
            i++;
        }
    }
    
    // Add the mixer
    CGPoint nextFreeCell = [self getFreeCell];
    
    [mixer setFrame:CGRectMake(10 + (nextFreeCell.x * 50), 10 + (nextFreeCell.y * 50), 45, 45)];
    
    mixer.backgroundColor = [UIColor whiteColor];
    mixer.userInteractionEnabled = YES;
    
	UIGraphicsBeginImageContext(mixer.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetLineCap(ctx, kCGLineCapSquare);
	CGContextSetLineWidth(ctx, 3.0);
	CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 0.5f);
    CGContextAddRect(ctx, CGRectMake(1, 1, mixer.frame.size.width - 2.0f, mixer.frame.size.height - 2.0f));
    CGContextStrokePath(ctx);
    mixer.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    [_imagesScrollView addSubview:mixer];
    
    // Add tap and doubletap gesture to the mixer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleTapForMixer:)];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(handleDoubleTapForMixer:)];
    
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap requireGestureRecognizerToFail:doubleTap];
    tap.delaysTouchesBegan = YES;
    
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    doubleTap.delaysTouchesBegan = YES;
    
    [mixer addGestureRecognizer:tap];
    [mixer addGestureRecognizer:doubleTap];
    
    // Set the content size of the scroll view
    _imagesScrollView.contentSize = CGSizeMake(20 + (numberOfColorsPerRow * 50), 20 + ((nextFreeCell.y + 1) * 50));
}

- (CGPoint)getFreeCell
{
    // Init
    int i = 0;
    int lastRow = 0;
    int lastCol = 0;
    
    // Calculate the number of rows
    int numberOfRows = colors.count / numberOfColorsPerRow;
    
    if (colors.count % numberOfColorsPerRow > 0)
    {
        numberOfRows++;
    }
    
    // Get the last current cell
    for (int row = 0; row < numberOfRows; row++)
    {
        for (int col = 0; col < numberOfColorsPerRow; col++)
        {
            if (i >= colors.count)
            {
                // Finished -> Break!
                break;
            }
            
            lastRow = row;
            lastCol = col;
            
            i++;
        }
    }
    
    // Calculate the next free cell
    if (lastCol < (numberOfColorsPerRow - 1))
    {
        lastCol++;
    }
    else
    {
        lastRow++;
        lastCol = 0;
    }
    
    return CGPointMake(lastCol, lastRow);
}

- (void)deleteColorAndButton:(SelectColorButton*)button
{
    // Store the index of the button to be removed
    int buttonIndex = button.tag;
    
    // Delete all subviews in the scroll view
    [[_imagesScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Init the local storage
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (def)
    {
        // Get the stored colors
        NSMutableArray *rawColors = [def objectForKey:@"KidsPaint_UserColors"];
        
        if (rawColors != nil && rawColors.count > 0)
        {
            NSMutableArray *storedColors = [NSMutableArray new];
            
            // Loop all colors, convert and add them to the list that will be returned
            for (int i = 0; i < rawColors.count; i++)
            {
                if (i != buttonIndex)
                {
                    // Add the new color to the list
                    [storedColors addObject:[rawColors objectAtIndex:i]];
                }
            }
            
            // Save the list in local storage
            [def setObject:storedColors forKey:@"KidsPaint_UserColors"];
            [def synchronize];
        }
    }
    
    // Restart the view
    [self initView];
}

- (void)saveUserColor:(CustomColor*)color
{
    // Init the local storage
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (def)
    {
        // Get the stored colors
        NSMutableArray *storedColors = [[def objectForKey:@"KidsPaint_UserColors"] mutableCopy];
        
        if (!storedColors)
        {
            // No stored colors -> Create a new list of colors
            storedColors = [NSMutableArray new];
        }
        
        // Add the new color to the list
        NSDictionary *colorDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:color.rgb.red], @"red",
                                  [NSNumber numberWithFloat:color.rgb.green], @"green",
                                  [NSNumber numberWithFloat:color.rgb.blue], @"blue", nil];
        
        [storedColors addObject:colorDic];
        
        // Save the list in local storage
        [def setObject:storedColors forKey:@"KidsPaint_UserColors"];
        [def synchronize];
    }
}

- (NSMutableArray*)loadUserColors
{
    // Init the color list
    NSMutableArray *storedColors = [NSMutableArray new];
    
    // Init the local storage
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if (def)
    {
        // Get the stored colors
        NSMutableArray *rawColors = [def objectForKey:@"KidsPaint_UserColors"];
        
        if (rawColors != nil && rawColors.count > 0)
        {
            // Loop all colors, convert and add them to the list that will be returned
            for (NSDictionary *color in rawColors)
            {
                CGFloat redColor = [[color objectForKey:@"red"] floatValue];
                CGFloat greenColor = [[color objectForKey:@"green"] floatValue];
                CGFloat blueColor = [[color objectForKey:@"blue"] floatValue];
                
                CustomColor *userColor = [CustomColor colorWithRGB:[RGB rgbWithRed:redColor andGreen:greenColor andBlue:blueColor]];
                
                [storedColors addObject:userColor];
            }
        }
    }
    
    return storedColors;
}

@end
