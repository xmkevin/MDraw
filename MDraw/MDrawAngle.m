//
//  MDrawAngle.m
//  Motics
//
//  Created by Gao Yongqing on 2/6/14.
//
//

#import "MDrawAngle.h"

@implementation MDrawAngle

-(id)init
{
    if(self = [super init])
    {
        _closePath = NO;
    }
    
    return self;
}

-(id)initWithStartPoint:(CGPoint)startPoint
{
    if(self = [super initWithStartPoint:startPoint])
    {
        _closePath = NO;
    }
    
    return self;
}



-(void)drawUp:(CGPoint)point
{
    _movePoint = CGPointZero;
    
    if(self.finalized)
    {
        return;
    }
    
    BOOL isStartPoint = NO;
    if(_points.count > 0 )
    {
        CGPoint startPoint = [[_points objectAtIndex:0] CGPointValue];
        if([self isPoint:point onHandle:startPoint])
        {
            isStartPoint = YES;
        }
    }
    
    if(!isStartPoint)
    {
        [_points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    if(_points.count >=3)
    {
        [self finalize];
    }
}

-(void)draw:(CGContextRef)ctx inView:(UIView *)view withoutMeasurement:(BOOL)noMeasurement
{
    [super draw:ctx inView:view withoutMeasurement:YES];
    
    if(self.finalized)
    {
        CGPoint p1 = [_points[0] CGPointValue];
        CGPoint p2 = [_points[1] CGPointValue];
        CGPoint p3 = [_points[2] CGPointValue];
        
        CGFloat line1 = CGPointDistance(p2, p1);
        CGFloat line2 = CGPointDistance(p2, p3);
        CGFloat minLength = MIN(line1, line2);
        CGFloat arcRadius = minLength > 20 ? 20 : minLength;
        
        CGFloat radian1 = CGVectorRadian(p2,p1);
        CGFloat radian2 = CGVectorRadian(p2,p3);
        
        CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, p2.x, p2.y, arcRadius,radian1,radian2, 0);
        CGContextStrokePath(ctx);
    }
    
    if(!noMeasurement && self.finalized && self.showMeasurement)
    {
        [self drawMeasurement:ctx inView:view];
    }
}

-(NSString *)measureText
{
    static NSString *degreeString;
    if(!degreeString)
    {
        degreeString = NSLocalizedString(@"Degree", Nil);
    }
    
    CGPoint p1 = [[_points objectAtIndex:0] CGPointValue];
    CGPoint arcPoint = [[_points objectAtIndex:1] CGPointValue];
    CGPoint p2 = [[_points objectAtIndex:2] CGPointValue];
    
    return [NSString stringWithFormat:@"%@ : %0.2f",
            degreeString,
            CGAngleDegree(p1, arcPoint, p2)];
}


@end
