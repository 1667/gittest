//
//  ServerManager.m
//  PropertyManager
//
//  Created by 无线盈 on 15/8/10.
//  Copyright (c) 2015年 wuxianying. All rights reserved.
//

#import "ServerManager.h"
#import <AFNetworking.h>
#import "ServerModels.h"
#import "NSString+MD5HexDigest.h"
#import "Utils.h"

@implementation ServerManager

@synthesize registInfo;

+(ServerManager*)instance
{
    static ServerManager  *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:FILE_CACHE_DIC])
        {
            [fileManager createDirectoryAtPath:FILE_CACHE_PATH_DIC withIntermediateDirectories:YES attributes:nil error:nil];
        }
        manager.bVistor = NO;
    });
    
    return manager;
}

-(NSString *)codeTOString:(int)code
{
    switch (code) {
        case 200:
            return @"成功";
        case 201:
            return @"空数据";
        case 401:
            return @"非法用户";
        case 402:
            return @"会话超时重新登录";
        case 403:
            return @"用户名密码错误";
        case 404:
            return @"路径有误";
        case 405:
            return @"用户名已存在";
        case 406:
            return @"参数错误";
        case 407:
            return @"收信人无效";
        case 408:
            return @"用户未拥有该小区住宅";
        case 409:
            return @"欢迎使用掌上物业";
        case 300:
            return @"数据验证错误";
        case 500:
            return @"系统错误";
        default:
            break;
    }
    return @"";
}

-(void)initWithVistor
{
    _bVistor = YES;
    PersonInfoModel *perinfo = [PersonInfoModel new];
    perinfo.UserID = @"0";
    perinfo.PropertyID = @"0";
    _personInfo = perinfo;
}

-(AFHTTPRequestOperationManager *)getManagerWithHeader
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:APP_JSON forHTTPHeaderField:CONTENT_TYPE];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:PLATFORM_NAME];
    [manager.requestSerializer setValue:@"2.0" forHTTPHeaderField:CLIENT_VERSION];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:CHANNEL_ID];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    [manager.requestSerializer setValue:locationString forHTTPHeaderField:DATE];
    return manager;
}
-(AFHTTPRequestOperationManager *)getManagerWithZipHeader
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:APP_ZIP forHTTPHeaderField:CONTENT_TYPE];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:PLATFORM_NAME];
    [manager.requestSerializer setValue:@"2.0" forHTTPHeaderField:CLIENT_VERSION];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:CHANNEL_ID];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    [manager.requestSerializer setValue:locationString forHTTPHeaderField:DATE];
    return manager;
}
-(void)callAPI:(NSString *)api Param:(NSDictionary *)param withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    AFHTTPRequestOperationManager *manager = [self getManagerWithHeader];
    
    if (manager != nil) {
        [manager POST:api parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                NSLog(@"%@----%@",api,dic);
                int t = [[dic objectForKey:@"code"] intValue];
                if (t == 200) {
                    if (successBlock != nil) {
                        successBlock(dic);
                    }
                    
                }
                else
                {
                    if (fileBlock != nil) {
                        fileBlock([dic objectForKey:@"desc"]);
                    }
                    
                }
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error)
         {
             if (fileBlock != nil) {
                 fileBlock([error localizedDescription]);
             }
             
         }];
    }
    
}

