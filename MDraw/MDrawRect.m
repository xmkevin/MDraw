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

#import "MDrawRect.h"

@implementation MDrawRect
{
   
}

-(void)drawDown:(CGPoint)point
{
}

-(void)drawMove:(CGPoint)point
{
    _endPoint = point;
}

-(void)drawUp:(CGPoint)point
{
     _endPoint = point;
    [self finalize];
}

-(void)finalize
{
    _finalized = YES;
    self.selected = YES;
}

-(BOOL)hitTest:(CGPoint)point
{
    return CGPointInRect(point, self.frame);
}

-(BOOL)hitOnHandle:(CGPoint)point
{
    
    _moveDirection = MDrawMoveDirectionNone;
    
    CGRect frame = self.frame;
    //After moving , start point and end point may not longer be the top left and bottom right
    // Here to correct.
    _startPoint = frame.origin;
    _endPoint = CGPointMake(_startPoint.x + frame.size.width, _startPoint.y + frame.size.height);
    
    if([self isPoint:point onHandle:CGRectTL(frame)])
    {
        _moveDirection = MDrawMoveDirectionTL;
        return YES;
    }
    if([self isPoint:point onHandle:CGRectTM(frame)])
    {
        _moveDirection = MDrawMoveDirectionTM;
        return YES;
    }
    if([self isPoint:point onHandle:CGRectTR(frame)])
    {
        _moveDirection = MDrawMoveDirectionTR;
        return YES;
    }
    if([self isPoint:point onHandle:CGRectRM(frame)])
    {
        _moveDirection = MDrawMoveDirectionRM;
        return YES;
    }
    if([self isPoint:point onHandle:CGRectBR(frame)])
    {
        _moveDirection = MDrawMoveDirectionBR;
        return YES;
    }
    if([self isPoint:point onHandle:CGRectBM(frame)])
    {
        _moveDirection = MDrawMoveDirectionBM;
        return YES;
    }
    if([self isPoint:point onHandle:CGRectBL(frame)])
    {
        _moveDirection = MDrawMoveDirectionBL;
        return YES;
    }
    if([self isPoint:point onHandle:CGRectLM(frame)])
    {
        _moveDirection = MDrawMoveDirectionLM;
        return YES;
    }
    if(CGPointInRect(point, frame))
    {
        _moveDirection = MDrawMoveDirectionWhole;
        return YES;
    }
    
    return NO;
}

-(void)moveByOffset:(CGSize)offset
{
    switch (_moveDirection) {
        case MDrawMoveDirectionTL:
            _startPoint = CGPointAddOffset(_startPoint, offset);
            break;
        case MDrawMoveDirectionTM:
            _startPoint.y += offset.height;
            break;
        case MDrawMoveDirectionTR:
            _startPoint.y += offset.height;
            _endPoint.x += offset.width;
            break;
        case MDrawMoveDirectionRM:
            _endPoint.x += offset.width;
            break;
        case MDrawMoveDirectionBR:
            _endPoint = CGPointAddOffset(_endPoint, offset);
            break;
        case MDrawMoveDirectionBM:
            _endPoint.y += offset.height;
            break;
        case MDrawMoveDirectionBL:
            _startPoint.x += offset.width;
            _endPoint.y += offset.height;
            break;
        case MDrawMoveDirectionLM:
            _startPoint.x += offset.width;
            break;
        case MDrawMoveDirectionWhole:
        {
            _startPoint = CGPointAddOffset(_startPoint, offset);
            _endPoint = CGPointAddOffset(_endPoint, offset);
            break;
        }
        default:
            break;
    }
}

-(void)stopMoveHandle
{
    _moveDirection = MDrawMoveDirectionNone;
}

-(void)draw:(CGContextRef)ctx
{
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    
    CGContextBeginPath(ctx);
    CGContextAddRect(ctx, self.frame);
    CGContextStrokePath(ctx);
    
    if (self.selected)
    {
        CGRect frame = self.frame;
        [self drawHandle:ctx atPoint:CGRectTL(frame)];
        [self drawHandle:ctx atPoint:CGRectTM(frame)];
        [self drawHandle:ctx atPoint:CGRectTR(frame)];
        [self drawHandle:ctx atPoint:CGRectRM(frame)];
        [self drawHandle:ctx atPoint:CGRectBR(frame)];
        [self drawHandle:ctx atPoint:CGRectBM(frame)];
        [self drawHandle:ctx atPoint:CGRectBL(frame)];
        [self drawHandle:ctx atPoint:CGRectLM(frame)];
    }

}

-(NSString *)measureText
{
    static NSString *widthString, *heightString, *areaString;
    if(!widthString)
    {
        widthString = NSLocalizedString(@"Width", nil);
        heightString = NSLocalizedString(@"Height", Nil);
        areaString = NSLocalizedString(@"Area", Nil);
    }
    
    CGRect frame = self.frame;
    
    return [NSString stringWithFormat:@"%@: %0.2f %@\n%@: %0.2f %@\n%@: %0.2f sq%@",
                             widthString,
                             [self unitConvert:frame.size.width isSquare:NO],
                             self.unit,
                             heightString,
                             [self unitConvert:frame.size.height isSquare:NO],
                             self.unit,
                             areaString,
                             [self unitConvert:frame.size.width * frame.size.height isSquare:YES],
                             self.unit];
}

@end
