//
//  MDrawArrow.m
//  MDraw
//
//  Created by Gao Yongqing on 8/30/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawArrow.h"

@implementation MDrawArrow

-(BOOL)hitTest:(CGPoint)point
{
    return CGPointInRect(point, self.frame);
}

-(void)draw:(CGContextRef)ctx
{
    CGFloat length = CGPointDistance(_startPoint, _endPoint);
    CGSize dSize = CGPointOffset(_startPoint, _endPoint);
    
    // Draw an arrow at the horizontal line and then rotate it.
    // Here are the horizontal points.
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointMake(p1.x + length * 0.6, p1.y + length * 0.4);
    CGPoint p3 = CGPointMake(p1.x + length * 0.6, p1.y + length * 0.15);
    CGPoint p4 = CGPointMake(p1.x + length, p1.y + length * 0.15);
    CGPoint p5 = CGPointMake(p1.x + length, p1.y - length * 0.15);
    CGPoint p6 = CGPointMake(p1.x + length * 0.6, p1.y - length * 0.15);
    CGPoint p7 = CGPointMake(p1.x + length * 0.6, p1.y - length * 0.4);
    
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    
    
    CGContextBeginPath(ctx);
    
    CGContextTranslateCTM(ctx, _startPoint.x,_startPoint.y);
    CGContextRotateCTM(ctx, atan2f(dSize.height,dSize.width));
    
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    CGContextAddLineToPoint(ctx, p3.x, p3.y);
    CGContextAddLineToPoint(ctx, p4.x, p4.y);
    CGContextAddLineToPoint(ctx, p5.x, p5.y);
    CGContextAddLineToPoint(ctx, p6.x, p6.y);
    CGContextAddLineToPoint(ctx, p7.x, p7.y);
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    
    if (self.selected)
    {
        [self drawHandle:ctx atPoint:_startPoint];
        [self drawHandle:ctx atPoint:_endPoint];
        [self drawHandle:ctx atPoint:CGPointMidPoint(_startPoint, _endPoint)];
    }
    
   
}

@end