-(void)callAPI:(NSString *)api CallType:(AF_CallType)callType Param:(NSDictionary *)param bShowHUD:(BOOL)bShowHUD inView:(UIView *)inView text:(NSString *)text withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    AFHTTPRequestOperationManager *manager = [self getManagerWithHeader];
    
    if (manager != nil) {
        MBProgressHUD *hud;
        if (bShowHUD) {
            if (inView == nil) {
                inView = [UIApplication sharedApplication].keyWindow;
            }
            hud = [[MBProgressHUD alloc] initWithView:inView];
            [inView addSubview:hud];
            hud.labelText = text;
            [hud show:YES];
        }
        switch (callType) {
            case POST:
            {
                
                [self post:manager API:api HUD:hud Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
                
            }
                break;
            case GET:
            {
                [self get:manager API:api HUD:hud Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
                
            }
                break;
            default:
                break;
        }
        
    }
    
}

-(void)post:(AFHTTPRequestOperationManager *)manager API:(NSString *)api HUD:(MBProgressHUD *)hud Param:(NSDictionary *)param withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSLog(@"%@----%@",api,param);
    [manager POST:api parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            [hud removeFromSuperview];
            NSLog(@"%@----%@",api,dic);
            int t = [[dic objectForKey:@"code"] intValue];
            if (t == 200) {
                if (successBlock != nil) {
                    successBlock(dic);
                }
                
            }
            else
            {
                if (fileBlock != nil) {
                    fileBlock([dic objectForKey:@"desc"]);
                }
                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"%@----%@",api,error);
         [hud removeFromSuperview];
         if (fileBlock != nil) {
             fileBlock([error localizedDescription]);
         }
         
     }];
}

-(void)get:(AFHTTPRequestOperationManager *)manager API:(NSString *)api HUD:(MBProgressHUD *)hud Param:(NSDictionary *)param withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSLog(@"%@----%@",api,param);
    [manager GET:api parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject) {
    
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            [hud removeFromSuperview];
            NSLog(@"%@----%@",api,dic);
            int t = [[dic objectForKey:@"code"] intValue];
            if (t == 200) {
                if (successBlock != nil) {
                    successBlock(dic);
                }
                
            }
            else
            {
                if (fileBlock != nil) {
                    fileBlock([dic objectForKey:@"desc"]);
                }
                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"%@----%@",api,error);
         [hud removeFromSuperview];
         if (fileBlock != nil) {
             fileBlock([error localizedDescription]);
         }
         
     }];
}

-(void)UploadFile:(NSMutableURLRequest *)request withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock ProgressBlock:(ProgressBlock)pBlock
{
    AFHTTPRequestOperationManager *manager = [self getManagerWithHeader];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             NSDictionary *dic = (NSDictionary *)responseObject;
                                                                             NSLog(@"ttt%@",dic);
                                                                             int t = [[dic objectForKey:@"code"] intValue];
                                                                             if (t == 200) {
                                                                                 if (successBlock != nil) {
                                                                                     successBlock(dic);
                                                                                 }
                                                                             }
                                                                             else
                                                                             {
                                                                                 if (fileBlock != nil) {
                                                                                     fileBlock([dic objectForKey:@"desc"]);
                                                                                 }
                                                                                 
                                                                             }
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             if (fileBlock != nil) {
                                                                                 fileBlock([error localizedDescription]);
                                                                             }
                                                                         }];
    
    
    [operation setUploadProgressBlock:pBlock];
    [operation start];
}

- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    
    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    
    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
    //
    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    //
    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPMethod:@"POST"];
    //
    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        
        NSLog(@"下载失败");
        
    }];
    
    [operation start];
    
}


-(void)getCityWeather2:(NSString *)cityName withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    AFHTTPRequestOperationManager *manager = [self getManagerWithHeader];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"北京" forKey:@"cityname"];
    [param setValue:@"" forKey:@"mytoken"];
    NSLog(@"%@",param);
    [manager POST:API_GET_WEATHER_2 parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            int t = [[dic objectForKey:@"code"] intValue];
            if (t == 200) {
                if (successBlock != nil) {
                    successBlock(dic);
                }
                
            }
            else
            {
                if (fileBlock != nil) {
                    fileBlock([dic objectForKey:@"desc"]);
                }
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         if (fileBlock != nil) {
             fileBlock([error localizedDescription]);
         }
         
     }];
    
    
}

