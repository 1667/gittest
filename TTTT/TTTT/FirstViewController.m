//
//  FirstViewController.m
//  TTTT
//
//  Created by innke on 15/9/2.
//  Copyright (c) 2015年 wuxianying. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "SilderViewController.h"
#import "ShapelayerViewController.h"
#import "DrawLineViewController.h"
#import "TestScrollHeaderViewController.h"
#import "CoreAnimationViewController.h"
#import "CA2ViewController.h"
#import "CA3ViewController.h"
#import <objc/runtime.h>
#import "VideoSDKViewController.h"
#import "MovieViewController.h"
#import "CA4ViewController.h"
#import "CA5ViewController.h"
#import "ContectViewController.h"
#import "BezierDLViewController.h"


#define VC_W(vc)        (vc.view.frame.size.width)
#define VC_H(vc)        (vc.view.frame.size.height)


@interface FirstViewController ()<passValueDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation FirstViewController
{
    UITextView              *label;
    UITableView             *_tableView;
    
    NSMutableArray          *arrData;
    NSMutableArray          *vcArr;
    
}
//Viewcontrol有自己的生命周期，一般在这个函数里初始化界面就行了

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    arrData = [NSMutableArray new];
    vcArr = [NSMutableArray new];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VC_W(self), VC_H(self)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    [self addTableCellWithTitle:@"来回滚动" VC:[SecondViewController class]];
    [self addTableCellWithTitle:@"侧边栏" VC:[SilderViewController class]];
    [self addTableCellWithTitle:@"Context画线" VC:[DrawLineViewController class]];
    [self addTableCellWithTitle:@"ShapeLayer" VC:[ShapelayerViewController class]];
    [self addTableCellWithTitle:@"下拉刷新" VC:[TestScrollHeaderViewController class]];
    [self addTableCellWithTitle:@"动画" VC:[CoreAnimationViewController class]];
    [self addTableCellWithTitle:@"动画2" VC:[CA2ViewController class]];
    [self addTableCellWithTitle:@"动画3" VC:[CA3ViewController class]];
    [self addTableCellWithTitle:@"百川SDK" VC:[VideoSDKViewController class]];
    [self addTableCellWithTitle:@"视频播放" VC:[MovieViewController class]];
    [self addTableCellWithTitle:@"动画4" VC:[CA4ViewController class]];
    [self addTableCellWithTitle:@"动画5" VC:[CA5ViewController class]];
    [self addTableCellWithTitle:@"联系人优化" VC:[ContectViewController class]];
    [self addTableCellWithTitle:@"Bezier画线" VC:[BezierDLViewController class]];
    
}

-(void)addTableCellWithTitle:(NSString *)title VC:(Class )vc
{
    [arrData addObject:title];
    //NSLog(@"%@",[NSString stringWithFormat:@"%s",class_getName([vc class])]);
    [vcArr addObject:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toSecond:(id)sender
{
    SecondViewController *tmpVc = [SecondViewController new];
    [tmpVc setStr:@"TTT"];//传到第二个界面
    tmpVc.delegate = self;//实现传值的协议
    [self.navigationController pushViewController:tmpVc animated:YES];
}

-(void)passValue:(NSString *)str
{
    [label setText:str];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellstr = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstr];
    
    cell.textLabel.text = [arrData objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (indexPath.row == 1) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[vcArr objectAtIndex:indexPath.row] new]];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }
    else
    {
        [self.navigationController pushViewController:[[vcArr objectAtIndex:indexPath.row] new] animated:YES];
    }
    
    
    
}

-(UIViewController *)getVCFromClassName:(NSString *)str
{
    const char *className = [str cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
        
    }
    id instance = [[newClass alloc] init];
    
    return instance;
    
    
}

@end
