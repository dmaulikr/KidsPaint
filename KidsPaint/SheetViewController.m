//
//  SheetViewController.m
//  KidsPaint
//
//  Created by Jonas Frid on 2013-05-10.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import "SheetViewController.h"
#import "SheetCell.h"

@interface SheetViewController ()
{
    NSArray *sheets;
    int numberOfColumns;
}
@end

// -----------------------------------------------------------------

@implementation SheetViewController

@synthesize delegate = _delegate;

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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        numberOfColumns = 4;
    }
    else
    {
        numberOfColumns = 2;
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
        [_delegate didCancelSheetView];
    }
}

- (IBAction)removeSheet:(id)sender
{
    if (_delegate != nil) {
        [_delegate didRemoveSheet];
    }
}

// -----------------------------------------------------------------

#pragma mark - Public Methods

- (void)loadSheetsFromArray:(NSArray*)sheetsFromFile
{
    sheets = [NSArray arrayWithArray:sheetsFromFile];
}

// -----------------------------------------------------------------

#pragma mark - UICollectionViewController source and delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sheets.count / numberOfColumns;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return numberOfColumns;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SheetCell *cell = (SheetCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"SheetCell" forIndexPath:indexPath];
    
    NSString *sheetName = [sheets objectAtIndex:(indexPath.section * numberOfColumns + indexPath.row)];
    
    [cell setupCellWithName:sheetName];
    
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
                        // Send back the image name
                        NSString *sheetName = [sheets objectAtIndex:(indexPath.section * numberOfColumns + indexPath.row)];
                            
                        [_delegate didSelectSheet:[sheetName stringByAppendingString:@".png"]];
                    }];
                }];
            }];
        }];
    }
}

@end
