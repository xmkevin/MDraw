//
//  MDrawTool.h
//  MDraw
//
//  Created by Gao Yongqing on 8/19/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HANDLE_SIZE 20
#define NEAR_WIDTH 10

CG_INLINE float CGPointDistance(CGPoint p1, CGPoint p2)
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    return sqrt(dx*dx + dy*dy);
}

CG_INLINE CGSize CGPointOffset(CGPoint p1, CGPoint p2)
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    return CGSizeMake(dx, dy);
}

CG_INLINE CGPoint CGPointMidPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

CG_INLINE float CGPointToLineDistance(CGPoint p, CGPoint p1,CGPoint p2)
{
    float a = p1.y - p2.y;
    float b = p2.x - p1.x;
    float c = (p1.x - b) * p1.y - p1.x * (p1.y + a);
    
    return fabsf(a * p.x + b * p.y + c) / sqrtf(a*a + b*b);
}

CG_INLINE BOOL CGPointInRect(CGPoint p, CGRect rect)
{
    return (p.x >= rect.origin.x &&
            p.x <= (rect.origin.x + rect.size.width) &&
            p.y >= rect.origin.y &&
            p.y <= (rect.origin.y + rect.size.height));
}

@protocol MDrawToolProtocol<NSObject>

/**
 * Is the tool selected
 **/
@property (nonatomic) BOOL selected;

/**
 * Is the tool finalized (finish drawing)
 **/
@property (nonatomic,readonly) BOOL finalized;

/**
 * Frame of this tool
 **/
@property (nonatomic,readonly) CGRect frame;

/**
 * Line width
 **/
@property (nonatomic)CGFloat lineWidth;

/**
 * Line color
 **/
@property (nonatomic,strong)UIColor *color;


/**
 * Init the tool with a start point.
 **/
-(id)initWithStartPoint:(CGPoint )startPoint;


-(void)drawDown:(CGPoint)point;

-(void)drawMove:(CGPoint)point;

-(void)drawUp:(CGPoint)point;

/**
 * Finalize the drawing with the end point
 **/
-(void)finalize:(CGPoint)point;

/**
 * Hit test to see whether or not the point is on the tool
 **/
-(BOOL)hitTest:(CGPoint)point;

/**
 * Determine whether or not the point hits a handle
 * If it hits a handle, then it can move the tool
 **/
-(BOOL)hitOnHandle:(CGPoint)point;

/**
 * Move the tool or the selected handle to the new position.
 **/
-(void)moveToPoint:(CGPoint)point;

/**
 * Draw itself on the contex
 **/
-(void)draw:(CGContextRef)ctx;

@end

/**
 * Base class of draw tool
 **/
@interface MDrawTool : NSObject <MDrawToolProtocol>
{
    @protected
    BOOL _finalized;
    CGPoint _startPoint, _endPoint;
}


-(void)drawHandle:(CGContextRef)ctx atPoint:(CGPoint)point;
-(BOOL)isPoint:(CGPoint)point onHandle:(CGPoint)handlePoint;

@end
