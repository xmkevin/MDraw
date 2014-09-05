//
//  MDrawText.m
//  Motics
//
//  Created by Gao Yongqing on 2/10/14.
//
//

#import "MDrawText.h"

@implementation MDrawText
{
    UILabel *_label; // Use a label to display text;
}

-(id)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    if(self = [super init])
    {
        _startPoint = frame.origin;
        _endPoint = CGPointMake(_startPoint.x + frame.size.width, _startPoint.y + frame.size.height);
        
        self.text = text;
    }
    
    return self;
}

-(void)draw:(CGContextRef)ctx inView:(UIView *)view
{
    if(!self.backgroundColor)
    {
        self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    }
    
    if(!_label)
    {
        _label = [[UILabel alloc] init];
        _label.adjustsFontSizeToFitWidth = YES;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.textColor = self.color;
        _label.font = [UIFont systemFontOfSize:60];
        _label.minimumScaleFactor = 0.001f;
        _label.numberOfLines = 0;
        
        _label.layer.borderWidth =2;
        _label.layer.borderColor = self.color.CGColor;
        
    }
    
    CGRect frame = self.frame;
    
    CGContextSaveGState(ctx);
    
    
    if([self.text length] > 0)
    {
        _label.frame =  CGRectMake(0, 0, frame.size.width, frame.size.height);
        _label.text = self.text;
        CGContextTranslateCTM(ctx, frame.origin.x, frame.origin.y);
        [_label.layer drawInContext:ctx];
        
    }
    else
    {
        CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
        CGContextFillRect(ctx, frame);
    }
    
    CGContextRestoreGState(ctx);
    
}

@end
