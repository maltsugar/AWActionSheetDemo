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
    [[GYShareManager sharedManager] shareWithViewController:self shareItems:nil shareParam:shareParams success:^(NSDictionary *msg) {
        
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
