//
//  MyNetWorkQuery.m
//  天气预报
//
//  Created by kangkathy on 15/8/28.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MyNetWorkQuery.h"


@implementation MyNetWorkQuery

+ (void)requestData:(NSString *)urlString HTTPMethod:(NSString *)method params:(NSMutableDictionary *)params completionHandle:(void (^)(id))completionblock errorHandle:(void (^)(NSError *))errorblock{
    //0.去得本地保存的token
//    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
//    NSString *token = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
//    [params setObject:@"access_token" forKey:token];
//     
    //1.拼接URL
    NSString *requestString = [BaseURL stringByAppendingString:urlString];
    NSURL *url = [NSURL URLWithString:requestString];
    
    
    //2.创建网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    request.HTTPMethod = method;
    
    
    //3.处理请求参数
    //key1=value1&key2=value2
    NSMutableString *paramString = [NSMutableString string];
    
    NSArray *allKeys = params.allKeys;
    
    for (NSInteger i = 0; i < params.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = params[key];
        
        [paramString appendFormat:@"%@=%@",key,value];
        
        if (i < params.count - 1) {
            [paramString appendString:@"&"];
        }
        
    }
    
    //4.GET和POST分别处理
    if ([method isEqualToString:@"GET"]) {
        
        //http://www.baidu.com?key1=value1&key2=value2
        //http://www.baidu.com?key0=value0&key1=value1&key2=value2
        
        NSString *seperate = url.query ? @"&" : @"?";
        NSString *paramsURLString = [NSString stringWithFormat:@"%@%@%@",requestString,seperate,paramString];
        
        //根据拼接好的URL进行修改
        request.URL = [NSURL URLWithString:paramsURLString];
        
        
    }
    else if([method isEqualToString:@"POST"]) {
        //学生完成
        request.URL = [NSURL URLWithString:requestString];
        request.HTTPBody = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    
    //5.发送异步网络请求
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            //出现错误时回调block
            errorblock(connectionError);
            
            return;
        }
        
        if (data) {
            
            //解析JSON
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //把JSON解析后的数据返回给调用者,回调block
            completionblock(jsonDic);
        }
    }];
}

//params:普通参数 datas：和文件上传相关的参数 
+(AFHTTPRequestOperation *)AFrequestData:(NSString *)urlString
                              HTTPMethod:(NSString *)method
                                  params:(NSMutableDictionary *)params
                        completionHandle:(void (^)(id))completionblock
                             errorHandle:(void (^)(NSError *))errorblock {
    
    //设置公共参数
    [params setObject:kAccessToken forKey:@"accessToken"];
    [params setObject:@"get" forKey:@"method"];
    //拼接URL
    urlString = [BaseURL stringByAppendingString:urlString];
    //创建管理对象,接受数据类型
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"application/x-www-form-urlencoded",nil];
    
     if ([method isEqualToString:@"GET"]) {
         AFHTTPRequestOperation *operation = [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
             completionblock(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             errorblock(error);
         }];
         return  operation;
         
     }else if([method isEqualToString:@"POST"]){
        
         AFHTTPRequestOperation *operation = [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"POST成功");
             completionblock(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"暂无搜索结果");
             errorblock(error);
         }];
         return  operation;
         
     }
    return nil;
}






@end
