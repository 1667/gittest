//
//  ServerManager.h
//  PropertyManager
//
//  Created by 无线盈 on 15/8/10.
//  Copyright (c) 2015年 wuxianying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerModels.h"
#import "AssistiveTouch.h"

#define HUD_LOANDING                @"正在加载"

#ifdef DEBUG
#define API_BASE_URL                @"http://dev.exiudaojia.com"

#else
#define API_BASE_URL                @"http://service.exiudaojia.com"
#endif


#define API_GET_WEATHER             [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/GetWeather.aspx"]
#define API_GET_WEATHER_2             [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/GetWeather2.aspx"]
#define API_CREATE_USER             [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/UserCreate.aspx"]
#define API_REPAIR_TYPES_GET        [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairTypesGet.aspx"]
#define API_LOG_IN                  [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/UserVerify.aspx"]
#define API_REPAIR_CREATE                       [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairCreate.aspx"]
#define API_REPAIR_CREATE_WITH_MEDIA            [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairCreateWithMedia.aspx"]
#define API_GET_NOTES               [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/Notes.aspx"]
#define API_GET_REPAIRS_LIST        [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairsGet.aspx"]
#define API_GET_REPAIRS_DETAIL      [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairDetailGet.aspx"]
#define API_GET_REPAIRS_LOG_LASTEST [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairLogLastest.aspx"]
#define API_CANCLE_REPAIRS          [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairRemove.aspx"]
#define API_START                   [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/Start.aspx"]
#define API_REPAIR_SOLVED           [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/RepairSolved.aspx"]
#define API_PROPERTY_BY_LOCATION    [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/PropertyByLocation.aspx"]
#define API_PROPERTY_BY_NAME        [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/propertyByName.aspx"]
#define API_FLEA_BY_PROPERTY        [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/FleaGetByProperty.aspx"]
#define API_FLEA_BY_OWNER           [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/FleaGetByOwner.aspx"]
#define API_FLEA_DELETE             [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/FleaDelete.aspx"]
#define API_FLEA_DETAIL             [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/FleaGet.aspx"]
#define API_FLEA_NEW                [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/FleaNew.aspx"]
#define API_FLEA_EDIT               [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/FleaEdit.aspx"]
#define API_RESETPW_BY_PHONE        [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/UserResetPasswordByMobile.aspx"]
#define API_ORDER_CREATE            [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/OrderCreate.aspx"]
#define API_GET_CASHCOUPONS            [NSString stringWithFormat:@"%@%@",API_BASE_URL,@"/Json/UserCashCouponsGet.aspx"]



#define CONTENT_TYPE                    @"Content-Type"
#define APP_JSON                        @"application/json"
#define APP_ZIP                         @"application/zip"
#define PLATFORM_NAME                   @"platformName"
#define CLIENT_VERSION                  @"clientVersion"
#define CHANNEL_ID                      @"channelId"
#define DATE                            @"date"

#define USER_NAME                               @"UserName"
#define uSER_NAME                               @"username"
#define TRUE_NAME                               @"truename"
#define ROOM                                    @"room"
#define PASSWORD                                @"Password"
#define pASSWORD                                @"password"
#define PROPERTY_ID                             @"propertyid"
#define FLEA_ID                                 @"fleaid"
#define PAGE_INDEX                              @"pageindex"
#define USER_ID                                 @"userid"
#define MYTOKEN                                 @"mytoken"
#define SOFT_TYPE                               @"softtype"
#define REPAIR_TYPES                            @"repairtypearray"
#define REPAIR_TYPES_ID                         @"typeid"
#define REPAIR_ID                               @"repairid"
#define LOGO_ID                                 @"logoid"
#define TEL_NUM                                 @"telnumber"
#define BODY                                    @"body"
#define PICTURESS                               @"pictures"
#define PICTURES                                @"images.zip"
#define NOTE_ARRAY                              @"notearray"
#define REPAIR_ARRAY                            @"repairarray"

#define FLEA_ARRAY                              @"fleaarray"
#define FLEA                                    @"flea"

#define LATITUDE                                @"latitude"
#define LONGITUDE                               @"longitude"
#define DESCRIPTION                             @"description"
#define PAGE_INDEX                              @"pageindex"

#define FILE_CACHE_DIC                          [NSHomeDirectory() stringByAppendingString:@"/Documents/Cache"]
#define FILE_CACHE_PATH_DIC                     [NSHomeDirectory() stringByAppendingString:@"/Documents/Cache/"]
#define FILE_FLAGES_PERSONINFO                  [FILE_CACHE_PATH_DIC stringByAppendingString:@"personInfo"]
#define FILE_FLAGES_START                       [FILE_CACHE_PATH_DIC stringByAppendingString:@"start"]
#define FILE_FLAGES_NOTE(userid)                [FILE_CACHE_PATH_DIC stringByAppendingString:[NSString stringWithFormat:@"%@%@",userid,@"noteID"]]
#define FILE_FLAGES_MAINT_PHONE_NUM(userid)     [FILE_CACHE_PATH_DIC stringByAppendingString:[NSString stringWithFormat:@"%@%@",userid,@"phoneNum"]]

