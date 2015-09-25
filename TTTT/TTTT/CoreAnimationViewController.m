//
//  CoreAnimationViewController.m
//  TTTT
//
//  Created by 无线盈 on 15/9/25.
//  Copyright © 2015年 wuxianying. All rights reserved.
//

#import "CoreAnimationViewController.h"
#import "ScrollTitltView.h"

@interface CoreAnimationViewController ()

@end

@implementation CoreAnimationViewController
{
    ScrollTitltView *scrollTitle;
    CGFloat         vH;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    vH = self.view.frame.size.height-40;
    
    NSMutableArray *vA = [NSMutableArray new];
    [vA addObject:[self createFirstView]];
    [vA addObject:[self createSecondView]];
    
    scrollTitle = [[ScrollTitltView alloc] initWithFrame:CGRectMake(0, NAV_STATUS_H(self), self.view.frame.size.width, self.view.frame.size.height-NAV_STATUS_H(self)) titleText:@[@"TTT1",@"TTT2"] viewArray:vA];
    [self.view addSubview:scrollTitle];
    
    
    
}

-(UIView *)createFirstView
{
    UIView *view = [UIView new];
    view.backgroundColor = [Utils randomColor];
    
    UIView *v1 = [UIView new];
    v1.backgroundColor = [Utils randomColor];
    UIImage *image = [UIImage imageNamed:IMAGE_CAMREA];
    v1.layer.contents = (__bridge id)(image.CGImage);
    //1
    v1.layer.contentsGravity = kCAGravityResizeAspect;
    //2
//    v1.layer.contentsGravity = kCAGravityCenter;
//    v1.layer.contentsScale = 3;
    
    [view addSubview:v1];
    [v1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(10);
        make.right.equalTo(view.right).offset(-10);
        make.height.equalTo(v1.width);
        make.centerY.equalTo(view.centerY);
    }];
    
    
    return view;
}

-(UIView *)createSecondView
{
    UIView *view = [UIView new];
    
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
