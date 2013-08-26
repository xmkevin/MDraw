//
//  MDrawView.h
//  MDraw
//
//  Created by Gao Yongqing on 8/19/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDrawTool.h"
#import "MDrawLine.h"
#import "MDrawFreeline.h"

@interface MDrawView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,readonly) MDrawTool *activeTool;
@property (nonatomic,readonly) BOOL drawing;

-(BOOL)undo;
-(BOOL)redo;

-(void)addTool:(MDrawTool *)tool;
-(void)removeTool:(MDrawTool *)tool;

-(void)beginDrawingForType:(Class)toolType;
-(void)finalizeDrawing;

@end
