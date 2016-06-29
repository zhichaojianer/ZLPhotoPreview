//
//  ZLPhotoPreviewCell.m
//  StructureLib
//
//  Created by liuchao on 16/4/29.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import "ZLPhotoPreviewCell.h"
#import "UIView+Layout.h"
#import "YYWebImage.h"

@interface ZLPhotoPreviewCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *zlScrollView;
@property (nonatomic, strong) UIImageView  *zlImageView;
@property (nonatomic, strong) UIView       *zlImageContainerView;

@property (nonatomic, strong) UIActivityIndicatorView *zlActivityView;

@end

@implementation ZLPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.zlScrollView = [[UIScrollView alloc] init];
        [self.zlScrollView setFrame:CGRectMake(0, 0, self.tz_width, self.tz_height)];
        [self.zlScrollView setBouncesZoom:YES];
        [self.zlScrollView setMaximumZoomScale:2.5];
        [self.zlScrollView setMinimumZoomScale:1.0];
        [self.zlScrollView setMultipleTouchEnabled:YES];
        [self.zlScrollView setDelegate:self];
        [self.zlScrollView setScrollsToTop:NO];
        [self.zlScrollView setShowsHorizontalScrollIndicator:NO];
        [self.zlScrollView setShowsVerticalScrollIndicator:NO];
        [self.zlScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.zlScrollView setDelaysContentTouches:NO];
        [self.zlScrollView setCanCancelContentTouches:YES];
        [self.zlScrollView setAlwaysBounceVertical:NO];
        [self addSubview:self.zlScrollView];
        
        self.zlImageContainerView = [[UIView alloc] init];
        [self.zlImageContainerView setClipsToBounds:YES];
        [self.zlScrollView addSubview:self.zlImageContainerView];
        
        self.zlImageView = [[UIImageView alloc] init];
        [self.zlImageView setBackgroundColor:[UIColor lightGrayColor]];
        [self.zlImageView setClipsToBounds:YES];
        [self.zlImageContainerView addSubview:self.zlImageView];
        
        self.zlActivityView = [[UIActivityIndicatorView alloc] init];
        [self.zlActivityView setFrame:CGRectMake(0, 0, 45, 45)];
        [self.zlActivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.zlActivityView setCenter:self.center];
        [self addSubview:self.zlActivityView];
        
        UITapGestureRecognizer *zlSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zlSingleTapAction:)];
        [self addGestureRecognizer:zlSingleTap];
        
        UITapGestureRecognizer *zlDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zlDoubleTapAction:)];
        [zlDoubleTap setNumberOfTapsRequired:2];
        [zlSingleTap requireGestureRecognizerToFail:zlDoubleTap];
        [self addGestureRecognizer:zlDoubleTap];
    }
    return self;
}

- (void)configImageViewWithPath:(NSString *)zlImageViewPath {
    
    [self.zlActivityView startAnimating];
    [self.zlScrollView setZoomScale:1.0 animated:NO];
    
    __weak __typeof(&*self)weakSelf_SC = self;
    [self.zlImageView yy_setImageWithURL:[NSURL URLWithString:zlImageViewPath] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [weakSelf_SC resizeSubviews];
        [weakSelf_SC.zlActivityView removeFromSuperview];
    }];
}

- (void)configImageViewWithImage:(UIImage *) image {

    [self.zlActivityView startAnimating];
    [self.zlScrollView setZoomScale:1.0 animated:NO];
    
    [self.zlImageView setImage:image];
    
    [self resizeSubviews];
    [self.zlActivityView removeFromSuperview];
}

- (void)resizeSubviews {
    self.zlImageContainerView.tz_origin = CGPointZero;
    self.zlImageContainerView.tz_width = self.tz_width;
    
    UIImage *image = self.zlImageView.image;
    if (image.size.height / image.size.width > self.tz_height / self.tz_width) {
        self.zlImageContainerView.tz_height = floor(image.size.height / (image.size.width / self.tz_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.tz_width;
        if (height < 1 || isnan(height)) height = self.tz_height;
        height = floor(height);
        self.zlImageContainerView.tz_height = height;
        self.zlImageContainerView.tz_centerY = self.tz_height / 2;
    }
    if (self.zlImageContainerView.tz_height > self.tz_height && self.zlImageContainerView.tz_height - self.tz_height <= 1) {
        self.zlImageContainerView.tz_height = self.tz_height;
    }
    self.zlScrollView.contentSize = CGSizeMake(self.tz_width, MAX(self.zlImageContainerView.tz_height, self.tz_height));
    [self.zlScrollView scrollRectToVisible:self.bounds animated:NO];
    self.zlScrollView.alwaysBounceVertical = self.zlImageContainerView.tz_height <= self.tz_height ? NO : YES;
    self.zlImageView.frame = self.zlImageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)zlSingleTapAction:(UITapGestureRecognizer *)tap {
    if (self.zlSingleTapGestureBlock) {
        self.zlSingleTapGestureBlock();
    }
}

- (void)zlDoubleTapAction:(UITapGestureRecognizer *)tap {
    if (self.zlScrollView.zoomScale > 1.0) {
        [self.zlScrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.zlImageView];
        CGFloat newZoomScale = self.zlScrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [self.zlScrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zlImageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.tz_width > scrollView.contentSize.width) ? (scrollView.tz_width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.tz_height > scrollView.contentSize.height) ? (scrollView.tz_height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.zlImageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
