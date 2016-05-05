//
//  GYShareManager.h
//  CustomActionSheet
//
//  Created by zgy on 16/5/4.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^shareSuccess)(NSMutableDictionary *msg);
typedef void(^shareFail)(NSMutableDictionary *msg, NSString *erroInfo);


@interface GYShareManager : NSObject

+ (instancetype)sharedManager;


/**
 *  展示分享的actionsheet，如果shareItems传nil,会默认显示微信、QQ、微博三个平台（没安装自动隐藏），如果传了shareItems，请自己判断是否安装分享平台
 *
 *  @param vc          分享按钮所在的视图控制器
 *  @param shareItems  传入的分享平台数组，内容格式为字典@{@"title": @"xxx", @"img": @"123"}
 *  @param param       待分享的消息
 *  @param success     成功的回调
 *  @param fail        失败的回调
 */
- (void)shareWithViewController:(UIViewController *)vc shareItems:(NSArray *)shareItems shareParam:(NSMutableDictionary *)param success:(shareSuccess)success faile:(shareFail)fail;

@end
