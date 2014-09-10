//
//  MDrawMeasurementInfo.m
//  MDraw
//
//  Created by Gao Yongqing on 9/5/14.
//  Copyright (c) 2014 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawMeasurementInfo.h"

@implementation MDrawMeasurementInfo

@synthesize tool = _tool;

- (id)init
{
    [NSException raise:@"InitException" format:@"Should call initWithTool to create an instance."];
    
    return nil;
}

- (instancetype)initWithTool:(MDrawTool *)aTool
{
    if (self = [super init]) {
        _tool = aTool;
    }
    
    return self;
}

- (void)draw:(CGContextRef)ctx
{
    NSString *text = self.tool.measureText;
    if(text == Nil)
    {
        return;
    }
    
    CGSize textSize = CGSizeZero;
    UIFont *textFont = [UIFont systemFontOfSize:14];
    
    if(text != Nil)
    {
        textSize= [text sizeWithFont:textFont
                   constrainedToSize:CGSizeMake(1024, 99999.0)
                       lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    
    CGRect textFrame = [self calculateTextFrameWithTextSize:textSize forToolFrame:self.tool.frame];
    CGRect textBgFrame = CGRectMake(textFrame.origin.x - 10, textFrame.origin.y - 10, textFrame.size.width + 20, textFrame.size.height + 20);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5].CGColor);
    CGContextFillRect(ctx, textBgFrame);
    
    [text drawWithRect:textFrame options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:Nil];
}

-(CGRect)calculateTextFrameWithTextSize:(CGSize)textSize forToolFrame:(CGRect)toolFrame
{
    static CGFloat MARGIN = 20;
    
    CGRect textFrame = CGRectZero;
    CGPoint midPoint = CGRectMid(toolFrame);
    textFrame = CGRectMake(midPoint.x - textSize.width / 2.0f, toolFrame.origin.y - textSize.height - MARGIN, textSize.width, textSize.height);
    
    return textFrame;
    
}

@end
