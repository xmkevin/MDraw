//
//  MUndoManager.h
//  MDraw
//
//  Created by Gao Yongqing on 8/28/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//
//  Provide a simple undo/redo manager for drawing tools.

#import <Foundation/Foundation.h>

@interface MUndoManager : NSObject

-(id)initWithTools:(NSMutableArray *)tools;

-(BOOL)undo;
-(BOOL)redo;
-(void)clearRedoes;

@end
