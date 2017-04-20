//
//  SheetViewController.h
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SheetTabDelegate <NSObject>

@optional
- (void)didSelectSheet:(NSString*)selectedSheetName;
- (void)didRemoveSheet;
- (void)didCancelSheetView;

@end

@interface SheetViewController : UICollectionViewController

@property (nonatomic, weak) id<SheetTabDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)removeSheet:(id)sender;

- (void)loadSheetsFromArray:(NSArray*)sheetsFromFile;

@end
