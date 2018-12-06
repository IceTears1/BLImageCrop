//
//  BLImageCropView.h
//  Demo
//
//  Created by Ice on 2018/12/5.
//  Copyright © 2018 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BL_ImageCropBlock)(UIImage * resultImage);
@interface BLImageCropView : UIView
@property (nonatomic, copy)BL_ImageCropBlock resultBlock;

@property (nonatomic, assign)CGFloat boxWidth; //剪裁框的大小 --默认  self的宽或者高 - boxMargin  但会优先根据宽高比例适应

@property (nonatomic, assign)CGFloat boxMargin; //剪裁框边距 --默认  10

@property (nonatomic, assign)CGFloat boxWHScale;//剪裁框子宽高比例; --默认 9.0：16.0
@property (nonatomic, strong)UIColor *boxBoderColor;//剪裁框子边框的颜色; --默认 灰色
@property (nonatomic, assign)CGFloat boxBoderWidth;//剪裁框子边框的宽度;  --默认 1.0

@property (nonatomic, strong)UIColor *boxFullAreaColor;//剪裁框子  填充色; --默认 黑色
@property (nonatomic, assign)CGFloat boxFullAreaAlpha;//剪裁框子填充区域透明度; --默认  0.5

@property (nonatomic, strong)UIColor *boxBoderCornerColor;//剪裁框子 四角框子 的颜色; --默认 白色

@property (nonatomic, assign)CGFloat imageMaxScale;//图片最大的 放大倍数  --默认 5.0

//重绘图片大小的 宽高  默认 宽 1080   高度根据图片宽高比例自适应
@property (nonatomic, assign)CGFloat reDrawImageWidth;



/*
 image :原图
 isRedraw:是否重绘图片大小
 */
- (void)initDataOrginImage:(UIImage *)image isRedrawImageSize:(BOOL)isRedraw andBlock:(BL_ImageCropBlock)resultBlock;
- (void)doneCrop;
@end

NS_ASSUME_NONNULL_END
