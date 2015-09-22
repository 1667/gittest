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

#import <Masonry.h>

#define SLIDER_W(vc)    (vc.view.frame.size.width/2+30)
#define SLIDER_LEN(vc)    (vc.view.frame.size.width/2-30)



@interface SilderViewController ()

@end

@implementation SilderViewController
{
    sliderView *sView;
    UIView      *flowView;
    MASConstraint *flowC;
    UIEdgeInsets flowEI;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    sView = [[sliderView alloc] initWithFrame:CGRectMake(0, 0, SLIDER_W(self), self.view.frame.size.height)];
    [self.view addSubview:sView];

    flowView = [UIView new];
    flowView.backgroundColor = [UIColor orangeColor];
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [flowView addGestureRecognizer:panG];
    [self.view addSubview:flowView];
    flowEI = UIEdgeInsetsMake(0, 0, 0, 0);
    [flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        flowC = make.edges.equalTo(self.view).insets(flowEI);
        
    }];
    
    UIButton *bottom = [UIButton new];
    [bottom setBackgroundColor:[UIColor blueColor]];
    [bottom addTarget:self action:@selector(dismissself:) forControlEvents:UIControlEventTouchUpInside];
    [flowView addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(flowView);
        make.height.equalTo(flowView.mas_height).multipliedBy(0.1);
    }];
    
    UIButton *top = [UIButton new];
    [top setBackgroundColor:[UIColor redColor]];
    [top addTarget:self action:@selector(dismissself:) forControlEvents:UIControlEventTouchUpInside];
    [flowView addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(flowView);
        make.height.equalTo(flowView.mas_height).multipliedBy(0.1);
    }];
    
}

-(void)dismissself:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFlowInsetTop:(CGFloat)top Left:(CGFloat)left Bottom:(CGFloat)bottom Right:(CGFloat)right animate:(BOOL)banimate
{
    flowEI = UIEdgeInsetsMake(top, left, bottom, right);
    flowC.insets = flowEI;
    if (banimate) {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
         [self.view layoutIfNeeded];
    }
   
}

-(void)handlePan:(UIPanGestureRecognizer *)pg
{
    CGPoint translation = [pg translationInView:flowView];
    NSLog(@"%@",[NSValue valueWithCGPoint:translation]);
    if (translation.x > 0) {
        flowEI = UIEdgeInsetsMake(translation.x*(20/SLIDER_W(self)), translation.x, translation.x*(20/SLIDER_W(self)), -translation.x);
        flowC.insets = flowEI;
        [self.view layoutIfNeeded];
    }
    else
    {
        flowEI = UIEdgeInsetsMake(0, 0, 0, 0);
        flowC.insets = flowEI;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
    if (pg.state == UIGestureRecognizerStateEnded) {
        if (translation.x > SLIDER_W(self)/2) {
            [self setFlowInsetTop:20 Left:SLIDER_W(self) Bottom:20 Right:-SLIDER_W(self) animate:YES];
        }
        else
        {
            [self setFlowInsetTop:0 Left:0 Bottom:0 Right:0 animate:YES];
        }
    }
    
    
}

@end
