//
//  DrawLineViewController.m
//  TTTT
//
//  Created by 无线盈 on 15/9/22.
//  Copyright © 2015年 wuxianying. All rights reserved.
//

#import "DrawLineViewController.h"
#import "DrawLineView.h"

@interface DrawLineViewController ()

@end

@implementation DrawLineViewController
{
    DrawLineView *dV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dV = [[DrawLineView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:dV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