-(void)userCreate:(NSString *)userName telnumber:(NSString *)telnumber TrueName:(NSString *)trueName Room:(NSString *)room
         Password:(NSString *)password PropertyID:(NSString *)propertyID
 withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    AFHTTPRequestOperationManager *manager = [self getManagerWithHeader];
    
    NSDictionary *param = @{MYTOKEN:@"",
                            @"username":userName,
                            @"telnumber":telnumber,
                            TRUE_NAME:trueName,
                            ROOM:room,
                            pASSWORD:[password md5HexDigest],
                            PROPERTY_ID:propertyID
                            };
    NSLog(@"%@",param);
    
    
    [manager POST:API_CREATE_USER parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            int t = [[dic objectForKey:@"code"] intValue];
            if (t == 200) {
                if (successBlock != nil) {
                    successBlock(dic);
                }
                
            }
            else
            {
                if (fileBlock != nil) {
                    fileBlock([dic objectForKey:@"desc"]);
                }
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         if (fileBlock != nil) {
             fileBlock([error localizedDescription]);
         }
         
     }];

    
}

-(void)repairTypesGet:(NSString *)propertyID UserID:(NSString *)userid
     withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:propertyID,
                            USER_ID:userid
                            };
    [self callAPI:API_REPAIR_TYPES_GET Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
}

-(void)LogIn:(NSString *)userName Password:(NSString *)password
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    NSDictionary *param = @{MYTOKEN:@"",
                            uSER_NAME:userName,
                            
                            pASSWORD:[password md5HexDigest],
                            SOFT_TYPE:@"2"
                            };
    
    [self callAPI:API_LOG_IN Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
    
}
-(void)RepairCreate:(NSString *)userID PropertyID:(NSString *)propertyid Typeid:(NSString *)typeid
          Telnumber:(NSString *)telnumber Body:(NSString *)body Pictures:(NSString *)path
   withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    AFHTTPRequestOperationManager *manager = [self getManagerWithHeader];
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:propertyid,
                            USER_ID:userID,
                            REPAIR_TYPES_ID:typeid,
                            TEL_NUM:telnumber,
                            BODY:body
                            };
    NSURL *filePath = [NSURL fileURLWithPath:path];
    [manager POST:API_REPAIR_CREATE parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:filePath name:PICTURES  error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"ttt%@",dic);
        int t = [[dic objectForKey:@"code"] intValue];
        if (t == 200) {
            if (successBlock != nil) {
                successBlock(dic);
            }
        }
        else
        {
            if (fileBlock != nil) {
                fileBlock([dic objectForKey:@"desc"]);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fileBlock != nil) {
            fileBlock([error localizedDescription]);
        }
    }];
    
    
    
}
-(void)RepairCreateEX:(NSString *)userID PropertyID:(NSString *)propertyid Typeid:(NSString *)typeid
          Telnumber:(NSString *)telnumber Body:(NSString *)body Pictures:(NSString *)path
    withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))pBlock
{
    
    NSDictionary *param = @{PROPERTY_ID:propertyid,
                            USER_ID:userID,
                            REPAIR_TYPES_ID:typeid,
                            TEL_NUM:telnumber,
                            BODY:body
                            };
    
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:API_REPAIR_CREATE parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"pictures" fileName:@"images.zip" mimeType:APP_ZIP error:nil];
        } error:nil];

    AFHTTPRequestOperationManager *manager = [self getManagerWithHeader];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSDictionary *dic = (NSDictionary *)responseObject;
                                         NSLog(@"ttt%@",dic);
                                         int t = [[dic objectForKey:@"code"] intValue];
                                         if (t == 200) {
                                             if (successBlock != nil) {
                                                 successBlock(dic);
                                             }
                                         }
                                         else
                                         {
                                             if (fileBlock != nil) {
                                                 fileBlock([dic objectForKey:@"desc"]);
                                             }
                                             
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (fileBlock != nil) {
                                             fileBlock([error localizedDescription]);
                                         }
                                     }];
    

    [operation setUploadProgressBlock:pBlock];
    [operation start];
}

