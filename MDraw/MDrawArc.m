//
//  MDrawArc.m
//  Motics
//
//  Created by Gao Yongqing on 2/5/14.
//
//

#import "MDrawArc.h"

@implementation MDrawArc

-(void)drawUp:(CGPoint)point
{
    _movePoint = CGPointZero;
    if(self.finalized)
    {
        return;
    }
    
    [_points addObject:[NSValue valueWithCGPoint:CGPointMidPoint(_startPoint, point)]];
    [_points addObject:[NSValue valueWithCGPoint:point]];
    [self finalize];
}

-(void)draw:(CGContextRef)ctx inView:(UIView *)view withoutMeasurement:(BOOL)noMeasurement
{
    if(self.finalized)
    {
        CGPoint from = [_points[0] CGPointValue];
        CGPoint arc = [_points[1] CGPointValue];
        CGPoint to = [_points[2] CGPointValue];
        
        CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
        CGContextSetLineWidth(ctx, 3);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, from.x, from.y);
        CGContextAddQuadCurveToPoint(ctx, arc.x, arc.y, to.x, to.y);
        CGContextStrokePath(ctx);
        
        if (self.selected)
        {
            [self drawHandle:ctx atPoint:from];
            [self drawHandle:ctx atPoint:arc];
            [self drawHandle:ctx atPoint:to];
        }
    }
    else
    {
        [super draw:ctx inView:view withoutMeasurement:YES];
    }
    
    if(!noMeasurement && self.finalized && self.showMeasurement)
    {
        [self drawMeasurement:ctx inView:view];
    }
}

-(NSString *)measureText
{
    static NSString *lengthString, *distanceString;
    if (!lengthString)
    {
        lengthString = NSLocalizedString(@"Length", Nil);
        distanceString = NSLocalizedString(@"Distance", Nil);
    }
    
    CGPoint p1 = [[_points objectAtIndex:0] CGPointValue];
    CGPoint arcPoint = [[_points objectAtIndex:1] CGPointValue];
    CGPoint p2 = [[_points objectAtIndex:2] CGPointValue];
    
    CGFloat length = CGArcLength(p1, arcPoint, p2);
    CGFloat distance = CGPointDistance(p1, p2);
    
    
    return [NSString stringWithFormat:@"%@: %0.2f %@\n%@: %0.2f %@",
                         lengthString,
                         [self unitConvert:length isSquare:NO],
                         self.unit,
                         distanceString,
                         [self unitConvert:distance isSquare:NO],
                         self.unit];
}

@end
