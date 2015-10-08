//
//  MyNetWorkQuery.h
//  天气预报
//
//  Created by kangkathy on 15/8/28.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"

@interface MyNetWorkQuery : NSObject


+ (void)requestData:(NSString *)urlString HTTPMethod:(NSString *)method  params:(NSMutableDictionary *)params completionHandle:(void(^)(id result))completionblock errorHandle:(void(^)(NSError *error))errorblock;

+(AFHTTPRequestOperation *)AFrequestData:(NSString *)urlString
                              HTTPMethod:(NSString *)method
                                  params:(NSMutableDictionary *)params
                        completionHandle:(void (^)(id))completionblock
                             errorHandle:(void (^)(NSError *))errorblock;
    


@end
