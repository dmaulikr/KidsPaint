//
//  PaintPadImageView.m
//  KidsPaint
//
//  Created by Frid, Jonas on 2012-01-03.
//  Copyright (c) 2011-2017 iDoApps. All rights reserved.
//

#import "PaintPadImageView.h"

@interface PaintPadImageView()

@property NSMutableArray *points;

@end


@implementation PaintPadImageView

@synthesize selectedColor = _selectedColor;
@synthesize selectedAlpha = _selectedAlpha;
@synthesize selectedTool = _selectedTool;
@synthesize points = _points;

- (void)clearImage
{
    self.image = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesBegan");
    
    // Handle draw shape
    if (_selectedTool.type == kDrawToolFillShape)
    {
        _points = [NSMutableArray new];
        
        // Store the current point
        CGPoint currentPoint = [[touches anyObject] locationInView:self];
        [_points addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesMoved");
    
    // Handle draw shape
    if (_selectedTool.type == kDrawToolFillShape)
    {
        // Store the current point
        CGPoint currentPoint = [[touches anyObject] locationInView:self];
        [_points addObject:[NSValue valueWithCGPoint:currentPoint]];
        
        // Draw
        CGPoint lastPoint = [[touches anyObject] previousLocationInView:self];
        [self drawLineFromPoint:lastPoint toPoint:currentPoint];
        
        return;
    }
    
    // Loop all touch positions
    for (UITouch *touch in touches)
    {
        // Get the current and last points
        NSDictionary *points = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:[touch locationInView:self]], @"currentPoint", [NSValue valueWithCGPoint:[touch previousLocationInView:self]], @"lastPoint", nil];
        //CGPoint currentPoint = [touch locationInView:self];
        //CGPoint lastPoint = [touch previousLocationInView:self];
        
        if (_selectedTool.type == kDrawToolLine5 || _selectedTool.type == kDrawToolLine10 || _selectedTool.type == kDrawToolLine20 || _selectedTool.type == kDrawToolLine30)
        {
            // Draw
            //[self drawLineFromPoint:lastPoint toPoint:currentPoint];
            [self performSelector:@selector(drawLine:) withObject:points afterDelay:0.0];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesEnded");
    
    // Handle draw shape
    if (_selectedTool.type == kDrawToolFillShape)
    {
        // Store the current point
        CGPoint currentPoint = [[touches anyObject] locationInView:self];
        [_points addObject:[NSValue valueWithCGPoint:currentPoint]];
        
        // Draw
        [self fillShape];
        
        return;
    }
    
    // Loop all touch positions
    for (UITouch *touch in touches)
    {
        // Get the current and last points
        CGPoint currentPoint = [touch locationInView:self];
        CGPoint lastPoint = [touch previousLocationInView:self];
        
        // Draw
        switch (_selectedTool.type)
        {
            case kDrawToolLine5:
            case kDrawToolLine10:
            case kDrawToolLine20:
            case kDrawToolLine30:
                [self drawLineFromPoint:lastPoint toPoint:currentPoint];
                break;
                
            case kDrawToolFillShape:
                break;
                
            case kDrawToolStamp:
                [self drawStampAtPoint:lastPoint];
                break;
        }
    }
}

- (void)drawLine:(NSDictionary*)dict
{
    CGPoint point1 = [[dict objectForKey:@"lastPoint"] CGPointValue];
    CGPoint point2 = [[dict objectForKey:@"currentPoint"] CGPointValue];
    
    [self drawLineFromPoint:point1 toPoint:point2];
}

- (void)drawLineFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    CGFloat lineWidth;
    
    switch (_selectedTool.type)
    {
        case kDrawToolLine5:
            lineWidth = 5.0f;
            break;
            
        case kDrawToolLine10:
            lineWidth = 10.0f;
            break;
            
        case kDrawToolLine20:
            lineWidth = 20.0f;
            break;
            
        case kDrawToolLine30:
            lineWidth = 30.0f;
            break;
            
        case kDrawToolFillShape:
            lineWidth = 5.0f;
            break;
            
        default:
            lineWidth = 100.0f;
            break;
    }
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetRGBStrokeColor(context, _selectedColor.rgb.red, _selectedColor.rgb.green, _selectedColor.rgb.blue, _selectedAlpha);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point1.x - 0.5f, point1.y - 0.5f);
    CGContextAddLineToPoint(context, point2.x - 0.5f, point2.y - 0.5f);
    CGContextStrokePath(context);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)fillShape
{
    if (_points != nil && _points.count > 1)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        
        [self.image drawInRect:self.bounds];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetShouldAntialias(context, YES);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 5.0f);
        CGContextSetRGBFillColor(context, _selectedColor.rgb.red, _selectedColor.rgb.green, _selectedColor.rgb.blue, _selectedAlpha);
        CGContextSetRGBStrokeColor(context, 1.0f - _selectedColor.rgb.red, 1.0f - _selectedColor.rgb.green, 1.0f - _selectedColor.rgb.blue, _selectedAlpha);
        
        CGContextBeginPath(context);
        
        CGPoint firstPoint = [[_points firstObject] CGPointValue];
        
        CGContextMoveToPoint(context, firstPoint.x - 0.5f, firstPoint.y - 0.5f);
        
        for (int i = 1; i < _points.count; i++)
        {
            CGPoint currentPoint = [[_points objectAtIndex:i] CGPointValue];
            
            CGContextAddLineToPoint(context, currentPoint.x - 0.5f, currentPoint.y - 0.5f);
        }
        
        [_points removeAllObjects];
        
        CGContextAddLineToPoint(context, firstPoint.x - 0.5f, firstPoint.y - 0.5f);
        
        CGContextClosePath(context);
        
        CGContextDrawPath(context, kCGPathFillStroke);
        
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
}

