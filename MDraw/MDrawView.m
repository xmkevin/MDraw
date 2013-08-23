//
//  MDrawView.m
//  MDraw
//
//  Created by Gao Yongqing on 8/19/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "MDrawView.h"

@implementation MDrawView
{
    NSMutableArray *_tools;
    Class _drawToolClass;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tools = [[NSMutableArray alloc] init];
        [self initGestures];
        
        _drawToolClass = [MDrawLine class];
    }
    return self;
}

-(BOOL)undo
{
    return NO;
}

-(BOOL)redo
{
    return NO;
}

-(void)addTool:(MDrawTool *)tool
{
    [_tools addObject:tool];
}

-(void)removeTool:(MDrawTool *)tool
{
    [_tools removeObject:tool];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx,self.frame);
    for (MDrawTool *tool in _tools)
    {
        [tool draw:ctx];
    }
}

-(void)beginDrawingForType:(Class)toolType
{
}

-(void)finalizeDrawing
{
}

#pragma mark - private methods

-(void)initGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.delegate = self;
    [self addGestureRecognizer:longPressGesture];
    
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
}

-(void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];
    [self selectTool:point];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder.nextResponder touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    if(self.drawing)
    {
        [self drawDown:point];
    }
    else
    {
        [self.activeTool hitOnHandle:point];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder.nextResponder touchesMoved:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    if(self.drawing)
    {
        [self drawMove:point];
    }
    else
    {
        [self.activeTool moveToPoint:point];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder.nextResponder touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    if(self.drawing)
    {
        [self drawFinish:point];
    }
    else
    {
        [self.activeTool moveToPoint:point];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - draw

-(void)drawDown:(CGPoint)point
{
    _activeTool = [[_drawToolClass alloc] initWithStartPoint:point];
    [_tools addObject:_activeTool];
}

-(void)drawMove:(CGPoint)point
{
    [_activeTool drawMove:point];
}

-(void)drawUp:(CGPoint)point
{
    [_activeTool drawUp:point];
}

-(void)drawFinish:(CGPoint)point
{
    [_activeTool finalize:point];
}

#pragma mark - hit tests

-(void)selectTool:(CGPoint)point
{
    BOOL hasSelected = NO;
    _activeTool = Nil;
    
    for (int i = _tools.count -1; i >= 0; i--)
    {
        MDrawTool *tool = [_tools objectAtIndex:i];
        
        if([tool hitTest:point] && !hasSelected)
        {
            hasSelected = YES;
            
            tool.selected = YES;
            _activeTool = tool;
        }
        else
        {
            tool.selected = NO;
        }
    }
    
    [self setNeedsDisplay];
}


@end
