# CustomActionSheet
自定义actionsheet

主要用于自定义分享，可以传入自定义的view或viewController，自己想放什么都可以


### PS.
### 这里有一个自定义分享视图的demo，用了shareSDK V.3.2.1

![demo](http://ww2.sinaimg.cn/mw690/72aba7efgw1f3i9wzbuf4j20hs0rwjt2.jpg)
### 封装了ShareSDK，配置好plist文件和AppDelegate类后，使用起来一句话
<pre>
<code>
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
</code>
</pre>
