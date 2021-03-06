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
#import <MBProgressHUD.h>

#define VC_W(vc)               (vc.view.frame.size.width)
#define VC_H(vc)               (vc.view.frame.size.height)

#define SCREEN_W               ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H               ([UIScreen mainScreen].bounds.size.height)

#define HALF_SCREEN_W             (SCREEN_W/2)
#define HALF_SCREEN_H             (SCREEN_H/2)

#define RANDOM_COLOR            [Utils randomColor]
#define WHITE_COLOR             [UIColor whiteColor]
#define CLEAR_COLOR             [UIColor clearColor]


#define STATUS_H                ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NAV_H(vc)               (vc.navigationController.navigationBar.frame.size.height)

#define NAV_STATUS_H(vc)        (NAV_H(vc)+STATUS_H)

#define IMAGE_CUP               @"tu8601_7.jpg"
#define IMAGE_CAMREA               @"tu8601_5.jpg"
#define IMAGE_ICE_CRE               @"tu8601_10.jpg"

#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

#define FILE_CACHE_DIC                          [NSHomeDirectory() stringByAppendingString:@"/Documents/Cache"]
#define FILE_CACHE_PATH_DIC                     [NSHomeDirectory() stringByAppendingString:@"/Documents/Cache/"]
#define FILE_FLAGES_URL(userid)                [FILE_CACHE_PATH_DIC stringByAppendingString:[NSString stringWithFormat:@"%@%@",userid,@"urlVedio"]]

@interface Utils : NSObject

+(UIColor *)randomColor;
+(UIImage *) createImageWithColor: (UIColor *) color;
+(MBProgressHUD *)createProHUDWithView:(UIView* )view Text:(NSString *)str;
+(BOOL)setLocalCache:(NSDictionary *)dic Flage:(NSString *)flage;
+(NSDictionary *)getLocalCache:(NSString *)flage;
+(BOOL)setLocalCacheWithObjct:(NSObject *)obj Flage:(NSString *)flage;

+(void)pauseLayer:(CALayer*)layer;
+(void)resumeLayer:(CALayer*)layer;

@end
