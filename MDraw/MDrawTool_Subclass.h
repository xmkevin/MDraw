//
//  MDrawTool_Subclass.h
//  Motics
//
//  Created by Gao Yongqing on 3/3/14.
//
//

#import "MDrawTool.h"

@interface MDrawTool (ForSubClassEyesOnly)

/**
 *  Draw moving handlers
 *
 *  @param ctx   the context to draw
 *  @param point the handle location
 */
-(void)drawHandle:(CGContextRef)ctx atPoint:(CGPoint)point;

/**
 *  Determine whether or not the point is on the handle
 *
 *  @param point       a point to test
 *  @param handlePoint the handle point
 *
 *  @return YES if the point is on the handle, otherwise NO
 */
-(BOOL)isPoint:(CGPoint)point onHandle:(CGPoint)handlePoint;

/**
 *  Draw measurement information for tool
 *
 *  @param ctx  The context to draw
 *  @param view The parent viewer.
 */
-(void)drawMeasurement:(CGContextRef)ctx inView:(UIView *)view;

/**
 *  Convert pixels to current tool's unit by calibration.
 *
 *  @param pixels original pixel values
 *  @param square Is calculate area.
 *
 *  @return Value of current unit
 */
-(CGFloat)unitConvert:(CGFloat)pixels isSquare:(BOOL)square;

/**
 *  This method is for subclass to call, drawing without measurement information
 *
 *  @param ctx           Context to draw on
 *  @param view          The container view
 *  @param noMeasurement YES: no draw measurement information
 */
-(void)draw:(CGContextRef)ctx inView:(UIView *)view withoutMeasurement:(BOOL)noMeasurement;

@end
