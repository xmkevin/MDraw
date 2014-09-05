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

#import <Foundation/Foundation.h>
#include "MDrawMath.h"
//#include "UIColor+String.h"

#define HANDLE_SIZE 20
#define NEAR_WIDTH 10

@class PMDraw;

@protocol MDrawToolProtocol<NSObject>


/**
 *  Name of the tool.
 */
@property (nonatomic,strong)NSString *name;

/**
 *  Is the tool selected
 */
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
 *  YES to show measurement information while No to hide
 */
@property (nonatomic,assign) BOOL showMeasurement;

/**
 *  How many μm per pixel, default value is 0, means it does not have a calibration.
 */
@property (nonatomic,assign) CGFloat calibration;

/**
 *  Displaying unit, default is px;
 */
@property (nonatomic,strong) NSString *unit;

/**
 *  Get the measure text for this tool.
 */
@property (nonatomic, readonly) NSString *measureText;

/**
 * Init the tool with a start point.
 **/
-(id)initWithStartPoint:(CGPoint )startPoint;

/**
 * Draw mouse down (touchesBegan)
 **/
-(void)drawDown:(CGPoint)point;

/**
 * Draw mouse move (touchesMove)
 **/
-(void)drawMove:(CGPoint)point;

/**
 * Draw mouse up (touchesEnd)
 **/
-(void)drawUp:(CGPoint)point;

/**
 * Finalize the drawing
 **/
-(void)finalize;

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
-(void)moveByOffset:(CGSize)offset;

/**
 * Stop move the handle
 **/
-(void)stopMoveHandle;

/**
 *  Draw itself on the context
 *
 *  @param ctx context to draw on
 *
 *  @param view The view to draw on
 */
-(void)draw:(CGContextRef)ctx inView:(UIView *)view;

@end

/**
 * Base class of draw tool
 **/
@interface MDrawTool : NSObject <MDrawToolProtocol>
{
    
@private
    NSString *_unit;
@protected
    BOOL _finalized;
    CGPoint _startPoint, _endPoint;
    CGFloat _unitScale;
}

@end
