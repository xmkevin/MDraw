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

@synthesize name;
@synthesize selected;
@synthesize finalized = _finalized;
@synthesize lineWidth;
@synthesize color;
@synthesize showMeasurement;
@synthesize calibration;
@synthesize measureText;

-(id)init
{
    if(self = [super init])
    {
        _handleFillColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.6];
        self.lineWidth = 3;
        self.calibration = 0;
        self.unit = @"px";
        _unitScale = 1;
    }
    
    return self;
}

-(id)initWithStartPoint:(CGPoint)startPoint
{
    if(self=[self init])
    {
        _startPoint = startPoint;
        _endPoint = startPoint;
    }
    
    return self;
}

-(NSString *)unit
{
    return [_unit copy];
}

-(void)setUnit:(NSString *)unit
{
    _unit = unit;
    _unitScale = 1;
    
    if([_unit isEqualToString:@"μm"] || [_unit isEqualToString:@"um"])
    {
        _unitScale = 1;
    }
    else if([_unit isEqualToString:@"mm"])
    {
        _unitScale = 1 / 1000.0;
    }
    else if([_unit isEqualToString:@"cm"])
    {
        _unitScale = 1 / 1000000.0;
    }
}

-(CGRect)frame
{
    return CGRectMake(MIN(_startPoint.x, _endPoint.x),
                      MIN(_startPoint.y, _endPoint.y),
                      fabsf(_endPoint.x - _startPoint.x),
                      fabsf(_endPoint.y - _startPoint.y));
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

-(void)moveByOffset:(CGSize)offset
{
}

-(void)stopMoveHandle
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
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
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

-(void)drawMeasurement:(CGContextRef)ctx
{
    
    NSString *text = self.measureText;
    if(text == Nil)
    {
        return;
    }
    
    CGSize textSize = CGSizeZero;
    UIFont *textFont = [UIFont systemFontOfSize:14];
    
    if(text != Nil)
    {
            textSize= [text sizeWithFont:textFont
                               constrainedToSize:CGSizeMake(1024, 99999.0)
                                   lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    
    CGRect textFrame = [self calculateTextFrameWithTextSize:textSize forToolFrame:self.frame];
    CGRect textBgFrame = CGRectMake(textFrame.origin.x - 10, textFrame.origin.y - 10, textFrame.size.width + 20, textFrame.size.height + 20);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5].CGColor);
    CGContextFillRect(ctx, textBgFrame);
    
    [text drawWithRect:textFrame options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:Nil];
    
}

-(CGRect)calculateTextFrameWithTextSize:(CGSize)textSize forToolFrame:(CGRect)toolFrame
{
    static CGFloat MARGIN = 20;
    
    CGRect textFrame = CGRectZero;
    CGPoint midPoint = CGRectMid(toolFrame);
    textFrame = CGRectMake(midPoint.x - textSize.width / 2.0f, toolFrame.origin.y - textSize.height - MARGIN, textSize.width, textSize.height);
    
    return textFrame;
    
}

-(CGFloat)unitConvert:(CGFloat)pixels isSquare:(BOOL)square
{
    if([_unit isEqualToString:@"px"])
    {
        return pixels;
    }
    
    CGFloat result = pixels * self.calibration * _unitScale;
    if(square)
    {
        result *= ( self.calibration * _unitScale );
    }
    
    return result;
}

@end
