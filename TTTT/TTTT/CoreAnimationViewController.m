//
//  CoreAnimationViewController.m
//  TTTT
//
//  Created by 无线盈 on 15/9/25.
//  Copyright © 2015年 wuxianying. All rights reserved.
//

#import "CoreAnimationViewController.h"
#import "ScrollTitltView.h"

#define MASK_W          30

@interface CoreAnimationViewController ()

@end

@implementation CoreAnimationViewController
{
    ScrollTitltView *scrollTitle;
    CGFloat         vH;
    NSTimer         *timer;
    UIImageView     *hour;
    UIImageView     *minute;
    UIImageView     *secord;
    UIView          *colockView;
    UIView          *v1;
    BOOL            bBig;
    CAShapeLayer    *v1Sh;
    UIBezierPath    *v1path;
    BOOL            bMoveing;
    NSTimer         *timeMove;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    vH = self.view.frame.size.height-40;
    
    NSMutableArray *vA = [NSMutableArray new];
    [vA addObject:[self createFirstView]];
    colockView = [self createSecondView];
    [vA addObject:colockView];
    [vA addObject:[self createShaowView]];
    
    scrollTitle = [[ScrollTitltView alloc] initWithFrame:CGRectMake(0, NAV_STATUS_H(self), self.view.frame.size.width, self.view.frame.size.height-NAV_STATUS_H(self)) titleText:@[@"TTT1",@"TTT2",@"阴影"] viewArray:vA];
    [self.view addSubview:scrollTitle];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [self tick];
    
    
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

- (void)tick
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    //rotate hands
    hour.transform = CGAffineTransformMakeRotation(hoursAngle);
    minute.transform = CGAffineTransformMakeRotation(minsAngle);
    secord.transform = CGAffineTransformMakeRotation(secsAngle);
    
}

-(UIView *)createSecondView
{
    UIView *view = [UIView new];
    
    
    UIImageView *clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
    clock.frame = CGRectMake(0, 0, self.view.frame.size.width-20, self.view.frame.size.width-20);
    clock.center = self.view.center;
    
    hour = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hour"]];
    hour.frame = CGRectMake(0, 0, 20, 80);
    hour.center = self.view.center;
    hour.layer.anchorPoint = CGPointMake(0.5, 0.9);
    
    minute = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minute"]];
    minute.frame = CGRectMake(0, 0, 20, 100);
    minute.center = self.view.center;
    minute.layer.anchorPoint = CGPointMake(0.5, 0.9);
    //minute.layer.zPosition = 0.1;
    
    secord = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secord"]];
    secord.frame = CGRectMake(0, 0, 20, 120);
    secord.center = self.view.center;
    secord.layer.anchorPoint = CGPointMake(0.5, 0.9);
    
    [view addSubview:clock];
    [view addSubview:hour];
    [view addSubview:minute];
    [view addSubview:secord];
    
    return view;
}

-(UIView *)createShaowView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    v1 = [UIView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [v1 addGestureRecognizer:tap];
    v1.backgroundColor = [Utils randomColor];
    v1.layer.shadowOpacity = 0.5f;
    v1.layer.shadowOffset = CGSizeMake(10, 10);
    v1.layer.shadowRadius = 10;
    v1.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"tu8601_10.jpg"].CGImage);
    v1Sh = [CAShapeLayer layer];
    v1path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(MASK_W, MASK_W) radius:MASK_W startAngle:M_PI endAngle:-M_PI clockwise:NO];
    v1Sh.path = v1path.CGPath;
    v1.layer.mask = v1Sh;
    [view addSubview:v1];
    [v1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(10);
        make.right.equalTo(view.right).offset(-10);
        make.top.equalTo(view.top).offset(10);
        make.height.equalTo(v1.width);
    }];
    
    UIButton *makeBig = [UIButton new];
    [makeBig addTarget:self action:@selector(big:) forControlEvents:UIControlEventTouchUpInside];
    makeBig.backgroundColor = [Utils randomColor];
    [view addSubview:makeBig];
    [makeBig makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(view);
        make.right.equalTo(view.centerX);
        make.height.equalTo(view.height).multipliedBy(0.08);
    }];
    UIButton *moveT = [UIButton new];
    [moveT addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
    moveT.backgroundColor = [Utils randomColor];
    [view addSubview:moveT];
    [moveT makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(view);
        make.left.equalTo(view.centerX);
        make.height.equalTo(view.height).multipliedBy(0.08);
    }];
    
    
    return view;
}

-(void)taped:(UITapGestureRecognizer *)taped
{
    NSLog(@"touccccccccccc");
    
    if ([v1path containsPoint:[taped locationInView:v1]]) {
        NSLog(@"222222222");
    }
    
}

-(void)big:(id)sender
{
    if (bBig) {
        
        v1path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 60, 60)];
        //v1Sh.path = v1path.CGPath;
        CABasicAnimation *pathA = [CABasicAnimation animationWithKeyPath:@"path"];
        pathA.duration = 1;
        pathA.delegate = self;
        pathA.toValue = (__bridge id _Nullable)(v1path.CGPath);
        [v1Sh addAnimation:pathA forKey:@"strokeEnd1"];
        
        bBig = NO;
    }
    else
    {
        
        v1path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.view.frame.size.width-60, self.view.frame.size.width-60)];
        
        CABasicAnimation *pathA = [CABasicAnimation animationWithKeyPath:@"path"];
        pathA.duration = 1;
        pathA.toValue = (__bridge id _Nullable)(v1path.CGPath);
        pathA.delegate = self;
        [v1Sh addAnimation:pathA forKey:@"strokeEnd2"];
        
        bBig = YES;
    }
    
    
}

-(void)moveMask
{
    NSInteger w = self.view.frame.size.width-60;
    NSInteger randomx = arc4random()% w;
    NSInteger randomy = arc4random()% w;
    
    CABasicAnimation *pathA = [CABasicAnimation animationWithKeyPath:@"frame"];
    pathA.duration = 1;
    v1Sh.frame = CGRectMake(randomx, randomy, 80, 80);
    [v1Sh addAnimation:pathA forKey:@"strokeEnd3"];
}

-(void)move:(id)sender
{
    if (bMoveing) {
        bMoveing = NO;
        [timeMove invalidate];
        [v1Sh removeAllAnimations];
        
        CGPoint point = v1.center;
        CABasicAnimation *pathA = [CABasicAnimation animationWithKeyPath:@"frame"];
        pathA.duration = 1;
        v1Sh.frame = CGRectMake(point.x, point.y, 80, 80);
        pathA.delegate = self;
        [v1Sh addAnimation:pathA forKey:@"strokeEnd4"];
        
    }
    else
    {
        timeMove = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(moveMask) userInfo:nil repeats:YES];
        bMoveing = YES;
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        //v1Sh.path = v1path.CGPath;
        UIBezierPath *toPath = [UIBezierPath bezierPathWithArcCenter:v1.center radius:v1.center.x startAngle:M_PI endAngle:-M_PI clockwise:NO];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        
        pathAnimation.toValue = (id)toPath.CGPath;
        pathAnimation.duration = 1.0;
        [v1Sh addAnimation:pathAnimation forKey:@"cir"];
    }
}
//测试hittest
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    CGPoint point = [[touches anyObject] locationInView:colockView];
//    CALayer *layer = [colockView.layer hitTest:point];
//    if (layer == hour.layer) {
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"Hour" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
