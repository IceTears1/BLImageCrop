//
//  BLImageCropToolClass.m
//  Demo
//
//  Created by Ice on 2018/12/5.
//  Copyright © 2018 Ice. All rights reserved.
//

#import "BLImageCropToolClass.h"
#import <Photos/Photos.h>

@implementation BLImageCropToolClass

+ (CGRect)getImageAdaptiveSize:(UIImage *)image andView:(UIView *) view{
//这里计算的是  图片在imageview 上边等比例缩放时候 的坐标
    CGSize imageSize = image.size;
     // 在图像视图中计算矩形的实际位置和大小
    CGSize viewSize = view.frame.size;
    //计算宽高比例
    CGFloat scale = MIN(viewSize.width / imageSize.width, viewSize.height / imageSize.height);
    
    CGFloat offsetX = (viewSize.width - imageSize.width * scale) / 2;
    CGFloat offsetY = (viewSize.height - imageSize.height * scale) / 2;
    //获取缩放后的 w h坐标
    return CGRectMake(offsetX, offsetY, imageSize.width * scale, imageSize.height * scale);
}
+ (void)saveCameraToPhotoAlbum:(UIImage *)image successBlock:(void (^)(BOOL))successBlock{
    
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",@"保存失败");
            successBlock(NO);
        } else {
            NSLog(@"%@",@"保存成功");
            successBlock(YES);
        }
    }];
}

+ (UIImage *)redrawImageSize:(UIImage *)originalImage withScaleSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(UIImage *)redrawImageSize:(UIImage *)originalImage redrawWidth:(CGFloat)width{
    CGFloat h = originalImage.size.height * width / originalImage.size.width;
    CGSize size = CGSizeMake(width, h);
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (void)saveImage:(UIImage *)image successBlock:(void (^)(BOOL success)) successBlock {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    int x = arc4random() % 100;
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"demo%d.png",x]];  // 保存文件的名称
    NSLog(@"%@",filePath);
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
        successBlock(YES);
    }else{
        NSLog(@"%@",@"保存失败");
        successBlock(NO);
    }
    
}
@end
