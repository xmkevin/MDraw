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

#import "MDrawView.h"
#import "MUndoManager.h"

@implementation MDrawView
{
    NSMutableArray *_tools;
    Class _drawToolClass;
    MUndoManager *_undoManager;
    BOOL _isMoved; // Is mouse or figure moved
    CGFloat _lineWidth;
    BOOL _enableGesture;
    BOOL _showMeasurement;
    NSString *_unit;
}

@synthesize color;
@synthesize calibration = _calibration;
@synthesize isDirty = _isDirty;


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Initialization code
        _tools = [[NSMutableArray alloc] init];
        _undoManager = [[MUndoManager alloc] initWithTools:_tools];
        
        self.color = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.6];
        _lineWidth = 3;
        _calibration = 0;
        
        _enableGesture = YES;
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

- (void)refreshCalibrations
{
    for (MDrawTool *tool in _tools)
    {
        tool.calibration = self.calibration;
        tool.unit = self.unit;
        tool.showMeasurement = self.showMeasurement;
    }
    
    [self setNeedsDisplay];
}

-(BOOL)hasTools
{
    return _tools.count > 0;
}

-(NSArray *)tools
{
    return _tools;
}

-(CGFloat)lineWidth
{
    return _lineWidth;
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    if(_activeTool)
    {
        _activeTool.lineWidth = lineWidth;
        
        [self setNeedsDisplay];
    }
    
    _lineWidth = lineWidth;
}

-(BOOL)enableGesture
{
    return _enableGesture;
}

-(void)setEnableGesture:(BOOL)enableGesture
{
    _enableGesture = enableGesture;
    
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        g.enabled = _enableGesture;
    }
    
    self.multipleTouchEnabled = _enableGesture;
}

-(BOOL)showMeasurement
{
    return _showMeasurement;
}

-(void)setShowMeasurement:(BOOL)showMeasurement
{
    _showMeasurement = showMeasurement;
    
    for (MDrawTool *tool in _tools) {
        tool.showMeasurement = showMeasurement;
    }
    
    [self setNeedsDisplay];
    
}

- (CGFloat)calibration
{
    return _calibration;
}

- (void)setCalibration:(CGFloat)calibration
{
    _calibration = calibration;
    
    [self refreshCalibrations];
}

-(NSString *)unit
{
    if(_unit == Nil)
    {
        _unit = @"px";
    }
    
    return _unit;
}

-(void)setUnit:(NSString *)unit
{
    _unit = unit;
    
    [self refreshCalibrations];
}


-(BOOL)undo
{
    if([_undoManager undo])
    {
        [self setNeedsDisplay];
        return YES;
    }
    
    return NO;
}

-(BOOL)redo
{
    if([_undoManager redo])
    {
        [self setNeedsDisplay];
        return YES;
    }
    
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    if (_tools && _tools.count > 0) {
        // Drawing code
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //CGContextClearRect(ctx,self.frame);
        for (MDrawTool *tool in _tools)
        {
            [tool draw:ctx];
        }
    }
}

-(void)beginDrawingForType:(Class)toolType
{
    if(toolType == Nil)
    {
        _drawToolClass = Nil;
        _drawing = NO;
        
        return;
    }
    
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

-(void)deleteCurrentTool
{
    if(_activeTool)
    {
        [_undoManager removeTool:_activeTool];
        _activeTool = Nil;
        
        _isDirty = YES;
        
        [self setNeedsDisplay];
    }
}

-(void)clearTools
{
    [_tools removeAllObjects];
    [_undoManager reset];
    [self setNeedsDisplay];
}

-(void)selectNone
{
    if(_activeTool)
    {
        _activeTool.selected = NO;
        [self setNeedsDisplay];
    }
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
    
    
    [self.nextResponder touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint prePoint = [touch previousLocationInView:self];
    CGPoint point = [touch locationInView:self];
    
    [self drawMoveFromPoint:prePoint toPoint:point];
    
    [self.nextResponder touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self drawUp:point];
    
    [self.nextResponder touchesEnded:touches withEvent:event];
}

#pragma mark - draw

-(void)drawDown:(CGPoint)point
{
    _isMoved = NO;
    
    if(self.drawing)
    {
        if(_activeTool && !_activeTool.finalized && _drawing)
        {
            [_activeTool drawDown:point];
        }
        else
        {
            _activeTool = [[_drawToolClass alloc] initWithStartPoint:point];
            _activeTool.color = self.color;
            _activeTool.lineWidth = self.lineWidth;
            _activeTool.showMeasurement = self.showMeasurement;
            _activeTool.unit = self.unit;
            _activeTool.calibration = self.calibration;
            //Comment tool is special, it should interate with alert views.
            if([_activeTool isKindOfClass:[MDrawComment class]])
            {
                MDrawComment *comment = (MDrawComment *)_activeTool;
                comment.delegate = self;
            }
            
            [_undoManager addTool:_activeTool];
            
            _isDirty = YES;
        }
        
        [self setNeedsDisplay];
    }
    else
    {
        [self.activeTool hitOnHandle:point];
    }
}

-(void)drawMoveFromPoint:(CGPoint)srcPoint toPoint:(CGPoint)point
{
    _isMoved = YES;
    _isDirty = YES;
    
    if(self.drawing)
    {
        [self.activeTool drawMove:point];
    }
    else
    {
        CGSize offset = CGPointOffset(srcPoint, point);
        [self.activeTool moveByOffset:offset];
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
        if(_isMoved)
        {
            [self.activeTool stopMoveHandle];
        }
        else
        {
            //Click or tap
            [self selectTool:point];
        }
        
    }
    
    [self setNeedsDisplay];
    
    _isMoved = NO;
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

#pragma mark - draw comment protocol

-(void)drawTool:(MDrawTool *)tool isAdded:(BOOL)added
{
    if(added)
    {
        [self setNeedsDisplay];
    }
    else
    {
        [self deleteCurrentTool];
    }
}


@end
