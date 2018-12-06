//
//  UIImage+ZTFixOrientation.h
//  ZTAdvertisementApp
//
//  Created by NingPeiChao on 2018/11/6.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BLFixOrientation)


/**裁剪图片成指定比例 */
-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
//剪裁图片
-(UIImage *)cropImageRect:(CGRect)rect;

//获取图片等比缩放后的大小
- (CGRect)getImageAdaptiveSizeBgView:(UIView *) view;
//重新绘制图片根据宽度 以及图片宽高比例适应
- (UIImage *)redrawImageSizeRedrawWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
