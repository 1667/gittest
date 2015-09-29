//
//  Utils.h
//  TTTT
//
//  Created by innke on 15/9/20.
//  Copyright © 2015年 wuxianying. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import <Masonry.h>

#define VC_W(vc)               (vc.view.frame.size.width)
#define VC_H(vc)               (vc.view.frame.size.height)

#define STATUS_H                ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NAV_H(vc)               (vc.navigationController.navigationBar.frame.size.height)

#define NAV_STATUS_H(vc)        (NAV_H(vc)+STATUS_H)

#define IMAGE_CUP               @"tu8601_7.jpg"
#define IMAGE_CAMREA               @"tu8601_5.jpg"
#define IMAGE_ICE_CRE               @"tu8601_10.jpg"

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

@interface Utils : NSObject

+(UIColor *)randomColor;

@end
