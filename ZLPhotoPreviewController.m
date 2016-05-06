//
//  ZLPhotoPreviewController.m
//  StructureLib
//
//  Created by liuchao on 16/4/29.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import "ZLPhotoPreviewController.h"
#import "ZLPhotoPreviewCell.h"
#import "UIView+Layout.h"

@interface ZLPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *ui_collectionView;

@property (nonatomic, strong) UIView           *ui_customNavBarView;
@property (nonatomic, strong) UILabel          *ui_titleLabel;
@property (nonatomic, strong) UIButton         *ui_backButton;

@property (nonatomic, strong) UIView           *ui_customToolBarView;
@property (nonatomic, strong) UIButton         *ui_collectionButton;
@property (nonatomic, strong) UIButton         *ui_savedLocalButton;

@property (nonatomic) BOOL isHideNavBarView;

@end

@implementation ZLPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configCollectionView];
    [self configCustomNavBarView];
    [self configCustomToolBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (self.currentIndex){
        [self.ui_collectionView setContentOffset:CGPointMake((self.view.tz_width) * self.currentIndex, 0) animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark -
#pragma mark config custom bar

- (void)configCustomNavBarView {
    
    self.ui_customNavBarView = [[UIView alloc] init];
    [self.ui_customNavBarView setFrame:CGRectMake(0, 0, self.view.tz_width, 64)];
    [self.ui_customNavBarView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
    [self.ui_customNavBarView setAlpha:0.5];
    
    self.ui_backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [self.ui_backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [self.ui_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ui_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.ui_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, self.view.tz_width-80*2, 24)];
    [self.ui_titleLabel setCenter:self.ui_customNavBarView.center];
    [self.ui_titleLabel setText:[NSString stringWithFormat:@"%ld/%lu", (long)_currentIndex+1, (unsigned long)self.zlPhotoArray.count]];
    [self.ui_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.ui_titleLabel setTextColor:[UIColor whiteColor]];
    [self.ui_titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
    
    [self.ui_customNavBarView addSubview:self.ui_backButton];
    [self.ui_customNavBarView addSubview:self.ui_titleLabel];
    
    [self.view addSubview:self.ui_customNavBarView];
}

- (void)configCustomToolBarView {
    
    self.ui_customToolBarView = [[UIView alloc] init];
    [self.ui_customToolBarView setFrame:CGRectMake(0, self.view.tz_height - 44, self.view.tz_width, 44)];
    [self.ui_customToolBarView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
    [self.ui_customToolBarView setAlpha:0.5];
    
    self.ui_collectionButton = [[UIButton alloc] init];
    [self.ui_collectionButton setFrame:CGRectMake(0, 0, self.view.tz_width/2, 44)];
    [self.ui_collectionButton setTitle:NSLocalizedString(@"宝贝点滴", nil) forState:UIControlStateNormal];
    [self.ui_collectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ui_collectionButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.ui_customToolBarView addSubview:self.ui_collectionButton];
    
    self.ui_savedLocalButton = [[UIButton alloc] init];
    [self.ui_savedLocalButton setFrame:CGRectMake(self.view.tz_width/2, 0, self.view.tz_width/2, 44)];
    [self.ui_savedLocalButton setTitle:NSLocalizedString(@"保存到本地", nil) forState:UIControlStateNormal];
    [self.ui_savedLocalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ui_savedLocalButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.ui_customToolBarView addSubview:self.ui_savedLocalButton];
    
    [self.view addSubview:self.ui_customToolBarView];
}

- (void)configCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize                    = CGSizeMake(self.view.tz_width, self.view.tz_height-20);
    layout.minimumInteritemSpacing     = 0;
    layout.minimumLineSpacing          = 0;
    
    CGRect frame = CGRectMake(0, 0, self.view.tz_width , self.view.tz_height);
    CGSize size = CGSizeMake(self.view.tz_width * self.zlPhotoArray.count, self.view.tz_height);
    
    self.ui_collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self.ui_collectionView setBackgroundColor:[UIColor blackColor]];
    [self.ui_collectionView setDataSource:self];
    [self.ui_collectionView setDelegate:self];
    [self.ui_collectionView setPagingEnabled:YES];
    [self.ui_collectionView setScrollsToTop:NO];
    [self.ui_collectionView setShowsHorizontalScrollIndicator:NO];
    [self.ui_collectionView setContentOffset:CGPointMake(0, 0)];
    [self.ui_collectionView setContentSize:size];
    [self.view addSubview:self.ui_collectionView];
    
    [self.ui_collectionView registerClass:[ZLPhotoPreviewCell class] forCellWithReuseIdentifier:@"ZLPhotoPreviewCell"];
}

#pragma mark - Click Event

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    self.currentIndex = (offSet.x + (self.view.tz_width * 0.5)) / self.view.tz_width;
    [self.ui_titleLabel setText:[NSString stringWithFormat:@"%ld/%lu", (long)self.currentIndex+1, (unsigned long)self.zlPhotoArray.count]];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.zlPhotoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZLPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLPhotoPreviewCell" forIndexPath:indexPath];
    [cell configImageViewWithPath:self.zlPhotoArray[indexPath.row]];
    
    __block BOOL _weakIsHideNavBarView = self.isHideNavBarView;
    __weak typeof(self.ui_customNavBarView) weakNavBarView = self.ui_customNavBarView;
    __weak typeof(self.ui_customToolBarView) weakToolBarView = self.ui_customToolBarView;
    
    if (!cell.zlSingleTapGestureBlock) {
        cell.zlSingleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            _weakIsHideNavBarView = !_weakIsHideNavBarView;
            weakNavBarView.hidden = _weakIsHideNavBarView;
            weakToolBarView.hidden = _weakIsHideNavBarView;
        };
    }
    
    return cell;
}

@end
