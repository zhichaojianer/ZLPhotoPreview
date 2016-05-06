//
//  ZLPhotoPreviewCell.h
//  StructureLib
//
//  Created by liuchao on 16/4/29.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZLSingleTapGestureBlock)();

@interface ZLPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, copy) ZLSingleTapGestureBlock zlSingleTapGestureBlock;

- (void)configImageViewWithPath:(NSString *)zlImageViewPath;

@end
