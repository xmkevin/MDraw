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
    NSMutableArray *_redoTools;
}

-(id)initWithTools:(NSMutableArray *)tools
{
    self = [super init];
    if(self)
    {
        _tools = tools;
        _redoTools = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(BOOL)undo
{
    if(_tools.count == 0 )
    {
        return NO;
    }
    
    NSInteger lastIndex = _tools.count -1;
    id lastTool = [_tools objectAtIndex:lastIndex];
    [_tools removeObjectAtIndex:lastIndex];
    [_redoTools addObject:lastTool];
    
    return YES;
}

-(BOOL)redo
{
    if(_redoTools.count == 0 )
    {
        return NO;
    }
    
    NSInteger lastIndex = _redoTools.count -1;
    id tool = [_redoTools objectAtIndex:lastIndex];
    [_redoTools removeObjectAtIndex:lastIndex];
    [_tools addObject:tool];
    
    return YES;
}

-(void)clearRedoes
{
    [_redoTools removeAllObjects];
}

@end
