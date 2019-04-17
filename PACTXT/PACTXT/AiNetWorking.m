	//
//  AiNetWorking.m
//  fanligou
//
//  Created by allen on 2017/10/14.
//  Copyright © 2017年 allen. All rights reserved.
//

#import "AiNetWorking.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AiNetWorking

#pragma makr -- 上传图片到服务器
+(void)ImagePOST:(NSString *)UrlString parameters:(id)parameters ContentTypeName:(NSString *)contentTypeName ImageArray:(NSMutableArray *)imageArray success:(void (^)(id))sucess failure:(void (^)(NSError *))failure {
//    NSLog(@"111");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"3333");
        // 处理耗时操作的代码块...
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"www.baidu",UrlString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString * fid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [request setValue:token forHTTPHeaderField:@"token"];
        [request setValue:fid forHTTPHeaderField:@"userId"];
        request.HTTPMethod = @"POST";
        //设置请求实体
        NSMutableData *body = [NSMutableData data];
        if (parameters != nil) {
            for (NSString *key in parameters) {
                //循环参数按照部分1、2、3那样循环构建每部分数据
                NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",@"BOUNDARY",key];
                [body appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
                
                id value = [parameters objectForKey:key];
                if ([value isKindOfClass:[NSString class]]) {
                    [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
                }else if ([value isKindOfClass:[NSData class]]){
                    [body appendData:value];
                }
                [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        for (int i = 0; i<imageArray.count; i++) {
            ///文件参数
            UIImage * img = imageArray[i];
            NSData *imageData = [NSData data];
            NSString *imageFormat = @"";
            if (UIImagePNGRepresentation(img) != nil) {
                imageFormat = @"Content-Type: image/png \r\n";
                imageData = UIImagePNGRepresentation(img);
                
            }else{
                imageFormat = @"Content-Type: image/jpeg \r\n";
                imageData = UIImageJPEGRepresentation(img, 1.0);
                
            }
            [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
            NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",contentTypeName,@"zyq1111"];
            [body appendData:[self getDataWithString:disposition ]];
            [body appendData:[self getDataWithString:imageFormat]];
            [body appendData:[self getDataWithString:@"\r\n"]];
            [body appendData:imageData];
            [body appendData:[self getDataWithString:@"\r\n"]];
            //普通参数
            [body appendData:[self getDataWithString:@"--BOUNDARY\r\n" ]];
            NSString *dispositions = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",@"key"];
            [body appendData:[self getDataWithString:dispositions ]];
            [body appendData:[self getDataWithString:@"\r\n"]];
            [body appendData:[self getDataWithString:@"zyq1111"]];//filename
            [body appendData:[self getDataWithString:@"\r\n"]];
        }
        
        //参数结束
        [body appendData:[self getDataWithString:@"--BOUNDARY--\r\n"]];
        request.HTTPBody = body;
        //设置请求体长度
        NSInteger length = [body length];
        [request setValue:[NSString stringWithFormat:@"%ld",length] forHTTPHeaderField:@"Content-Length"];
        //设置 POST请求文件上传
        [request setValue:@"multipart/form-data; boundary=BOUNDARY" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (failure) {
                        failure(error);
                    }
                }
                
                NSJSONSerialization *object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSDictionary *dict = (NSDictionary *)object;
                if (dict != nil) {
                    if (sucess) {
                        sucess(dict);
                    }
                }
                NSLog(@"%@",dict);
                NSLog(@"data:%@",data);
                NSLog(@"error:%@",error.description);
                
            });
            
            
        }];
        //开始任务
        [dataTask resume];
    });
   
}

+(NSData *)getDataWithString:(NSString *)string{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
    
}

@end
