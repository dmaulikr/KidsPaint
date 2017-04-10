//
//  AppDelegate.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2011-12-31.
//  Copyright (c) 2011-2013 iDoApps. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Check the settings
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *enableShareMessagePreference = [standardUserDefaults objectForKey:@"enableShareMessage"];
    NSString *enableShareMailPreference = [standardUserDefaults objectForKey:@"enableShareMail"];
    NSString *enableShareFacebookPreference = [standardUserDefaults objectForKey:@"enableShareFacebook"];
    NSString *enableSharePhotosPreference = [standardUserDefaults objectForKey:@"enableSharePhotos"];
    NSString *enableShareCopyPreference = [standardUserDefaults objectForKey:@"enableShareCopy"];
    NSString *enableSharePrintPreference = [standardUserDefaults objectForKey:@"enableSharePrint"];
    
    if (!enableShareMessagePreference ||
        !enableShareMailPreference ||
        !enableShareFacebookPreference ||
        !enableSharePhotosPreference ||
        !enableShareCopyPreference ||
        !enableSharePrintPreference)
    {
        [self registerDefaultsFromSettingsBundle];
    }
        
    // Init Parental Gate
    //TODO: Create new parental gate solution!
    //[PGView initWithParentalGateAppKey:@"FE74ED5EC0AFE5A6C096F1D1C8"];
    
    // Check for older versions og iOS
    /*
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0f)
    {
        [self setApperanceForOlderiOS];
    }
    */

    // Return...
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
- (void)setApperanceForOlderiOS
{
    [UIBarButtonItem appearance].tintColor = nil;
    [UIToolbar appearance].barStyle = UIBarStyleBlackOpaque;
}
*/

- (void)registerDefaultsFromSettingsBundle
{
    // this function writes default settings as settings
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if(!settingsBundle)
    {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for(NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

@end
