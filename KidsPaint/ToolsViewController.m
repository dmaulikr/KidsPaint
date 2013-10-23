//
//  ToolsViewController.m
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//
//

#import "ToolsViewController.h"
#import "ToolCell.h"

@interface ToolsViewController ()
{
    NSArray *tools;
    int numberOfColumns;
    int numberOfRows;
}

@end

// -----------------------------------------------------------------

@implementation ToolsViewController

@synthesize delegate = _delegate;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get the sheet config
    tools = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tools" ofType:@"plist"]];
    
    // Define the number of columns
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        numberOfColumns = 4;
    }
    else
    {
        numberOfColumns = 2;
    }
    
    // Define the number of rows
    numberOfRows = tools.count / numberOfColumns;
    
    if (tools.count % numberOfColumns > 0)
    {
        numberOfRows++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// -----------------------------------------------------------------

#pragma mark - Events

- (IBAction)cancel:(id)sender
{
    if (_delegate != nil) {
        [_delegate didCancelToolsView];
    }
}

// -----------------------------------------------------------------

#pragma mark - UICollectionViewController source and delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return numberOfRows;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == numberOfRows - 1 &&
        tools.count % numberOfColumns != 0)
        return tools.count % numberOfColumns;
    else
        return numberOfColumns;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCell *cell = (ToolCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ToolCell" forIndexPath:indexPath];
    
    NSDictionary *tool = [tools objectAtIndex:(indexPath.section * numberOfColumns + indexPath.row)];
    
    [cell setupCellWithName:[tool objectForKey:@"name"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate != nil)
    {
        // Animate
        UICollectionViewCell  *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        [UIView animateWithDuration:0.1 animations:^
        {
            [cell setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
        }
        completion:^(BOOL finished)
        {
            [UIView animateWithDuration:0.1 animations:^
            {
                [cell setTransform:CGAffineTransformIdentity];
            }
            completion:^(BOOL finished)
            {
                [UIView animateWithDuration:0.1 animations:^
                {
                    [cell setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
                }
                completion:^(BOOL finished)
                {
                    [UIView animateWithDuration:0.1 animations:^
                    {
                        [cell setTransform:CGAffineTransformIdentity];
                    }
                    completion:^(BOOL finished)
                    {
                        // Send back the tool
                        NSDictionary *toolSpec = [tools objectAtIndex:(indexPath.section * numberOfColumns + indexPath.row)];
                        
                        Tool *tool = [Tool new];
                        
                        tool.type = [[toolSpec objectForKey:@"id"] integerValue];
                        tool.name = [toolSpec objectForKey:@"name"];
                        tool.fill = [[toolSpec objectForKey:@"fill"] boolValue];
                        tool.lineWidth = [[toolSpec objectForKey:@"linewidth"] floatValue];
                        tool.commands = [toolSpec objectForKey:@"commands"];
                        tool.size = CGSizeMake([[toolSpec objectForKey:@"width"] floatValue], [[toolSpec objectForKey:@"height"] floatValue]);
                        
                        [_delegate didSelectTool:tool];
                    }];
                }];
            }];
        }];
    }
}

@end
