//
//  ViewController.m
//  Demo
//
//  Created by Ice on 2018/12/3.
//  Copyright © 2018 Ice. All rights reserved.
//

#import "ViewController.h"
#import "BLImageCropView.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BLImageCropToolClass.h"
@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


{
    UIImage  *orginImage1, *orginImage2, *orginImage3, *orginImage4;
    BLImageCropView *imgV;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton * helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 100, 50)];
    [helpBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setTitle:@"打开相册" forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:helpBtn];
    
    
    UIButton * helpBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height - 100, 100, 50)];
    [helpBtn1 addTarget:self action:@selector(Click1:) forControlEvents:UIControlEventTouchUpInside];
    
    [helpBtn1 setTitle:@"完成剪裁" forState:UIControlStateNormal];
    [helpBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:helpBtn1];
    
    UIButton * helpBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(200, self.view.frame.size.height - 100, 100, 50)];
    [helpBtn2 addTarget:self action:@selector(Click2:) forControlEvents:UIControlEventTouchUpInside];
    
    [helpBtn2 setTitle:@"清除" forState:UIControlStateNormal];
    [helpBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:helpBtn2];
    
}
-(void)Click1:(UIButton *)button {
    [imgV doneCrop];
}
-(void)Click2:(UIButton *)button {
    [imgV removeFromSuperview];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    //    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    imgV = [[BLImageCropView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 200)];
    imgV.boxWHScale = 9.0/16.0;
//    imgV.boxBoderColor = [UIColor yellowColor];
//    imgV.boxWidth = 300 ;
//    imgV.boxBoderCornerColor = [UIColor greenColor];
    imgV.boxMargin = 10;
    [imgV initDataOrginImage:image isRedrawImageSize:true andBlock:^(UIImage * _Nonnull resultImage) {
        
        [BLImageCropToolClass saveCameraToPhotoAlbum:resultImage successBlock:^(BOOL success) {
            NSString * str =  success ? @"保存-  成功" : @"保存-  失败";
            NSLog(@" 保存-  %@",str);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:UIAlertControllerStyleAlert];
                
                // 2.创建并添加按钮
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [alertController addAction:okAction];           // A
                [self presentViewController:alertController animated:YES completion:nil];
            });
            
        }];
    }];
    [self.view addSubview:imgV];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)Click:(UIButton *)button {
    //创建UIImagePickerController对象，并设置代理和可编辑
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    //    imagePicker.allowsEditing = YES;
    
    //创建sheet提示框，提示选择相机还是相册
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择打开方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //相机选项
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //选择相机时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //跳转到UIImagePickerController控制器弹出相机
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    //相册选项
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //选择相册时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //跳转到UIImagePickerController控制器弹出相册
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    //取消按钮
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //添加各个按钮事件
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];
    
    //弹出sheet提示框
    [self presentViewController:alert animated:YES completion:nil];
}

@end
