//
//  Utils.m
//  TTTT
//
//  Created by innke on 15/9/20.
//  Copyright © 2015年 wuxianying. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(UIColor *)randomColor
{
    CGFloat r = arc4random()%256 / 255.0f;
    CGFloat g = arc4random()%256 / 255.0f;
    CGFloat b = arc4random()%256 / 255.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
    
}

@end
