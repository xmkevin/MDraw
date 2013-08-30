//    The MIT License (MIT)
//
//    Copyright (c) 2013 xmkevin
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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

-(void)finalize
{
    _finalized = YES;
    self.selected = YES;
}

-(BOOL)hitOnHandle:(CGPoint)point
{
    _moveHandleIndex = -1;
    
    
    if(_points.count > 0 )
    {
        if([self isPoint:point onHandle:CGRectMid(self.frame)])
        {
            _moveHandleIndex = -2;
            return YES;
        }
        
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
    else if( _moveHandleIndex == -2) // move the shape
    {
        CGPoint midPoint = CGRectMid(self.frame);
        CGSize offset = CGPointOffset(midPoint, point);
        
        for (int i = 0; i < _points.count; i++)
        {
            CGPoint p = [[_points objectAtIndex:i] CGPointValue];
            [_points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:CGPointMake(p.x + offset.width, p.y + offset.height)]];
        }
    }
}

-(void)draw:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
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
        
        CGPoint mid = CGRectMid(self.frame);
        [self drawHandle:ctx atPoint:mid];
    }
    
    CGContextRestoreGState(ctx);

}

@end
