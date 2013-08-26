//
//  MDrawLine.m
//  MDraw
//
//  Created by Gao Yongqing on 8/21/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawLine.h"

@implementation MDrawLine
{
    // 0 : no hited, 1 : startPoint, 2: endPoint, 3: Middle point
    int _handleHitStatus;
}

-(BOOL)hitTest:(CGPoint)point
{
    if(![super hitTest:point])
    {
        return NO;
    }
    
    float distance = CGPointToLineDistance(point, _startPoint, _endPoint);
    if(distance <= NEAR_WIDTH)
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)hitOnHandle:(CGPoint)point
{
    _handleHitStatus = 0;
    
    if([self isPoint:point onHandle:_startPoint])
    {
        _handleHitStatus = 1;
        return YES;
    }
    
    if([self isPoint:point onHandle:_endPoint])
    {
        _handleHitStatus = 2;
        return YES;
    }
    
    if([self isPoint:point onHandle:CGPointMidPoint(_startPoint, _endPoint)])
    {
        _handleHitStatus = 3;
        return YES;
    }
    
    return NO;
}

-(void)moveToPoint:(CGPoint)point
{
    
    if(_handleHitStatus == 1)
    {
        _startPoint = point;
    }
    else if(_handleHitStatus == 2)
    {
        _endPoint = point;
    }
    else if(_handleHitStatus == 3)
    {
        CGPoint preMidPoint = CGPointMidPoint(_startPoint, _endPoint);
        CGSize offset = CGPointOffset(preMidPoint, point);
        _startPoint.x += offset.width;
        _startPoint.y += offset.height;
        _endPoint.x += offset.width;
        _endPoint.y += offset.height;
    }
}

-(void)drawDown:(CGPoint)point
{
    _startPoint = point;
    _endPoint = point;
}

-(void)drawMove:(CGPoint)point
{
    _endPoint = point;
}

-(void)drawUp:(CGPoint)point
{
    if(self.finalized)
    {
        return;
    }
    
    _endPoint = point;
    if(!CGPointEqualToPoint(_startPoint, point))
    {
        [self finalize:point];
    }
}

-(void)finalize:(CGPoint)point
{
    _endPoint = point;
    _finalized = YES;
    self.selected = YES;
}

-(void)draw:(CGContextRef)ctx
{
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(ctx, _endPoint.x, _endPoint.y);
    CGContextStrokePath(ctx);
    
    if (self.selected)
    {
        [self drawHandle:ctx atPoint:_startPoint];
        [self drawHandle:ctx atPoint:_endPoint];
        [self drawHandle:ctx atPoint:CGPointMidPoint(_startPoint, _endPoint)];
    }

}

@end
