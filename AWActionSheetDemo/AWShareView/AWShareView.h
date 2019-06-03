//
//  AWShareView.h
//  AWActionSheetDemo
//
//  Created by mac on 2019/5/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AWShareView;
@protocol AWShareViewDelegate <NSObject>

@optional
- (void)shareView:(AWShareView *)shareView didClickItem:(NSDictionary *)item atIndex:(NSInteger)index;

@end



@interface AWShareView : UIView


+ (instancetype)shareView;

@property (nonatomic, weak, nullable) id<AWShareViewDelegate> delegate;

/**
 初始化collectionView

 @param items @[@{@"icon": @"foo", @"name": @"bar"}]
 */
- (void)setupCollectionView:(NSArray <NSDictionary *>*)items;

- (void)updateCollectionLayoutFor:(CGFloat)width;


@end

NS_ASSUME_NONNULL_END
