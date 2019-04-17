//
//  AiNetWorking.h
//  fanligou
//
//  Created by allen on 2017/10/14.
//  Copyright © 2017年 allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AiNetWorking : NSObject


/*
 UrlString api文档的url
 ContentTypeName api 文档对应的ContentTypeName
 imageArray  image数组，注意 都是UIImage类型
 warning： 请不要用模拟器自带的系统图片测试
 parameters : dict 上传需要的参数，没有的话可以为nil
 */
////实现multipart/form-data格式上传文件
+ (void)ImagePOST:(NSString *)UrlString parameters:(id)parameters ContentTypeName:(NSString *)contentTypeName ImageArray:(NSMutableArray *)imageArray  success:(void(^)(id responseObject))sucess failure:(void(^)(NSError *error))failure;
@end
