//
//  MDrawRect.m
//  MDraw
//
//  Created by Gao Yongqing on 8/23/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawRect.h"

@implementation MDrawRect
{
    enum MDrawMoveDirection _moveDirection;
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
}

-(void)finalize:(CGPoint)point
{
    _endPoint = point;
    _finalized = YES;
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
    if([self isPoint:point onHandle:CGRectMid(frame)])
    {
        _moveDirection = MDrawMoveDirectionWhole;
        return YES;
    }
    
    return NO;
}

-(void)moveToPoint:(CGPoint)point
{
    switch (_moveDirection) {
        case MDrawMoveDirectionTL:
            _startPoint = point;
            break;
        case MDrawMoveDirectionTM:
            _startPoint.y = point.y;
            break;
        case MDrawMoveDirectionTR:
            _startPoint.y = point.y;
            _endPoint.x = point.x;
            break;
        case MDrawMoveDirectionRM:
            _endPoint.x = point.x;
            break;
        case MDrawMoveDirectionBR:
            _endPoint = point;
            break;
        case MDrawMoveDirectionBM:
            _endPoint.y = point.y;
            break;
        case MDrawMoveDirectionBL:
            _startPoint.x = point.x;
            _endPoint.y = point.y;
            break;
        case MDrawMoveDirectionLM:
            _startPoint.x = point.x;
            break;
        case MDrawMoveDirectionWhole:
        {
            CGPoint preMiddle = CGPointMidPoint(_startPoint, _endPoint);
            CGSize offset = CGPointOffset(preMiddle, point);
            _startPoint.x += offset.width;
            _startPoint.y += offset.height;
            _endPoint.x += offset.width;
            _endPoint.y += offset.height;
            break;
        }
        default:
            break;
    }
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
        [self drawHandle:ctx atPoint:CGRectMid(frame)];
    }

}

@end
