# CustomActionSheet
自定义actionsheet

主要用于自定义分享，可以传入自定义的view或viewController，自己想放什么都可以


###PS.
###这里有一个自定义分享视图的demo，用了shareSDK V.3.2.1

![demo](http://ww2.sinaimg.cn/mw690/72aba7efgw1f3i9wzbuf4j20hs0rwjt2.jpg)
###封装了ShareSDK，配置好plist文件和AppDelegate类后，使用起来一句话
<pre>
<code>
- (IBAction)handleButtonAction {
    
    OSMessage *msg = [[OSMessage alloc]init];
    msg.title = @"测试分享";
    msg.desc = @"分享的描述信息";
    msg.image = [UIImage imageNamed:@"share_0"];
    msg.link = @"https://www.baidu.com";
    msg.thumbnail = [UIImage imageNamed:@"share_6"];
    msg.multimediaType = OSMultimediaTypeNews;
   
    
    [[GYShareManager sharedManager] shareWithShareItems:nil shareParam:msg success:^(OSMessage *message) {
        NSLog(@"分享成功");
    } faile:^(OSMessage *message, NSError *error) {
        NSLog(@"分享失败");
    }];
}
</code>
</pre>