#define FILE_FLAGES_FLEA_PHONE_NUM(userid)     [FILE_CACHE_PATH_DIC stringByAppendingString:[NSString stringWithFormat:@"%@%@",userid,@"phoneNum"]]

typedef NS_ENUM(NSInteger,AF_CallType) {
    GET,
    POST
};

typedef void(^SuccessBlock)(NSDictionary *dictionary);
typedef void(^FaildBlock)(NSString *errDescription);

typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface ServerManager : NSObject

@property (nonatomic,strong)PersonInfoModel *personInfo;
@property (nonatomic,strong)RegistInfoModel *registInfo;
@property (nonatomic,assign)BOOL            bVistor;
@property (nonatomic,strong)AssistiveTouch       *superWind;
@property (nonatomic,strong)NSString        *deviceToken;

+(ServerManager*)instance;

-(void)initWithVistor;

-(void)getCityWeather:(NSString *)cityName withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;
-(void)getCityWeather2:(NSString *)cityName withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;
-(void)userCreate:(NSString *)userName telnumber:(NSString *)telnumber TrueName:(NSString *)trueName Room:(NSString *)room
         Password:(NSString *)password PropertyID:(NSString *)propertyID
 withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)repairTypesGet:(NSString *)propertyID UserID:(NSString *)userid
     withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;
-(void)LogIn:(NSString *)userName Password:(NSString *)password
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;
-(void)RepairCreate:(NSString *)userID PropertyID:(NSString *)propertyid Typeid:(NSString *)typeid
Telnumber:(NSString *)telnumber Body:(NSString *)body Pictures:(NSString *)path
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)RepairCreateEX:(NSString *)userID PropertyID:(NSString *)propertyid Typeid:(NSString *)typeid
Telnumber:(NSString *)telnumber Body:(NSString *)body Pictures:(NSString *)path
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))pBlock;

-(void)RepairCreateWithMedia:(NSString *)userID PropertyID:(NSString *)propertyid Typeid:(NSString *)typeid
Telnumber:(NSString *)telnumber Body:(NSString *)body mediamiage:(NSArray *)images mediavideo:(NSArray *)video
mediaaudio:(NSArray *)audio
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)getNotes:(NSString *)propertyid PageIndex:(NSString *)pageindex
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)getRepairList:(NSString *)propertyid UserID:(NSString *)userID type:(NSString *)type
    withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)getRepairDetail:(NSString *)propertyid UserID:(NSString *)userID RepairID:(NSString *)repairID
      withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)getRepairLogLastest:(NSString *)propertyid UserID:(NSString *)userID
          withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;


-(void)cancleRepair:(NSString *)propertyid RepairID:(NSString *)repairID UserID:(NSString *)userID
   withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)repairSloved:(NSString *)code PropertyId:(NSString *)propertyid RepairID:(NSString *)repairId UserID:(NSString *)userid
   withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;
-(void)propertyBylatitude:(NSString *)latitude Longitude:(NSString *)longitude Pageindex:(NSString *)pageindex
         withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)propertyByDescription:(NSString *)description Pageindex:(NSString *)pageindex
            withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)fleaGetByProperty:(NSString *)property Pageindex:(NSString *)pageindex
        withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)fleaGetByOwner:(NSString *)property UserID:(NSString *)userid
     withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)fleaDeleteWithID:(NSString *)fleaid PropertyID:(NSString *)propertyId UserID:(NSString *)userid
       withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)fleaDetailWithID:(NSString *)fleaid PropertyID:(NSString *)propertyId
       withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)FleaNewEX:(NSString *)userID PropertyID:(NSString *)propertyid Header:(NSString *)header TelNumber:(NSString *)telnumber
     Description:(NSString *)description Pictures:(NSString *)path
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))pBlock;

-(void)FleaEditEXWithFleaID:(NSString *)fleaId PropertyID:(NSString *)propertyid UserID:(NSString *)userID Header:(NSString *)header
                  TelNumber:(NSString *)telnumber Description:(NSString *)description DeleteList:(NSString *)deletelist Pictures:(NSString *)path
           withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))pBlock;

-(void)getStartPages:(NSString *)propertyid LogoID:(NSString *)logoID
   withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)userResetPasswordByMobile:(NSString *)mobile newpassword:(NSString *)newpassword
                withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock;

-(void)orderCreateWithParamModel:(OrderCreateParamModel *)paramModel
                        bShowHUD:(BOOL)bShowHUD
                          inView:(UIView *)view
                            text:(NSString *)text
                withSuccessBlock:(SuccessBlock)successBlock
                       fileBlock:(FaildBlock)fileBlock;

-(void)getCashCoupon:(NSString *)userid
            bShowHUD:(BOOL)bShowHUD
              inView:(UIView *)view
                text:(NSString *)text
    withSuccessBlock:(SuccessBlock)successBlock
           fileBlock:(FaildBlock)fileBlock;


-(BOOL)setLocalCacheWithObjct:(NSObject *)obj Flage:(NSString *)flage;
-(BOOL)setLocalCache:(NSDictionary *)dic Flage:(NSString *)flage;
-(NSDictionary *)getLocalCache:(NSString *)flage;

@end
