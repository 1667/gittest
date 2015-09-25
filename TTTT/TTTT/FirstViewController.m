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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    arrData = [[NSMutableArray alloc] initWithObjects:@"来回滚动", nil];
    vcArr = [[NSMutableArray alloc] initWithObjects:[SecondViewController new], nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VC_W(self), VC_H(self)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    [self addTableCellWithTitle:@"侧边栏" VC:[SilderViewController new]];
    [self addTableCellWithTitle:@"Context画线" VC:[DrawLineViewController new]];
    [self addTableCellWithTitle:@"ShapeLayer" VC:[ShapelayerViewController new]];
    [self addTableCellWithTitle:@"下拉刷新" VC:[TestScrollHeaderViewController new]];
}

-(void)addTableCellWithTitle:(NSString *)title VC:(UIViewController *)vc
{
    [arrData addObject:title];
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
    
    _popWin.hidden = !_popWin.hidden;
    
    if (indexPath.row == 1) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[vcArr objectAtIndex:indexPath.row]];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
    }
    else
    {
        [self.navigationController pushViewController:[vcArr objectAtIndex:indexPath.row] animated:YES];
    }
    
    
    
}

@end
