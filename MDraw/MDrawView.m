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


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Initialization code
        _tools = [[NSMutableArray alloc] init];
        [self initGestures];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tools = [[NSMutableArray alloc] init];
        [self initGestures];
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
    if(_activeTool)
    {
        _activeTool.selected = NO;
        _activeTool = Nil;
        [self setNeedsDisplay];
    }
    
    _drawToolClass = toolType;
    _drawing = YES;
}

-(void)finalizeDrawing
{
    [_activeTool finalize];
    _drawing = NO;
    [self setNeedsDisplay];
}

#pragma mark - private methods

-(void)initGestures
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

-(void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self];
    if(_drawing)
    {
        [self drawUp:point];
        [self setNeedsDisplay];
    }
    else
    {
        [self selectTool:point];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self drawDown:point];
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self drawMove:point];
    
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self drawUp:point];
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - draw

-(void)drawDown:(CGPoint)point
{
    if(self.drawing)
    {
        if(_activeTool && !_activeTool.finalized && _drawing)
        {
            [_activeTool drawDown:point];
        }
        else
        {
            _activeTool = [[_drawToolClass alloc] initWithStartPoint:point];
            [_tools addObject:_activeTool];
        }
        
        [self setNeedsDisplay];
    }
    else
    {
        [self.activeTool hitOnHandle:point];
    }
}

-(void)drawMove:(CGPoint)point
{
    if(self.drawing)
    {
        [self.activeTool drawMove:point];
    }
    else
    {
        [self.activeTool moveToPoint:point];
    }
    
    [self setNeedsDisplay];
}

-(void)drawUp:(CGPoint)point
{
    if(self.drawing)
    {
        [self.activeTool drawUp:point];
        
        if(self.activeTool.finalized)
        {
            _drawing = NO;
        }
    }
    else
    {
        [self.activeTool moveToPoint:point];
    }
    
    [self setNeedsDisplay];
}

-(void)drawFinish
{
    [_activeTool finalize];
    _drawing = NO;
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
