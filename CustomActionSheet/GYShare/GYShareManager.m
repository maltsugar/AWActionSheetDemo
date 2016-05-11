//
//  GYShareManager.m
//  CustomActionSheet
//
//  Created by zgy on 16/5/4.
//  Copyright © 2016年 zgy. All rights reserved.
//

#import "GYShareManager.h"
#import "CustomActionSheet.h"
#import "CustomShareView.h"

#import <ShareSDK/ShareSDK.h>
#import<MessageUI/MessageUI.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"



@interface GYShareManager ()<CustomShareViewDelegate, MFMessageComposeViewControllerDelegate, CustomActionSheetDelegate>
{
    CustomActionSheet *_sheet;
}
@property (nonatomic, strong) UIViewController *superVC;
@property (nonatomic, strong) NSMutableArray *shareItems;
@property (nonatomic, strong) NSMutableDictionary *msgParam;
@property (nonatomic,   copy) shareSuccess success;
@property (nonatomic,   copy) shareFail fail;


// 新浪分享需要把url 拼接到文本
@property (nonatomic,   copy) NSString *shareText;
@property (nonatomic,   copy) NSString *shareURL;


@end

@implementation GYShareManager

// 单例
+ (instancetype)sharedManager
{
    static GYShareManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GYShareManager alloc]init];
    });
    return  _sharedManager;
}

- (void)shareWithViewController:(UIViewController *)vc shareItems:(NSArray *)shareItems shareParam:(NSMutableDictionary *)param success:(shareSuccess)success faile:(shareFail)fail
{
    if (nil == shareItems) {
        shareItems = [self getShareItems];
    }
    self.shareItems = shareItems.mutableCopy;
    
    self.superVC = vc;
    self.msgParam = param;
    self.shareText = param[@"text"];
    self.shareURL = param[@"url"];
    
    
    self.success = success;
    self.fail = fail;
    
    CGFloat height = shareItems.count>3 ? 220 : (220-90);
    
    
    CustomActionSheet *sheet = [CustomActionSheet actionSheet];
    _sheet = sheet;
    sheet.delegate = self;
    CustomShareView *share = [CustomShareView viewWithShareItems:shareItems];
    share.frame = CGRectMake(0, 0, SCREEN_W - 2*(kLeftAndRightSpace + kContainerRoundSpace), height);
    share.delegate = self;
    sheet.content = share;
    
    [sheet show];
    
}


// 此方法默认获取微信、QQ、微博三个平台，可以自己修改平台，也可以自己修改图片和名称
- (NSMutableArray *)getShareItems
{
    NSMutableArray *temp = @[].mutableCopy;
    
    NSArray *wechat = @[
                        @{@"title": @"朋友圈", @"img": @"share_1"},
                        @{@"title": @"微信好友", @"img": @"share_2"}
                        ];
    NSArray *qq = @[
                    @{@"title": @"QQ", @"img": @"share_3"},
                    @{@"title": @"空间", @"img": @"share_4"}
                    ];
    
    NSArray *weibo = @[
                       @{@"title": @"新浪微博", @"img": @"share_5"}
                       ];
    
    if ([WXApi isWXAppInstalled]) {
        [temp addObjectsFromArray:wechat];
    }
    
    if ([TencentOAuth iphoneQQInstalled]) {
        [temp addObjectsFromArray:qq];
    }
    
    
    // 始终显示微博和手机通讯录
    [temp addObjectsFromArray:weibo];
    [temp addObject:@{@"title": @"手机通讯录", @"img": @"share_6"}];
    
    return temp;
}
#pragma mark- CustomActionSheetDelegate
- (void)actionSheetDidShow:(CustomActionSheet *)sheet
{
    
}

- (void)actionSheetDidDismiss:(CustomActionSheet *)sheet
{
    
}


#pragma mark- CustomShareViewDelegate
- (void)didClickItemAtIndex:(NSInteger)idx inShareView:(CustomShareView *)sView
{
    // 默认分享文本就是 文本
    [self.msgParam setObject:self.shareText forKey:@"text"];
    
    NSString *title = _shareItems[idx][@"title"];
    if ([title isEqualToString:@"朋友圈"]) {
        
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline];
        
    }else if ([title isEqualToString:@"微信好友"]) {
        
        [self shareWithType:SSDKPlatformSubTypeWechatSession];
        
    }else if ([title isEqualToString:@"QQ"]) {
        
        [self shareWithType:SSDKPlatformSubTypeQQFriend];
        
    }else if ([title isEqualToString:@"空间"]) {
        
        [self shareWithType:SSDKPlatformSubTypeQZone];
        
    }else if ([title isEqualToString:@"新浪微博"]) {
        
        // 新浪分享文本是 文本和url 拼接
        NSString *text = [NSString stringWithFormat:@"%@\n%@", self.shareText, self.shareURL];
        
        [self.msgParam setObject:text forKey:@"text"];
        
        
        [self shareWithType:SSDKPlatformTypeSinaWeibo];
        
    }else if ([title isEqualToString:@"手机通讯录"]) {
        NSString *title = self.msgParam[@"title"]?:@"";
        NSString *url = self.msgParam[@"url"]?:@"";
        
        NSString *message = [NSString stringWithFormat:@"%@,\n 点击查看: %@", title, url];
        [self showMessageView:nil title:@"分享" body:message];
    }
    
    [_sheet dismiss];
    
}

