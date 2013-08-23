//
//  MDrawEllipse.m
//  MDraw
//
//  Created by Gao Yongqing on 8/23/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawEllipse.h"

@implementation MDrawEllipse

-(void)draw:(CGContextRef)ctx
{
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    
    CGContextBeginPath(ctx);
    CGContextAddEllipseInRect(ctx, self.frame);
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
