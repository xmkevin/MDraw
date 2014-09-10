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
    }
    
}

-(NSString *)measureText
{
    static NSString *radiusString, *areaString, *perimeterString;
    if(!radiusString)
    {
        radiusString = NSLocalizedString(@"Radius", nil);
        areaString = NSLocalizedString(@"Area", nil);
        perimeterString = NSLocalizedString(@"Perimeter", nil);
    }
    
    CGFloat radius = fabs((_startPoint.x - _endPoint.x)/2.0);
    CGFloat area = M_PI * pow(radius, 2);
    CGFloat perimeter = 2 * M_PI * radius;
    
    return [NSString stringWithFormat:@"%@: %0.2f %@\n%@: %0.2f sq%@\n%@: %0.2f %@",
                     radiusString,
                     [self unitConvert:radius isSquare:NO],
                     self.unit,
                     areaString,
                     [self unitConvert:area isSquare:YES],
                     self.unit,
                     perimeterString,
                     [self unitConvert:perimeter isSquare:NO],
                     self.unit];
}

@end
