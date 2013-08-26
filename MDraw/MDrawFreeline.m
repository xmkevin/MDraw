//
//  MDrawFreeline.m
//  MDraw
//
//  Created by Gao Yongqing on 8/26/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawFreeline.h"

@implementation MDrawFreeline
{
    NSMutableArray *_points;
}

-(CGRect)frame
{
    CGPoint tl, rb;
    
    if(_points.count > 0 )
    {
        CGPoint firstPoint = [[_points objectAtIndex:0] CGPointValue];
        tl = firstPoint;
        rb = firstPoint;
    }
    
    for (NSValue *pValue in _points)
    {
        CGPoint p = [pValue CGPointValue];
        
        tl.x = MIN(tl.x, p.x);
        tl.y = MIN(tl.y, p.y);
        rb.x = MAX(rb.x, p.x);
        rb.y = MAX(rb.y, p.y);
    }
    
    return CGRectMake(tl.x,
                      tl.y,
                      fabsf(rb.x - tl.x),
                      fabsf(rb.y - tl.y));
    
    
}

-(id)initWithStartPoint:(CGPoint)startPoint
{
    self = [super initWithStartPoint:startPoint];
    if(self)
    {
        _points = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)drawMove:(CGPoint)point
{
    [_points addObject:[NSValue valueWithCGPoint:point]];
}

-(void)drawUp:(CGPoint)point
{
    [self finalize:point];
}

-(void)finalize:(CGPoint)point
{
    [_points addObject:[NSValue valueWithCGPoint:point]];
    _finalized = YES;
    self.selected = YES;
}

-(BOOL)hitOnHandle:(CGPoint)point
{
    _moveDirection = MDrawMoveDirectionNone;
    
    CGRect frame = self.frame;
    if([self isPoint:point onHandle:CGRectMid(frame)])
    {
        _moveDirection = MDrawMoveDirectionWhole;
        return YES;
    }
    
    return NO;
}

-(void)moveToPoint:(CGPoint)point
{
    if(_moveDirection == MDrawMoveDirectionWhole)
    {
        CGPoint lastPoint = CGRectMid(self.frame);
        CGSize offset = CGPointOffset(lastPoint, point);
        
        for (int i = 0; i < _points.count; i++) {
            CGPoint p = [[_points objectAtIndex:i] CGPointValue];
            p.x += offset.width;
            p.y += offset.height;
            
            [_points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p]];
        }
    }
}

-(void)draw:(CGContextRef)ctx
{
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    
    CGContextBeginPath(ctx);
    if(_points.count > 0 )
    {
        CGPoint p = [[_points objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(ctx, p.x, p.y);
        
        for (int i = 1; i < _points.count; i++)
        {
            CGPoint p = [[_points objectAtIndex:i] CGPointValue];
            CGContextAddLineToPoint(ctx, p.x, p.y);
        }
        
    }
    
    CGContextStrokePath(ctx);
    
    if (self.selected)
    {
        CGRect frame = self.frame;
        [self drawHandle:ctx atPoint:CGRectMid(frame)];
    }

}

@end
