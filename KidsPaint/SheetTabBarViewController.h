//
//  SheetTabBarViewController.h
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//
//

#import <UIKit/UIKit.h>
#import "SheetViewController.h"

@protocol SheetDelegate <NSObject>

@optional
- (void)didSelectSheet:(NSString*)selectedSheetName;
- (void)didRemoveSheet;
- (void)didCancelSheetView;

@end

@interface SheetTabBarViewController : UITabBarController <SheetTabDelegate>

@property (nonatomic, weak) id<SheetDelegate> delegate2;

@end
