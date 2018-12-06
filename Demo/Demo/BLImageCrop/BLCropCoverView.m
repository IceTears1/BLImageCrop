//
//  BLCropCoverView.m
//  Demo
//
//  Created by Ice on 2018/12/5.
//  Copyright © 2018 Ice. All rights reserved.
//

#import "BLCropCoverView.h"

@implementation BLCropCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initBoxView:(CGFloat)box_w wAndHScale:(CGFloat)scale boxBoderColor:(UIColor *)boxBoderColor boxBoderWidth:(CGFloat)boxBoderWidth boxFullAreaColor:(UIColor *)boxFullAreaColor boxFullAreaAlpha:(CGFloat)boxFullAreaAlpha boxBoderCornerColor:(UIColor *)boxBoderCornerColor boxMargin:(CGFloat)boxMargin{

    if (box_w >= self.frame.size.width) {
        box_w = self.frame.size.width - boxMargin * 2 ;
    }
    CGFloat box_h = box_w * (1/scale);
    
    if (box_h >= self.frame.size.height) {
        box_h = self.frame.size.height - boxMargin * 2 ;
    }
    if ( (box_w / box_h) != (scale) ) {
        box_w = box_h * scale ;
    }
    

    CALayer *topLayer = [CALayer layer];
    topLayer.frame = CGRectMake(0, 0, self.frame.size.width,(self.frame.size.height - box_h)/2);
    topLayer.backgroundColor = boxFullAreaColor.CGColor;
    topLayer.opacity = boxFullAreaAlpha;
    [self.layer addSublayer:topLayer];
    

    
    CALayer *leftLayer = [CALayer layer];
    leftLayer.frame = CGRectMake(0, topLayer.frame.size.height, (self.frame.size.width - box_w)/2, box_h);
    leftLayer.backgroundColor = boxFullAreaColor.CGColor;
    leftLayer.opacity = boxFullAreaAlpha;
    [self.layer addSublayer:leftLayer];
    
    CALayer *rightLayer = [CALayer layer];
    rightLayer.frame = CGRectMake(self.frame.size.width - (self.frame.size.width - box_w)/2 , topLayer.frame.size.height, (self.frame.size.width - box_w)/2, box_h );
    rightLayer.backgroundColor = boxFullAreaColor.CGColor;
    rightLayer.opacity = boxFullAreaAlpha;
    [self.layer addSublayer:rightLayer];
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(0, self.frame.size.height - (self.frame.size.height - box_h)/2, self.frame.size.width, (self.frame.size.height - box_h)/2);
    bottomLayer.backgroundColor = boxFullAreaColor.CGColor;
    bottomLayer.opacity = boxFullAreaAlpha;
    [self.layer addSublayer:bottomLayer];
    
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - box_w)/2, (self.frame.size.height - box_h)/2, box_w, box_w *(1/scale))];
    boxView.layer.borderColor = boxBoderColor.CGColor;
    boxView.layer.borderWidth = boxBoderWidth;
    [self addSubview:boxView];
    
    self.box_Frame = boxView.frame;
    self.box_Center = boxView.center;
    
    CGFloat smllBox_w = box_w * 0.07;
    CGFloat smllBoxBoder_w = 2;
    CGSize boxSize = boxView.frame.size;
    //左上 顶部
    CALayer *layer_leftTop_top = [CALayer layer];
    layer_leftTop_top.frame = CGRectMake(-smllBoxBoder_w, -smllBoxBoder_w, smllBox_w, smllBoxBoder_w);
    layer_leftTop_top.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_leftTop_top];
    //左上 左
    CALayer *layer_leftTop_Left = [CALayer layer];
    layer_leftTop_Left.frame = CGRectMake(-smllBoxBoder_w, -smllBoxBoder_w, smllBoxBoder_w, smllBox_w);
    layer_leftTop_Left.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_leftTop_Left];
    
    //右上 顶部
    CALayer *layer_rightTop_top = [CALayer layer];
    layer_rightTop_top.frame = CGRectMake(boxSize.width - smllBox_w + smllBoxBoder_w, - smllBoxBoder_w, smllBox_w, smllBoxBoder_w);
    layer_rightTop_top.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_rightTop_top];
    
    //右上 右部
    CALayer *layer_rightTop_right = [CALayer layer];
    layer_rightTop_right.frame = CGRectMake(boxSize.width, 0, smllBoxBoder_w,smllBox_w);
    layer_rightTop_right.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_rightTop_right];
    
    //左下 左部
    CALayer *layer_leftbottom_left = [CALayer layer];
    layer_leftbottom_left.frame = CGRectMake(-smllBoxBoder_w, boxSize.height - smllBox_w + smllBoxBoder_w, smllBoxBoder_w, smllBox_w);
    layer_leftbottom_left.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_leftbottom_left];
    //左下 低部
    CALayer *layer_leftbottom_bottom = [CALayer layer];
    layer_leftbottom_bottom.frame = CGRectMake(-smllBoxBoder_w, boxSize.height, smllBox_w, smllBoxBoder_w);
    layer_leftbottom_bottom.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_leftbottom_bottom];
    //右下 右部
    CALayer *layer_rightbottom_right = [CALayer layer];
    layer_rightbottom_right.frame = CGRectMake(boxSize.width, boxSize.height - smllBox_w + smllBoxBoder_w, smllBoxBoder_w,smllBox_w);
    layer_rightbottom_right.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_rightbottom_right];
    //右下 低部
    CALayer *layer_rightbottom_bottom = [CALayer layer];
    layer_rightbottom_bottom.frame = CGRectMake(boxSize.width - smllBox_w + smllBoxBoder_w, boxSize.height, smllBox_w, smllBoxBoder_w);
    layer_rightbottom_bottom.backgroundColor = boxBoderCornerColor.CGColor;
    [boxView.layer addSublayer:layer_rightbottom_bottom];
    
    
    
    
    
}


@end
