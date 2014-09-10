//
//  MDrawComment.m
//  Motics
//
//  Created by Gao Yongqing on 2/11/14.
//
//

#import "MDrawComment.h"

@implementation MDrawComment

-(void)drawUp:(CGPoint)point
{
    [super drawUp:point];
    
    [self promoteText];
}

-(void)draw:(CGContextRef)ctx
{
    [super draw:ctx];
    
    CGRect frame = self.frame;
    
    if (self.selected)
    {
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

#pragma Mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL added = buttonIndex == 1;
    
    if ( added )
    {
        self.text = [[alertView textFieldAtIndex:0] text];
        
        //Give a minimize size for comment.
        CGRect frame = self.frame;
        CGFloat width = frame.size.width < 200 ? 200 : frame.size.width;
        CGFloat height = frame.size.height < 150 ? 150 : frame.size.height;
        _endPoint = CGPointMake(frame.origin.x + width, frame.origin.y + height);
        
    }
    
    if(self.delegate)
    {
        [self.delegate drawTool:self isAdded:added];
    }
    
}

-(void)promoteText
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"enterYourText", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

@end
