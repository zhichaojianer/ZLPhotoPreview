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
    [self.ui_customNavBarView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.3]];
    [self.ui_customNavBarView setAlpha:1.0];
    
    self.ui_backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
    [self.ui_backButton setImage:[UIImage imageNamedFromAssets:@"zl_nav_back_image"] forState:UIControlStateNormal];
    [self.ui_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ui_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.ui_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, self.view.tz_width-80*2, 24)];
    [self.ui_titleLabel setText:[NSString stringWithFormat:@"%ld/%lu", (long)_currentIndex+1, (unsigned long)self.zlPhotoArray.count]];
    [self.ui_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.ui_titleLabel setTextColor:[UIColor whiteColor]];
    [self.ui_titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
    
    [self.ui_customNavBarView addSubview:self.ui_backButton];
    [self.ui_customNavBarView addSubview:self.ui_titleLabel];
    
    [self.view addSubview:self.ui_customNavBarView];
}


- (void)configCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize                    = CGSizeMake(self.view.tz_width, self.view.tz_height);
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([self.zlPhotoArray[indexPath.row] isKindOfClass:[UIImage class]]) {
        [cell configImageViewWithImage:self.zlPhotoArray[indexPath.row]];
    }else {
        [cell configImageViewWithPath:self.zlPhotoArray[indexPath.row]];
    }
    
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

@implementation UIImage (Assets)

+ (UIImage *)imageNamedFromAssets:(NSString *)name {
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ZLPhotoPreview.bundle"];
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
