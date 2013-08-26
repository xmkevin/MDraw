//
//  ViewController.m
//  MDraw
//
//  Created by Gao Yongqing on 8/19/13.
//  Copyright (c) 2013 Motic China Group Co., Ltd. All rights reserved.
//

#import "ViewController.h"

#import "MDrawView.h"
#import "MDrawLine.h"
#import "MDrawRect.h"
#import "MDrawEllipse.h"
#import "MDrawFreeline.h"
#import "MDrawPolyline.h"

@interface ViewController ()

@end

@implementation ViewController
{
    __weak IBOutlet MDrawView *drawView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    drawView = [[MDrawView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:drawView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)drawLine:(id)sender
{
    [drawView beginDrawingForType:[MDrawLine class]];
}

-(IBAction)drawRect:(id)sender
{
    [drawView beginDrawingForType:[MDrawRect class]];
}

-(IBAction)drawEllipse:(id)sender
{
    [drawView beginDrawingForType:[MDrawEllipse class]];
}

-(IBAction)drawFreeline:(id)sender
{
    [drawView beginDrawingForType:[MDrawFreeline class]];
}

-(IBAction)drawPolyline:(id)sender
{
    [drawView beginDrawingForType:[MDrawPolyline class]];
}

-(IBAction)finishDrawing:(id)sender
{
    [drawView finalizeDrawing];
}



@end
