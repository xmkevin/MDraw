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
