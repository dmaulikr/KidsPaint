//
//  ToolsViewController.h
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

@protocol ToolsDelegate <NSObject>

@optional
- (void)didSelectTool:(Tool*)selectedTool;
- (void)didCancelToolsView;

@end

@interface ToolsViewController : UICollectionViewController

@property (nonatomic, weak) id<ToolsDelegate> delegate;

- (IBAction)cancel:(id)sender;

@end