-(void)RepairCreateWithMedia:(NSString *)userID PropertyID:(NSString *)propertyid Typeid:(NSString *)typeid
            Telnumber:(NSString *)telnumber Body:(NSString *)body mediamiage:(NSArray *)images mediavideo:(NSArray *)video
                  mediaaudio:(NSArray *)audio
     withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSDictionary *param = @{PROPERTY_ID:propertyid,
                            USER_ID:userID,
                            REPAIR_TYPES_ID:typeid,
                            TEL_NUM:telnumber,
                            BODY:body,
                            @"model":@"2",
                            @"devicetoken":self.deviceToken,
                            @"mediaimage":images,
                            @"mediavideo":video,
                            @"mediaaudio":audio
                            };
    
    NSLog(@"%@",param);
   [self callAPI:API_REPAIR_CREATE_WITH_MEDIA Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
}


-(void)getNotes:(NSString *)propertyid PageIndex:(NSString *)pageindex
        withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:propertyid,
                            PAGE_INDEX:pageindex
                            };
    
    [self callAPI:API_GET_NOTES Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)getRepairList:(NSString *)propertyid UserID:(NSString *)userID type:(NSString *)type
    withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:propertyid,
                            USER_ID:userID,
                            @"type":type
                            };
    
    [self callAPI:API_GET_REPAIRS_LIST Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)getRepairDetail:(NSString *)propertyid UserID:(NSString *)userID RepairID:(NSString *)repairID
    withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:propertyid,
                            USER_ID:userID,
                            REPAIR_ID:repairID
                            };
    
    [self callAPI:API_GET_REPAIRS_DETAIL Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)getRepairLogLastest:(NSString *)propertyid UserID:(NSString *)userID
      withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:propertyid,
                            USER_ID:userID
                            };
    NSLog(@"%@",param);
    [self callAPI:API_GET_REPAIRS_LOG_LASTEST Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)cancleRepair:(NSString *)propertyid RepairID:(NSString *)repairID UserID:(NSString *)userID
          withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock
{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            REPAIR_ID:repairID,
                            PROPERTY_ID:propertyid,
                            USER_ID:userID
                            };
    
    [self callAPI:API_CANCLE_REPAIRS Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)getStartPages:(NSString *)propertyid LogoID:(NSString *)logoID
    withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:propertyid,
                            LOGO_ID:logoID
                            };
    [self callAPI:API_START Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}
-(void)repairSloved:(NSString *)code PropertyId:(NSString *)propertyid RepairID:(NSString *)repairId UserID:(NSString *)userid
    withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            @"code":code,
                            REPAIR_ID:repairId,
                            PROPERTY_ID:propertyid,
                            USER_ID:userid
                            };
    [self callAPI:API_REPAIR_SOLVED Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}
-(void)propertyBylatitude:(NSString *)latitude Longitude:(NSString *)longitude Pageindex:(NSString *)pageindex
   withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            LATITUDE:latitude,
                            LONGITUDE:longitude,
                            PAGE_INDEX:pageindex,
                            };
    NSLog(@"%@",param);
    [self callAPI:API_PROPERTY_BY_LOCATION Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}
-(void)propertyByDescription:(NSString *)description Pageindex:(NSString *)pageindex
         withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            DESCRIPTION:description,
                            PAGE_INDEX:pageindex,
                            };
    NSLog(@"%@",param);
    [self callAPI:API_PROPERTY_BY_NAME Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}


-(void)fleaGetByProperty:(NSString *)property Pageindex:(NSString *)pageindex
            withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:property,
                            PAGE_INDEX:pageindex,
                            };
    NSLog(@"%@",param);
    [self callAPI:API_FLEA_BY_PROPERTY Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)fleaGetByOwner:(NSString *)property UserID:(NSString *)userid
        withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            PROPERTY_ID:property,
                            USER_ID:userid,
                            };
    NSLog(@"%@",param);
    [self callAPI:API_FLEA_BY_OWNER Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)fleaDeleteWithID:(NSString *)fleaid PropertyID:(NSString *)propertyId UserID:(NSString *)userid
     withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            FLEA_ID:fleaid,
                            PROPERTY_ID:propertyId,
                            USER_ID:userid,
                            };
    NSLog(@"%@",param);
    [self callAPI:API_FLEA_DELETE Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}
