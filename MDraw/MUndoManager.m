//
//  MUndoManager.m
//  MDraw
//
//  Created by Gao Yongqing on 8/28/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MUndoManager.h"

@implementation MUndoManager
{
    NSMutableArray *_tools;
    NSMutableArray *_undoTools;
    NSMutableArray *_redoTools;
}

-(id)initWithTools:(NSMutableArray *)tools
{
    self = [super init];
    if(self)
    {
        _tools = tools;
        _undoTools = [[NSMutableArray alloc] init];
        _redoTools = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(BOOL)undo
{
    if(_undoTools.count == 0 )
    {
        return NO;
    }
    
    id lastTool = [_undoTools lastObject];
    [_tools removeObject:lastTool];
    [_undoTools removeObject:lastTool];
    [_redoTools addObject:lastTool];
    
    return YES;
}

-(BOOL)redo
{
    if(_redoTools.count == 0 )
    {
        return NO;
    }
    
    id tool = [_redoTools lastObject];
    [_redoTools removeObject:tool];
    [_undoTools addObject:tool];
    [_tools addObject:tool];
    
    return YES;
}

-(void)removeTool:(id)tool
{
    [_tools removeObject:tool];
    [_redoTools addObject:tool];
}

-(void)addTool:(id)tool
{
    [_redoTools removeAllObjects];
    
    [_tools addObject:tool];
    [_undoTools addObject:tool];
}

-(void)reset
{
    [_redoTools removeAllObjects];
    [_undoTools removeAllObjects];
}

@end
