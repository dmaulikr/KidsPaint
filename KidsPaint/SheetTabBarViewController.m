//
//  SheetTabBarViewController.m
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import "SheetTabBarViewController.h"

@implementation SheetTabBarViewController

@synthesize delegate2 = _delegate2;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the sheet config
    NSArray *sheetConfig = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sheets" ofType:@"plist"]];
    
    // Init the tab view controllers
    for (int i = 0; i < self.viewControllers.count; i++)
    {
        UINavigationController *navController = (UINavigationController*)self.viewControllers[i];
        SheetViewController *tab = (SheetViewController*)navController.viewControllers[0];
        
        tab.delegate = self;
        
        [tab loadSheetsFromArray:[sheetConfig objectAtIndex:i]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// -----------------------------------------------------------------

#pragma mark - Events

- (void)didCancelSheetView
{
    if (_delegate2 != nil)
    {
        [_delegate2 didCancelSheetView];
    }
}

- (void)didRemoveSheet
{
    if (_delegate2 != nil)
    {
        [_delegate2 didRemoveSheet];
    }
}

- (void)didSelectSheet:(NSString *)selectedSheetName
{
    if (_delegate2 != nil)
    {
        [_delegate2 didSelectSheet:selectedSheetName];
    }
}

@end
