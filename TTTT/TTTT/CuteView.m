//
//  CuteView.m
//  TTTT
//
//  Created by 无线盈 on 15/9/29.
//  Copyright © 2015年 wuxianying. All rights reserved.
//

#import "CuteView.h"
#import "Utils.h"

#define LBL_H       200

@implementation CuteView
{
    NSMutableArray *lableArray;
    UIView          *collView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lableArray = [NSMutableArray new];
        
        [self initView];
    }
    return self;
}

-(void)initView
{
    [self setBackgroundColor:[UIColor lightGrayColor]];
    collView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LBL_H, LBL_H)];
    collView.center = CGPointMake(self.center.x, 260);
    collView.backgroundColor = [UIColor clearColor];
    [self addSubview:collView];
    for (int i = 1; i <= 6; i++) {
        UILabel *lbl = [self createlableWithTag:i];
        [lableArray addObject:lbl];
    }
    
    CATransform3D per = CATransform3DIdentity;
    per.m34 = -1.0/500.0;
    
    per = CATransform3DRotate(per, -M_PI_4, 1, 0, 0);
    per = CATransform3DRotate(per, -M_PI_4, 0, 1, 0);
    
    collView.layer.sublayerTransform = per;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];

    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
    
    
    
}

-(void)addFace:(NSInteger)index withTransform:(CATransform3D)transForm
{
    UILabel *lbl = lableArray[index];
    [collView addSubview:lbl];
    lbl.center = CGPointMake(LBL_H/2, LBL_H/2);
    lbl.layer.transform = transForm;
}

-(UILabel *)createlableWithTag:(NSInteger)tag
{
    UILabel *ret = [UILabel new];
    
    ret.tag = tag;
    ret.backgroundColor = [UIColor whiteColor];
    [ret setTextAlignment:NSTextAlignmentCenter];
    [ret setFont:[UIFont systemFontOfSize:36]];
    ret.frame = CGRectMake(0, 0, LBL_H, LBL_H);
    [ret setText:[NSString stringWithFormat:@"%ld",tag]];
    [ret setTextColor:[Utils randomColor]];
    
    return ret;
}

@end
