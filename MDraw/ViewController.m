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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MDrawView *drawView = [[MDrawView alloc] initWithFrame:self.view.frame];
    MDrawTool *tool = [[MDrawLine alloc] initWithStartPoint:CGPointMake(100, 100)];
    tool.selected = NO;
    [tool finalize:CGPointMake(200, 200)];
    [drawView addTool:tool];
    [self.view addSubview:drawView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
