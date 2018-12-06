//
//  BLCropCoverView.h
//  Demo
//
//  Created by Ice on 2018/12/5.
//  Copyright © 2018 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLCropCoverView : UIView
@property (nonatomic, assign) CGRect  box_Frame;
@property (nonatomic, assign) CGPoint  box_Center;
// scale ; //宽高比例
// box_w; //边框相对于屏幕的宽度
- (void)initBoxView:(CGFloat)box_w wAndHScale:(CGFloat) scale boxBoderColor:(UIColor *)boxBoderColor boxBoderWidth:(CGFloat)boxBoderWidth boxFullAreaColor:(UIColor *)boxFullAreaColor boxFullAreaAlpha:(CGFloat)boxFullAreaAlpha boxBoderCornerColor:(UIColor *)boxBoderCornerColor boxMargin:(CGFloat)boxMargin;

@end

NS_ASSUME_NONNULL_END
