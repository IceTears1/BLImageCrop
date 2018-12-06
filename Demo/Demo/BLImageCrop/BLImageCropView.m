//
//  BLImageCropView.m
//  Demo
//
//  Created by Ice on 2018/12/5.
//  Copyright © 2018 Ice. All rights reserved.
//

#import "BLImageCropView.h"
#import "UIImage+BLFixOrientation.h"
#import "BLCropCoverView.h"


@interface  BLImageCropView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *orginImgView;
    BLCropCoverView *boxView;
    //拖动和 捏合时候计算坐标
    CGPoint center;
    CGSize orginSize;
    CGFloat minZoom; //最小缩放比例
    CGFloat maxZoom; //最大缩放比例
    CGFloat curScale;//当前缩放比例
    CGPoint zoomPoint;//放大时候的中心点
}
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong)UIImage *orginImage;
@property (nonatomic, assign)BOOL isRedraw;
@end
@implementation BLImageCropView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认框子的大小
        self.boxWidth  = self.frame.size.width;
        //默认的比例
        self.boxWHScale = 9.0 / 16.0;
        //默认的边距 10.0
        self.boxMargin = 10.0;
        //默认边框设置
        self.boxBoderColor = [UIColor grayColor];
        self.boxBoderWidth = 1;
        
        //默认填充区域的设置
        self.boxFullAreaColor = [UIColor blackColor];
        self.boxFullAreaAlpha = 0.5;
        
        //默认四个角设置
        self.boxBoderCornerColor = [UIColor whiteColor];
        
        //最大放大倍数
        self.imageMaxScale = 5.0;
        
        //重绘图片的 宽度 高度等比例适应
        self.reDrawImageWidth = 1080.0;
        
        

    }
    return self;
}
- (void)initDataOrginImage:(UIImage *)image isRedrawImageSize:(BOOL)isRedraw andBlock:(BL_ImageCropBlock)resultBlock{
    
    self.orginImage = image;
    self.isRedraw = isRedraw;
    self.resultBlock = resultBlock;
    self.layer.masksToBounds = true;
    [self createUI];
}

