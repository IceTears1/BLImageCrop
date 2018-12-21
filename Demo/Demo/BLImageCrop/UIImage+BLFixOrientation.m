//
//  UIImage+ZTFixOrientation.m
//  ZTAdvertisementApp
//
//  Created by NingPeiChao on 2018/11/6.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "UIImage+BLFixOrientation.h"

@implementation UIImage (BLFixOrientation)



-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 以图片中心为中心，以最小边为边长，裁剪正方形图片
-(UIImage *)cropImageRect:(CGRect)rect{
    
    CGImageRef sourceImageRef = [self CGImage] ;//将UIImage转换成CGImageRef
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);//按照给定的矩形区域进行剪裁
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}


//获取图片等比缩放后的大小
- (CGRect)getImageAdaptiveSizeBgView:(UIView *) view{
    //这里计算的是  图片在imageview 上边等比例缩放时候 的坐标
    CGSize imageSize = self.size;
    // 在图像视图中计算矩形的实际位置和大小
    CGSize viewSize = view.frame.size;
    //计算宽高比例
    CGFloat scale = MIN(viewSize.width / imageSize.width, viewSize.height / imageSize.height);
    
    CGFloat offsetX = (viewSize.width - imageSize.width * scale) / 2;
    CGFloat offsetY = (viewSize.height - imageSize.height * scale) / 2;
    //获取缩放后的 w h坐标
    return CGRectMake(offsetX, offsetY, imageSize.width * scale, imageSize.height * scale);
}

//重新绘制图片根据宽度 以及图片宽高比例适应
- (UIImage *)redrawImageSizeRedrawWidth:(CGFloat)width{
    CGFloat h = self.size.height * width / self.size.width;
    CGSize size = CGSizeMake(width, h);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
