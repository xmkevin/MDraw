//
//  MDrawPolyline.m
//  MDraw
//
//  Created by Gao Yongqing on 8/26/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawPolyline.h"

@implementation MDrawPolyline
{
    NSMutableArray *_points;
    CGPoint _movePoint;
    int _moveHandleIndex;
}

-(id)initWithStartPoint:(CGPoint)startPoint
{
    self = [super initWithStartPoint:startPoint];
    if(self)
    {
        _points = [[NSMutableArray alloc] init];
        _movePoint= CGPointZero;
        _moveHandleIndex = -1;
        [_points addObject:[NSValue valueWithCGPoint:startPoint]];
    }
    
    return self;
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

-(void)drawDown:(CGPoint)point
{
    
}

-(void)drawMove:(CGPoint)point
{
    _movePoint = point;
}

-(void)drawUp:(CGPoint)point
{
    _movePoint = CGPointZero;
    [_points addObject:[NSValue valueWithCGPoint:point]];
}

-(void)finalize:(CGPoint)point
{
    _finalized = YES;
    self.selected = YES;
}

-(BOOL)hitOnHandle:(CGPoint)point
{
    _moveHandleIndex = -1;
    if(_points.count > 0 )
    {
        for (int i = 0; i < _points.count; i++)
        {
            CGPoint handlePoint = [[_points objectAtIndex:i] CGPointValue];
            if([self isPoint:point onHandle:handlePoint])
            {
                _moveHandleIndex = i;
                return YES;
            }
        }
    }
    
    return NO;
}

-(void)moveToPoint:(CGPoint)point
{
    if(_moveHandleIndex >= 0)
    {
        [_points replaceObjectAtIndex:_moveHandleIndex withObject:[NSValue valueWithCGPoint:point]];
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
        
        
        if(!self.finalized && !CGPointEqualToPoint(_movePoint, CGPointZero))
        {
            CGContextAddLineToPoint(ctx, _movePoint.x,_movePoint.y);
        }
        
    }
    
    CGContextStrokePath(ctx);
    
    if (self.selected)
    {
        for (int i = 0; i < _points.count; i++)
        {
            CGPoint p = [[_points objectAtIndex:i] CGPointValue];
            [self drawHandle:ctx atPoint:p];
        }
    }

}

@end
