//
//  ViewController.m
//  AWActionSheetDemo
//
//  Created by mac on 2019/5/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "AWActionSheet.h"
#import "AWShareView.h"


@interface ViewController ()<AWActionSheetDelegate, AWShareViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)testAction {
    
    NSArray *items = @[
                       @{@"icon": @"share_icon0", @"name": @"微信", @"tag": @"weixin"},
                       @{@"icon": @"share_icon1", @"name": @"朋友圈", @"tag": @"pengyouquan"},
                       @{@"icon": @"share_icon2", @"name": @"系统分享", @"tag": @"xitong"}
                       ];
    
    AWShareView *shareView = [AWShareView shareView];
    [shareView setupCollectionView:items];
    shareView.delegate = self;
    
    
    AWActionSheet *sheet = [AWActionSheet actionSheet];
    sheet.delegate = self;
//    sheet.shouldDismissOnTouchOutside = NO;
//    sheet.showCancelBtn = NO;
    [sheet setContent:shareView height:219];
    [sheet show];
    
    __weak AWShareView *weakShareView = shareView;
    [sheet setWidthChanged:^(CGFloat width) {
        NSLog(@"%f", width);
        [weakShareView updateCollectionLayoutFor:width];
    }];
    
}


#pragma mark- AWShareViewDelegate
- (void)shareView:(AWShareView *)shareView didClickItem:(NSDictionary *)item atIndex:(NSInteger)index
{
    NSLog(@"index:%ld,  item: %@", (long)index, item);
}

#pragma mark- AWActionSheetDelegate
- (void)actionSheetDidAppear:(AWActionSheet *)sheet
{
    NSLog(@"%s", __func__);
}
- (void)actionSheetDidDismiss:(AWActionSheet *)sheet
{
    NSLog(@"%s", __func__);
}



@end
