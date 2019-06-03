//
//  AWShareView.m
//  AWActionSheetDemo
//
//  Created by mac on 2019/5/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AWShareView.h"
#import "AWShareCell.h"

@interface AWShareView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL _didSetupCollectionView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *items;

@end


@implementation AWShareView

+ (instancetype)shareView
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [arr lastObject];
}

- (void)setupCollectionView:(NSArray <NSDictionary *>*)items
{
    if (!_didSetupCollectionView) {
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
                
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(92, 118);
        layout.minimumLineSpacing = 10;
        _collectionView.collectionViewLayout = layout;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"AWShareCell" bundle:nil] forCellWithReuseIdentifier:@"AWShareCell"];
        
        
        _didSetupCollectionView = YES;
    }
    self.items = items;
    
}
- (void)updateCollectionLayoutFor:(CGFloat)width
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = (width - 10*2 - 92*3)/2.0;
}

//- (void)dealloc {
//    NSLog(@"%s", __func__);
//}

#pragma mark- <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AWShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AWShareCell" forIndexPath:indexPath];
    
    NSDictionary *dic = _items[indexPath.item];
    cell.iconImgView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.nameLab.text = dic[@"name"];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item < _items.count) {
        NSDictionary *item = _items[indexPath.item];
        if ([self.delegate respondsToSelector:@selector(shareView:didClickItem:atIndex:)]) {
            [self.delegate shareView:self didClickItem:item atIndex:indexPath.item];
        }
    }
    
}


@end
