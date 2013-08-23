//
//  MDrawTool.m
//  MDraw
//
//  Created by Gao Yongqing on 8/19/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

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
                      MAX(_startPoint.x, _endPoint.x),
                      MAX(_startPoint.y, _endPoint.y));
}

-(id)initWithStartPoint:(CGPoint)startPoint
{
    if(self=[super init])
    {
        _startPoint = startPoint;
        _endPoint = startPoint;
        
        self.color = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.6];
        self.lineWidth = 3;
        self.selected = YES;
        
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
