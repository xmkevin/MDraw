//
//  MDrawComment.h
//  Motics
//
//  Created by Gao Yongqing on 2/11/14.
//
//

#import "MDrawText.h"

@protocol MDrawCommentDelegate <NSObject>

-(void)drawTool:(MDrawTool *)tool isAdded:(BOOL)added;

@end

@interface MDrawComment : MDrawText<UIAlertViewDelegate>

@property (nonatomic,weak) id<MDrawCommentDelegate> delegate;

@end
