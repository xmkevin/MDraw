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

#import "MDrawTool.h"

@implementation MDrawTool
{
    UIColor *_handleFillColor;
}

@synthesize selected;
@synthesize finalized = _finalized;
@synthesize lineWidth;
@synthesize color;


-(CGRect)frame
{
    return CGRectMake(MIN(_startPoint.x, _endPoint.x),
                      MIN(_startPoint.y, _endPoint.y),
                      fabsf(_endPoint.x - _startPoint.x),
                      fabsf(_endPoint.y - _startPoint.y));
}

-(id)initWithStartPoint:(CGPoint)startPoint
{
    if(self=[super init])
    {
        _startPoint = startPoint;
        _endPoint = startPoint;
        
        self.color = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.6];
        self.lineWidth = 3;
        
        _handleFillColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
    }
    
    return self;
}

-(void)drawDown:(CGPoint)point
{
}

-(void)drawMove:(CGPoint)point
{
}

-(void)drawUp:(CGPoint)point
{
}

-(void)finalize:(CGPoint)point
{
    _endPoint = point;
}

-(BOOL)hitTest:(CGPoint)point
{
    return CGPointInRect(point, self.frame);
}

-(BOOL)hitOnHandle:(CGPoint)point
{
    return NO;
}

-(void)moveToPoint:(CGPoint)point
{
}

-(void)draw:(CGContextRef)ctx
{
}

#pragma mark - protected methods 

//TODO: decide where to put these protected methods.

-(void)drawHandle:(CGContextRef)ctx atPoint:(CGPoint)point
{
    CGContextSetFillColorWithColor(ctx, _handleFillColor.CGColor);
    CGRect handleRect = CGRectMake(point.x- HANDLE_SIZE /2, point.y- HANDLE_SIZE /2, HANDLE_SIZE, HANDLE_SIZE);
    CGContextSetLineWidth(ctx, 2);
    CGContextFillEllipseInRect(ctx, handleRect);
    CGContextStrokeEllipseInRect(ctx, handleRect);
}

-(BOOL)isPoint:(CGPoint)point onHandle:(CGPoint)handlePoint
{
    CGRect handleRect = CGRectMake(handlePoint.x- HANDLE_SIZE /2, handlePoint.y- HANDLE_SIZE /2, HANDLE_SIZE, HANDLE_SIZE);
    return CGPointInRect(point, handleRect);
}

@end
