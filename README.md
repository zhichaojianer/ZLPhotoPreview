# ZLPhotoPreview
首先感谢谭真TZImagePickerController的分享，基于此分享学到的思想是利用UICollectionView以及UICollectionViewCell来
实现图片的预览功能。
使用举例：

NSMutableArray *zlPhotoArray = [NSMutableArray arrayWithCapacity:0];
[zlPhotoArray addObject:@"http://7qnd84.com2.z0.glb.qiniucdn.com/no_card.png"];
[zlPhotoArray addObject:@"http://cicadafile.qiniudn.com/1446698730338WR2fvSeBXK.jpg"];

// 图片预览
ZLPhotoPreviewController *zlPhotoPreviewController = [[ZLPhotoPreviewController alloc] init];
zlPhotoPreviewController.zlPhotoArray = zlPhotoArray;
zlPhotoPreviewController.currentIndex = 0;
[self presentViewController:zlPhotoPreviewController animated:YES completion:nil];
//[self.navigationController pushViewController:zlPhotoPreviewController animated:YES];