-(void)fleaDetailWithID:(NSString *)fleaid PropertyID:(NSString *)propertyId
       withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            FLEA_ID:fleaid,
                            PROPERTY_ID:propertyId,
                            };
    NSLog(@"%@",param);
    [self callAPI:API_FLEA_DETAIL Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)FleaNewEX:(NSString *)userID PropertyID:(NSString *)propertyid Header:(NSString *)header TelNumber:(NSString *)telnumber
            Description:(NSString *)description Pictures:(NSString *)path
     withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))pBlock
{
    
    NSDictionary *param = @{PROPERTY_ID:propertyid,
                            USER_ID:userID,
                            @"header":header,
                            @"telnumber":telnumber,
                            @"description":description
                            };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:API_FLEA_NEW parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"pictures" fileName:@"images.zip" mimeType:APP_ZIP error:nil];
    } error:nil];
    [self UploadFile:request withSuccessBlock:successBlock fileBlock:fileBlock ProgressBlock:pBlock];
    
}

-(void)FleaEditEXWithFleaID:(NSString *)fleaId PropertyID:(NSString *)propertyid UserID:(NSString *)userID Header:(NSString *)header
                TelNumber:(NSString *)telnumber Description:(NSString *)description DeleteList:(NSString *)deletelist Pictures:(NSString *)path
withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock ProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))pBlock
{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            @"fleaid":fleaId,
                            PROPERTY_ID:propertyid,
                            USER_ID:userID,
                            @"header":header,
                            @"telnumber":telnumber,
                            @"description":description,
                            @"deletelist":deletelist
                            };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:API_FLEA_EDIT parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"pictures" fileName:@"images.zip" mimeType:APP_ZIP error:nil];
    } error:nil];
    [self UploadFile:request withSuccessBlock:successBlock fileBlock:fileBlock ProgressBlock:pBlock];
    
}
-(void)userResetPasswordByMobile:(NSString *)telnumber newpassword:(NSString *)newpassword
       withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            @"telnumber":telnumber,
                            @"newpassword":[newpassword md5HexDigest],
                            };
    NSLog(@"%@",param);
    [self callAPI:API_RESETPW_BY_PHONE Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}


-(void)getCode:(NSString *)telnumber newpassword:(NSString *)newpassword
                withSuccessBlock:(SuccessBlock)successBlock fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            @"telnumber":telnumber,
                            @"newpassword":[newpassword md5HexDigest],
                            };
    NSLog(@"%@",param);
    [self callAPI:API_RESETPW_BY_PHONE Param:param withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)orderCreateWithParamModel:(OrderCreateParamModel *)paramModel
                        bShowHUD:(BOOL)bShowHUD
                          inView:(UIView *)view
                            text:(NSString *)text
                withSuccessBlock:(SuccessBlock)successBlock
                       fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = [Utils getObjectData:paramModel];
    NSLog(@"%@",param);
    [self callAPI:API_ORDER_CREATE CallType:POST Param:param bShowHUD:bShowHUD inView:view text:text withSuccessBlock:successBlock fileBlock:fileBlock];
    
}

-(void)getCashCoupon:(NSString *)userid
            bShowHUD:(BOOL)bShowHUD
              inView:(UIView *)view
                text:(NSString *)text
    withSuccessBlock:(SuccessBlock)successBlock
           fileBlock:(FaildBlock)fileBlock

{
    
    NSDictionary *param = @{MYTOKEN:@"",
                            @"userid":userid
                            };
    NSLog(@"%@",param);
    [self callAPI:API_GET_CASHCOUPONS CallType:POST Param:param bShowHUD:bShowHUD inView:view text:text withSuccessBlock:successBlock fileBlock:fileBlock];

}



-(BOOL)setLocalCacheWithObjct:(NSObject *)obj Flage:(NSString *)flage
{
    NSDictionary * tmpDic = [Utils getObjectData:obj];
    return [tmpDic writeToFile:flage atomically:YES];
}

-(BOOL)setLocalCache:(NSDictionary *)dic Flage:(NSString *)flage
{
    return [dic writeToFile:flage atomically:YES];
}

-(NSDictionary *)getLocalCache:(NSString *)flage
{
    return [NSDictionary dictionaryWithContentsOfFile:flage];
}



@end
