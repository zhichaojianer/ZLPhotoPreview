//
//  ZLPhotoPreviewController.h
//  StructureLib
//
//  Created by liuchao on 16/4/29.
//  Copyright © 2016年 LiuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPhotoPreviewController : UIViewController

@property (nonatomic, strong) NSArray  *zlPhotoArray; //保存图片路径或图片的数组
@property (nonatomic, assign) NSInteger currentIndex;

@end
