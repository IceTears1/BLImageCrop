//
//  BLImageCropToolClass.h
//  Demo
//
//  Created by Ice on 2018/12/5.
//  Copyright © 2018 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BLImageCropToolClass : NSObject
//获取图片等比缩放后的大小
+ (CGRect)getImageAdaptiveSize:(UIImage *)image andView:(UIView *) view;
//保存照片到 相册
+ (void)saveCameraToPhotoAlbum:(UIImage *)image successBlock:(void(^)(BOOL success)) successBlock;
//重新绘制图片大小 （ 可以将小图绘制成大图  避免拉伸模糊）
+ (UIImage *)redrawImageSize:(UIImage *)originalImage withScaleSize:(CGSize)size;

//重新绘制图片根据宽度 以及图片宽高比例适应
+ (UIImage *)redrawImageSize:(UIImage *)originalImage redrawWidth:(CGFloat)width;
//保存图片到沙河
+ (void)saveImage:(UIImage *)image successBlock:(void (^)(BOOL success))successBlock;

@end

NS_ASSUME_NONNULL_END
