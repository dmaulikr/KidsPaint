//
//  Tool.h
//  KidsPaint
//
//  Created by Jonas Frid on 2013-09-20.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    kDrawToolLine5,
    kDrawToolLine10,
    kDrawToolLine20,
    kDrawToolLine30,
    kDrawToolFillShape,
    kDrawToolStamp
}DrawTools;

@interface Tool : NSObject

@property DrawTools type;
@property NSString *name;
@property BOOL fill;
@property CGFloat lineWidth;
@property NSArray *commands;
@property CGSize size;

@end
