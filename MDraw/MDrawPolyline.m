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


-(id)init
{
    if(self = [super init])
    {
        _points = [[NSMutableArray alloc] init];
        _movePoint= CGPointZero;
        _moveHandleIndex = -1;
        _closePath = YES;
    }
    
    return self;
}

-(id)initWithStartPoint:(CGPoint)startPoint
{
    self = [super initWithStartPoint:startPoint];
    if(self)
    {
        _points = [[NSMutableArray alloc] init];
        _movePoint= CGPointZero;
        _moveHandleIndex = -1;
        _closePath = YES;
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
    
    BOOL isStartPoint = NO;
    if(_points.count > 0 )
    {
        CGPoint startPoint = [[_points objectAtIndex:0] CGPointValue];
        if([self isPoint:point onHandle:startPoint])
        {
            isStartPoint = YES;
        }
    }
    
    if(!isStartPoint)
    {
        [_points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //User close this shape by clicking the start point.
    if(isStartPoint && _points.count > 1)
    {
        [self finalize];
    }
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
        for (int i = 0; i < _points.count; i++)
        {
            CGPoint handlePoint = [[_points objectAtIndex:i] CGPointValue];
            if([self isPoint:point onHandle:handlePoint])
            {
                _moveHandleIndex = i;
                return YES;
            }
        }
        
        if(CGPointInRect(point, self.frame))
        {
            _moveHandleIndex = -2;
            return YES;
        }
    }
    
    return NO;
}

-(void)moveByOffset:(CGSize)offset
{
    if(_moveHandleIndex >= 0)
    {
        CGPoint movePoint = [[_points objectAtIndex:_moveHandleIndex] CGPointValue];
        movePoint = CGPointAddOffset(movePoint, offset);
        [_points replaceObjectAtIndex:_moveHandleIndex withObject:[NSValue valueWithCGPoint:movePoint]];
    }
    else if( _moveHandleIndex == -2) // move the shape
    {
        for (int i = 0; i < _points.count; i++)
        {
            CGPoint p = [[_points objectAtIndex:i] CGPointValue];
            [_points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:CGPointMake(p.x + offset.width, p.y + offset.height)]];
        }
    }
}

-(void)stopMoveHandle
{
    _moveHandleIndex = -1;
}

-(void)draw:(CGContextRef)ctx inView:(UIView *)view withoutMeasurement:(BOOL)noMeasurement
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
        
        //Close the shape
        if(self.finalized && _closePath)
        {
            CGContextClosePath(ctx);
        }
        
    }
    
    CGContextStrokePath(ctx);
    
    if (self.selected || !self.finalized)
    {
        for (int i = 0; i < _points.count; i++)
        {
            CGPoint p = [[_points objectAtIndex:i] CGPointValue];
            [self drawHandle:ctx atPoint:p];
        }
        
    }
    
    if(!noMeasurement && self.finalized && self.showMeasurement)
    {
        [self drawMeasurement:ctx inView:view];
    }

}

-(NSString *)measureText
{
    static NSString *lengthString, *areaString;
    if(!lengthString)
    {
        lengthString = NSLocalizedString(@"Length", Nil);
        areaString = NSLocalizedString(@"Area", Nil);
    }
    
    CGFloat length = CGPolygonLength(_points);
    CGFloat area = CGPolygonArea(_points);
    return [NSString stringWithFormat:@"%@: %0.2f %@\n%@: %0.2f sq%@",
            lengthString,
            [self unitConvert:length isSquare:NO],
            self.unit,
            areaString,
            [self unitConvert:area isSquare:YES],
            self.unit];
}

@end