- (void)drawStampAtPoint:(CGPoint)point
{
    if (_selectedTool.commands != nil && _selectedTool.commands.count > 0)
    {
        CGPoint topLeft = CGPointMake(point.x - (_selectedTool.size.width / 2.0f), point.y - (_selectedTool.size.height / 2.0f));
        
        UIGraphicsBeginImageContext(self.frame.size);
        
        [self.image drawInRect:self.bounds];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetShouldAntialias(context, YES);
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        bezierPath.miterLimit = 4;
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        bezierPath.usesEvenOddFillRule = YES;
        
        for (NSDictionary *command in _selectedTool.commands)
        {
            NSString *commandName = [command objectForKey:@"name"];
            
            if ([commandName isEqualToString:@"moveToPoint"])
            {
                CGFloat endPointX = [[command objectForKey:@"endPointX"] floatValue];
                CGFloat endPointY = [[command objectForKey:@"endPointY"] floatValue];
                
                [bezierPath moveToPoint:CGPointMake(topLeft.x + endPointX, topLeft.y + endPointY)];
            }
            else if ([commandName isEqualToString:@"addLineToPoint"])
            {
                CGFloat endPointX = [[command objectForKey:@"endPointX"] floatValue];
                CGFloat endPointY = [[command objectForKey:@"endPointY"] floatValue];
                
                [bezierPath addLineToPoint:CGPointMake(topLeft.x + endPointX, topLeft.y + endPointY)];
            }
            else if ([commandName isEqualToString:@"addCurveToPoint"])
            {
                CGFloat endPointX = [[command objectForKey:@"endPointX"] floatValue];
                CGFloat endPointY = [[command objectForKey:@"endPointY"] floatValue];
                CGFloat controlPoint1X = [[command objectForKey:@"controlPoint1X"] floatValue];
                CGFloat controlPoint1Y = [[command objectForKey:@"controlPoint1Y"] floatValue];
                CGFloat controlPoint2X = [[command objectForKey:@"controlPoint2X"] floatValue];
                CGFloat controlPoint2Y = [[command objectForKey:@"controlPoint2Y"] floatValue];
                
                [bezierPath addCurveToPoint:CGPointMake(topLeft.x + endPointX, topLeft.y + endPointY)
                              controlPoint1:CGPointMake(topLeft.x + controlPoint1X, topLeft.y + controlPoint1Y)
                              controlPoint2:CGPointMake(topLeft.x + controlPoint2X, topLeft.y + controlPoint2Y)];
            }
            else if ([commandName isEqualToString:@"addRect"])
            {
                CGFloat startPointX = [[command objectForKey:@"startPointX"] floatValue];
                CGFloat startPointY = [[command objectForKey:@"startPointY"] floatValue];
                CGFloat width = [[command objectForKey:@"width"] floatValue];
                CGFloat height = [[command objectForKey:@"height"] floatValue];
                
                [bezierPath moveToPoint:CGPointMake(topLeft.x + startPointX, topLeft.y + startPointY)];
                
                [bezierPath addLineToPoint:CGPointMake(topLeft.x + startPointX + width, topLeft.y + startPointY)];
                [bezierPath addLineToPoint:CGPointMake(topLeft.x + startPointX + width, topLeft.y + startPointY + height)];
                [bezierPath addLineToPoint:CGPointMake(topLeft.x + startPointX, topLeft.y + startPointY + height)];
                [bezierPath addLineToPoint:CGPointMake(topLeft.x + startPointX, topLeft.y + startPointY)];
            }
            else if ([commandName isEqualToString:@"closePath"])
            {
                [bezierPath closePath];
            }
        }
        
        [bezierPath closePath];
        
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, _selectedTool.lineWidth);
        
        if (_selectedTool.fill)
        {
            CGContextSetRGBFillColor(context, _selectedColor.rgb.red, _selectedColor.rgb.green, _selectedColor.rgb.blue, _selectedAlpha);
            CGContextSetRGBStrokeColor(context, 1.0f - _selectedColor.rgb.red, 1.0f - _selectedColor.rgb.green, 1.0f - _selectedColor.rgb.blue, _selectedAlpha);
        }
        else
        {
            CGContextSetRGBStrokeColor(context, _selectedColor.rgb.red, _selectedColor.rgb.green, _selectedColor.rgb.blue, _selectedAlpha);
        }
        
        CGContextBeginPath(context);
        CGContextAddPath(context, bezierPath.CGPath);
        
        if (_selectedTool.fill)
        {
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        else
        {
            CGContextStrokePath(context);
        }
        
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
}

@end
