//
//  SilderViewController.m
//  TTTT
//
//  Created by innke on 15/9/20.
//  Copyright © 2015年 wuxianying. All rights reserved.
//

#import "SilderViewController.h"
#import "sliderView.h"
#import "Utils.h"

#define SLIDER_W(vc)    (vc.view.frame.size.width/2+30)
#define SLIDER_LEN(vc)    (vc.view.frame.size.width/2-30)

@interface SilderViewController ()

@end

@implementation SilderViewController
{
    sliderView *sView;
    UIView      *flowView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    sView = [[sliderView alloc] initWithFrame:CGRectMake(0, 0, SLIDER_W(self), self.view.frame.size.height)];
    [self.view addSubview:sView];
    flowView = [[UIView alloc] initWithFrame:self.view.frame];
    flowView.backgroundColor = [UIColor orangeColor];
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [flowView addGestureRecognizer:panG];
    [self.view addSubview:flowView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handlePan:(UIPanGestureRecognizer *)pg
{
    CGPoint translation = [pg translationInView:flowView];
    NSLog(@"%@",[NSValue valueWithCGPoint:translation]);
    
    
}

@end