- (void)createUI{
    boxView = [[BLCropCoverView alloc] initWithFrame:self.bounds];
    [boxView initBoxView:self.boxWidth wAndHScale:self.boxWHScale boxBoderColor:self.boxBoderColor boxBoderWidth:self.boxBoderWidth boxFullAreaColor:self.boxFullAreaColor boxFullAreaAlpha:self.boxFullAreaAlpha boxBoderCornerColor:self.boxBoderCornerColor boxMargin:self.boxMargin];
    //一倍时候的尺寸
    CGRect oneFrame = [self.orginImage getImageAdaptiveSizeBgView:self];
    
    //实际最小尺寸大部分情况下不能为1倍  根据比例自适应
    CGFloat orginScale = self.orginImage.size.width /self.orginImage.size.height ;
    CGSize size = CGSizeZero;
    //根据宽高比例不同计算出 需要以g宽适配 还是以高适配
    if (orginScale > self.boxWHScale) {
        CGFloat w = self.orginImage.size.width * boxView.box_Frame.size.height /self.orginImage.size.height;
        size = CGSizeMake(w, boxView.box_Frame.size.height);
    }else{
        CGFloat h = self.orginImage.size.height * boxView.box_Frame.size.width /self.orginImage.size.width;
        size = CGSizeMake( boxView.box_Frame.size.width, h);
    }

    //设置图片的位置
    orginImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-(size.width - self.frame.size.width)/2, -(size.height - self.frame.size.height)/2, size.width, size.height)];
    orginImgView.contentMode = UIViewContentModeScaleAspectFit;
    orginImgView.image = self.orginImage;
    orginImgView.userInteractionEnabled = true;
    [self addSubview:orginImgView];
    
    //拿到 最小倍数  最大倍数   最小倍数下orginImgView的大小
    minZoom = size.width/oneFrame.size.width;
    curScale = minZoom;
    orginSize = oneFrame.size;
    maxZoom = minZoom * self.imageMaxScale;
    
    [self addSubview:boxView];

    //捏合
    UIPinchGestureRecognizer* pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinchGR.delegate = self; // 可以在同一个视图上实现多个手势
   
    
    //p拖动
      UIPanGestureRecognizer *panGP = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
     [boxView addGestureRecognizer:pinchGR];
     [boxView addGestureRecognizer:panGP];
}
-(void)doneCrop{
//    NSLog(@"scale == %f",curScale);
//    NSLog(@"imviewSize == %@",NSStringFromCGRect(orginImgView.frame));
//    NSLog(@"orginSize == %@",NSStringFromCGSize(orginSize));
//    NSLog(@"boxFrame == %@",NSStringFromCGRect(boxView.box_Frame));
    
    //拿到需要剪裁位置的坐标
    CGFloat _x = boxView.box_Frame.origin.x - orginImgView.frame.origin.x ;
    CGFloat _y = boxView.box_Frame.origin.y - orginImgView.frame.origin.y;
    CGFloat _w = boxView.box_Frame.size.width;
    CGFloat _h = boxView.box_Frame.size.height;
    
    //计算剪裁位置相对于 原图的比例
    CGFloat _x_scale = _x/orginImgView.frame.size.width ;
    CGFloat _y_scale = _y/orginImgView.frame.size.height;
    CGFloat _w_scale = _w/orginImgView.frame.size.width;
    CGFloat _h_scale = _h/orginImgView.frame.size.height;
    
    //计算剪裁位置 在原图上边的 坐标位置
    CGFloat crop_x = _x_scale * self.orginImage.size.width ;
    CGFloat crop_y = _y_scale * self.orginImage.size.height;
    CGFloat crop_w = _w_scale * self.orginImage.size.width;
    CGFloat crop_h = _h_scale * self.orginImage.size.height;
    CGRect cropRect = CGRectMake(crop_x, crop_y, crop_w, crop_h);
    
    //开始剪裁
    UIImage *result =  [self.orginImage cropImageRect:cropRect];
    if (self.isRedraw && result != nil) {
        UIImage *reDrawImage = [result redrawImageSizeRedrawWidth:self.reDrawImageWidth];
        if (reDrawImage != nil) {
            self.resultBlock(reDrawImage);
        }
    }else{
        if ( result != nil) {
            self.resultBlock(result);
        }
    }
}
- (void)pinchAction:(UIPinchGestureRecognizer*)sender{
    //捏合手势
    if (sender.state == UIGestureRecognizerStateBegan) {
        //拿到当前中心点位的坐标
        CGFloat point_x = (boxView.box_Frame.origin.x + boxView.box_Frame.size.width / 2) - orginImgView.frame.origin.x;
        CGFloat point_y = (boxView.box_Frame.origin.y + boxView.box_Frame.size.height / 2) - orginImgView.frame.origin.y;
        
        //相对于当前位置的比例
        CGFloat point_x_scale = point_x/orginImgView.frame.size.width ;
        CGFloat point_y_scale = point_y/orginImgView.frame.size.height;
        
        zoomPoint = CGPointMake(point_x_scale, point_y_scale);
        
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        
        //通过捏合手势的到缩放比率
        CGFloat scale = sender.scale;
        if (scale >= 1.0) {
            if (curScale > maxZoom) {
                curScale += scale/5.0 ;
            }else{
                curScale += scale/18.0 ;
            }
            
        }else{
            if (curScale > minZoom) {
                curScale -= scale/10.0 ;
            }else{
                curScale -= scale/40.0 ;
                if (curScale <= 0.2) {
                    curScale = 0.2;
                }
            }
            
        }
        //放大后的图片的大小
        CGFloat curPoint_w = orginSize.width * curScale;
        CGFloat curPoint_h = orginSize.height * curScale;
        
        //放大后中心点的位置
        CGPoint  curNewCenter = CGPointMake(curPoint_w * zoomPoint.x, curPoint_h * zoomPoint.y);
        
        CGFloat curPoint_x = (boxView.box_Frame.origin.x + boxView.box_Frame.size.width / 2) - curNewCenter.x;
        CGFloat curPoint_y = (boxView.box_Frame.origin.y + boxView.box_Frame.size.height / 2) - curNewCenter.y;
        CGRect frame = orginImgView.frame;
        frame = CGRectMake(curPoint_x, curPoint_y, curPoint_w, curPoint_h);
        orginImgView.frame = frame;
        
      
    }else{
        if (curScale > maxZoom) {
            curScale = maxZoom;
        }
        if (curScale < minZoom) {
            curScale = minZoom;
        }
        //放大后的图片的大小
        CGFloat curPoint_w = orginSize.width * curScale;
        CGFloat curPoint_h = orginSize.height * curScale;
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            __strong typeof(self) strongSelf = weakSelf;
            //放大后中心点的位置
            CGPoint  curNewCenter = CGPointMake(curPoint_w * strongSelf->zoomPoint.x, curPoint_h * strongSelf->zoomPoint.y);
            CGFloat curPoint_x = (strongSelf->boxView.box_Frame.origin.x + strongSelf->boxView.box_Frame.size.width / 2) - curNewCenter.x;
            CGFloat curPoint_y = (strongSelf->boxView.box_Frame.origin.y + strongSelf->boxView.box_Frame.size.height / 2) - curNewCenter.y;
            CGRect frame = strongSelf->orginImgView.frame;
            frame = CGRectMake(curPoint_x, curPoint_y, curPoint_w, curPoint_h);
            strongSelf->orginImgView.frame = frame;
        }];
         [self borderDetection];
    }
   
}
- (void)panAction:(UIPanGestureRecognizer*)sender{
    //拖动
    if (sender.state == UIGestureRecognizerStateBegan) {
            center =  orginImgView.center;
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        //得到当前手势所在视图
        UIView *view = sender.view;
        //得到我们在视图上移动的偏移量
        CGPoint currentPoint = [sender translationInView:view.superview];
        
        if (orginImgView.frame.origin.x > boxView.box_Center.x || orginImgView.frame.origin.y > boxView.box_Center.y  || CGRectGetMaxX(orginImgView.frame) <  boxView.box_Center.x || CGRectGetMaxY(orginImgView.frame) <  boxView.box_Center.y) {
            return;
        }
  
        orginImgView.center = CGPointMake(center.x + currentPoint.x, center.y + currentPoint.y);
    }else{
          [self borderDetection];
    }

}
- (void)borderDetection{
     __weak typeof(self) weakSelf = self;
    CGFloat duration = 0.3;
    if (orginImgView.frame.origin.x >= boxView.box_Frame.origin.x){
        [UIView animateWithDuration:duration animations:^{
            __strong typeof(self) strongSelf = weakSelf;
            CGRect frame = strongSelf->orginImgView.frame;
            frame.origin.x = strongSelf->boxView.box_Frame.origin.x;
            strongSelf->orginImgView.frame = frame;
        }];
    }
    
    if (orginImgView.frame.origin.y >= boxView.box_Frame.origin.y){
        [UIView animateWithDuration:duration animations:^{
            __strong typeof(self) strongSelf = weakSelf;
            CGRect frame = strongSelf->orginImgView.frame;
            frame.origin.y = strongSelf->boxView.box_Frame.origin.y;
            strongSelf->orginImgView.frame = frame;
        }];
    }
    
    if (CGRectGetMaxX(orginImgView.frame)<= CGRectGetMaxX(boxView.box_Frame)){
       
        [UIView animateWithDuration:duration animations:^{
            __strong typeof(self) strongSelf = weakSelf;
            CGRect frame = strongSelf->orginImgView.frame;
            frame.origin.x = CGRectGetMaxX(strongSelf->boxView.box_Frame) - frame.size.width;
            strongSelf->orginImgView.frame = frame;
        }];
    }
    if ((CGRectGetMaxY(orginImgView.frame) <= CGRectGetMaxY(boxView.box_Frame))){
   
        [UIView animateWithDuration:duration animations:^{
            __strong typeof(self) strongSelf = weakSelf;
            CGRect frame = strongSelf->orginImgView.frame;
            frame.origin.y = CGRectGetMaxY(strongSelf->boxView.box_Frame) - frame.size.height;
            strongSelf->orginImgView.frame = frame;
        }];
        
    }
}

-(UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    }
    return _coverView;
}

@end