- (void)shareWithType:(SSDKPlatformType)type
{
    //进行分享
    [ShareSDK share:type
         parameters:self.msgParam
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         self.superVC = nil;
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 if (self.success) {
                     self.success(self.msgParam);
                 }
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 
                 NSLog(@"%@", error);
                 if (self.fail) {
                     self.fail(self.msgParam, @"分享失败");
                 }
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 if (self.fail) {
                     self.fail(self.msgParam, @"分享取消");
                 }
                 
                 break;
             }
             default:
                 break;
         }
     }];
}



#pragma mark- 发送短信
-(void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
    switch(result){
        case MessageComposeResultSent:
            //信息传送成功
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
    
    //    [self.superVC.navigationController popToRootViewControllerAnimated:YES];
    
    self.superVC = nil;
}

-(void)showMessageView:(NSArray*)phones title:(NSString*)title body:(NSString*)body
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController*controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = phones;
        //        controller.navigationBar.barTintColor = kNavBGColor;
        //        controller.navigationBar.tintColor = [UIColor whiteColor];
        
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self.superVC presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers]lastObject]navigationItem]setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该设备不支持短信功能" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        
    }
}


#pragma mark- 显示shareSDK默认的actionsheet样式
/**
 *  显示actionsheet分享菜单
 *
 *  @param view 容器视图
 */


/*
 #import <ShareSDK/ShareSDK.h>
 #import <ShareSDKExtension/SSEShareHelper.h>
 #import <ShareSDKUI/ShareSDK+SSUI.h>
 #import <ShareSDKUI/SSUIShareActionSheetStyle.h>
 #import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
 #import <ShareSDK/ShareSDK+Base.h>
 
 #import <ShareSDKExtension/ShareSDK+Extension.h>
 */


/*
 - (void)showShareActionSheet:(UIView *)view
 {
 // 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
 
 __weak ViewController *theController = self;
 
 //1、创建分享参数（必要）
 NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
 
 NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
 [shareParams SSDKSetupShareParamsByText:@"分享内容"
 images:imageArray
 url:[NSURL URLWithString:@"http://www.mob.com"]
 title:@"分享标题"
 type:SSDKContentTypeAuto];
 
 //1.2、自定义分享平台（非必要）
 NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
 //添加一个自定义的平台（非必要）
 SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
 label:@"自定义"
 onClick:^{
 
 //自定义item被点击的处理逻辑
 NSLog(@"=== 自定义item被点击 ===");
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
 message:nil
 delegate:nil
 cancelButtonTitle:@"确定"
 otherButtonTitles:nil];
 [alertView show];
 }];
 [activePlatforms addObject:item];
 
 //设置分享菜单栏样式（非必要）
 //        [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
 //        [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
 //        [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
 //        [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
 //        [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
 //        [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
 //        [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
 //        [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
 
 //2、分享
 [ShareSDK showShareActionSheet:view
 items:nil
 shareParams:shareParams
 onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
 
 switch (state) {
 
 case SSDKResponseStateBegin:
 {
 [theController showLoadingView:YES];
 break;
 }
 case SSDKResponseStateSuccess:
 {
 //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
 if (platformType == SSDKPlatformTypeFacebookMessenger)
 {
 break;
 }
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
 message:nil
 delegate:nil
 cancelButtonTitle:@"确定"
 otherButtonTitles:nil];
 [alertView show];
 break;
 }
 case SSDKResponseStateFail:
 {
 if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
 message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil, nil];
 [alert show];
 break;
 }
 else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
 message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil, nil];
 [alert show];
 break;
 }
 else
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
 message:[NSString stringWithFormat:@"%@",error]
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil, nil];
 [alert show];
 break;
 }
 break;
 }
 case SSDKResponseStateCancel:
 {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
 message:nil
 delegate:nil
 cancelButtonTitle:@"确定"
 otherButtonTitles:nil];
 [alertView show];
 break;
 }
 default:
 break;
 }
 
 if (state != SSDKResponseStateBegin)
 {
 [theController showLoadingView:NO];
 [theController.tableView reloadData];
 }
 
 }];
 
 //另附：设置跳过分享编辑页面，直接分享的平台。
 //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
 //                                                                         items:nil
 //                                                                   shareParams:shareParams
 //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
 //                                                           }];
 //
 //        //删除和添加平台示例
 //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
 //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
 
 }
 
 */


@end
