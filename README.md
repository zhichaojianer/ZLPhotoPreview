# ZLPhotoPreview
首先感谢谭真TZImagePickerController的分享，基于此分享学到的思想是利用UICollectionView以及UICollectionViewCell来
实现图片的预览功能。
使用举例：
ZLPhotoPreviewController *zlPhotoPreviewController = [[ZLPhotoPreviewController alloc] init];
zlPhotoPreviewController.zlPhotoArray = @[@"http://cicadafile.qiniudn.com/1447321125406dE6DoBiEp0.jpg",
                                          @"http://cicadafile.qiniudn.com/1447321125406dE6DoBiEp0.jpg",
                                          @"http://cicadafile.qiniudn.com/1447321125406dE6DoBiEp0.jpg"];
zlPhotoPreviewController.currentIndex = 1;
[self.navigationController pushViewController:zlPhotoPreviewController animated:YES];

备注：zlPhotoArray保存的是图片路径
