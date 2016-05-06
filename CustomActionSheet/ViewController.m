//
//  ViewController.m
//  CustomActionSheet
//
//  Created by zgy on 16/5/3.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "ViewController.h"
#import "GYShareManager.h"
#import <ShareSDK/ShareSDK.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
}
- (IBAction)handleButtonAction {
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray* imageArray = @[[UIImage imageNamed:@"share_0"]];
    
    
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://www.mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    
    
    __block NSString *shareResult = @"";
    
    
    
    NSMutableArray *arr = @[
                            @{@"title": @"朋友圈", @"img": @"share_1"},
                            @{@"title": @"微信好友", @"img": @"share_2"},
                            @{@"title": @"QQ", @"img": @"share_3"},
                            @{@"title": @"空间", @"img": @"share_4"},
                            @{@"title": @"新浪微博", @"img": @"share_5"},
                            @{@"title": @"手机通讯录", @"img": @"share_6"}
                            ].mutableCopy;
    [[GYShareManager sharedManager] shareWithViewController:self shareItems:arr shareParam:shareParams success:^(NSDictionary *msg) {
        
        shareResult = @"分享成功";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:shareResult
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    } faile:^(NSDictionary *msg, NSString *erroInfo) {
        
        shareResult = erroInfo;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:shareResult
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

    
}






@end
