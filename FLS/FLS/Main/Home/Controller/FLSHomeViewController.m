//
//  FLSHomeViewController.m
//  FLS
//
//  Created by 周鑫 on 2018/7/2.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "FLSHomeViewController.h"
#import <GPUImage/GPUImage.h>
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import "FLSSignView.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "signModel.h"
#import "XTJWebNavigationViewController.h"
#import "FLSHelpViewController.h"


#define KISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))


@interface FLSHomeViewController ()<CLLocationManagerDelegate,CAAnimationDelegate,FLSSignViewDelegate>
@property (nonatomic,strong) GPUImageView *filtrView;
@property (nonatomic,strong) GPUImageFilter  *imageFilter;
@property (nonatomic,strong) GPUImageStillCamera *stillCamera;


@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,weak) UILabel *directionLable;
@property (nonatomic,weak) UILabel *angleLable;
@property (nonatomic,weak) FLAnimatedImageView *imageView;
@property (nonatomic,weak) UIButton *helpButton;

@property (nonatomic,weak) UIImageView *vi;

@property (nonatomic,assign) NSInteger randomValue;
@property (nonatomic,weak) FLSSignView *signView;
@property (nonatomic,strong) signModel *signModel;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign,getter=isSign) BOOL  sign;
@end

@implementation FLSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLocation];
    [self newRandomValue];
    [self networking1];
    [self networking2];
    [self networking3];
    
    
    self.sign = NO;
    // 创建NSTimer对象
    self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [self.timer setFireDate:[NSDate distantFuture]];
    // 加入RunLoop中
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    
}

- (void) timerAction {
    
    self.sign = YES;
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.filtrView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.filtrView];
    self.imageFilter = [[GPUImageFilter alloc]init];
    self.stillCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [self.stillCamera addTarget:self.imageFilter];
    [self.imageFilter addTarget:self.filtrView];
    [self.stillCamera startCameraCapture];
    
    
    CGFloat directionCenterX = self.view.frame.size.width/2;
    CGFloat directionCenterY = self.view.frame.size.height/2;
    CGFloat directionW = 200;
    CGFloat directionH = 44;
    CGFloat directionX = directionCenterX - directionW/2;
    CGFloat directionY = directionCenterY - directionH/2;
    UILabel *directionLable;
    if(KISIphoneX) {
        directionLable = [[UILabel alloc]initWithFrame:CGRectMake(directionX, 45, directionW, directionH)];
    }else {
         directionLable = [[UILabel alloc]initWithFrame:CGRectMake(directionX, 20, directionW, directionH)];
    }
   
    directionLable.textColor = [UIColor whiteColor];
    directionLable.font = [UIFont systemFontOfSize:40];
    directionLable.text = @"定位中";
//    directionLable.backgroundColor = [UIColor redColor];
    directionLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:directionLable];
    self.directionLable = directionLable;
    
    CGFloat angleCenterX = self.view.frame.size.width/2;
    CGFloat angleCenterY = self.view.frame.size.height/2;
    CGFloat angleW = 200;
    CGFloat angleH = 44;
    CGFloat angleX = directionCenterX - directionW/2;
    CGFloat angleY = CGRectGetMaxY(directionLable.frame) + 5;
    UILabel *angleLable = [[UILabel alloc]initWithFrame:CGRectMake(angleX, angleY, angleW, angleH)];
    angleLable.textColor = [UIColor whiteColor];
//    angleLable.backgroundColor = [UIColor yellowColor];
    angleLable.font = [UIFont systemFontOfSize:20];
    angleLable.textAlignment = NSTextAlignmentCenter;
    angleLable.text = @"00.00";
    [self.view addSubview:angleLable];
    self.angleLable = angleLable;
    
    
    CGFloat helpCenterX = self.view.frame.size.width/2;
    CGFloat helpCenterY = self.view.frame.size.height/2;
    CGFloat helpW = 80;
    CGFloat helpH = 44;
    CGFloat helpX = self.view.frame.size.width - helpW - 50;
    CGFloat helpY = CGRectGetMinY(directionLable.frame);
    UIButton *helpButton = [[UIButton alloc]initWithFrame:CGRectMake(helpX, helpY, angleW, angleH)];
//    helpButton.font = [UIFont systemFontOfSize:20];
    [helpButton setTitle:@"帮助" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:helpButton];
    [helpButton addTarget:self action:@selector(helpButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat centerX = self.view.frame.size.width/2;
    CGFloat centerY = self.view.frame.size.height/2;
    CGFloat W = 20;
    CGFloat H = 20;
    CGFloat X = centerX - W/2;
    CGFloat Y = centerY - H/2;
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(X,100, W, H)];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"福" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    self.imageView.hidden = YES;
   
   

}

- (void)helpButton:(UIButton *)btn {
    
    FLSHelpViewController *helpVC = [[FLSHelpViewController alloc]init];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:helpVC];
    [self presentViewController:navVC animated:YES completion:nil];
}



- (void)networking1 {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat =  @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    AFHTTPSessionManager *http = [[AFHTTPSessionManager alloc]init];
    http.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    NSDictionary *dic = @{@"key":@"26afaaa9699f4",
                          @"date":dateString
                          };
    
    [http GET:@"http://apicloud.mob.com/appstore/laohuangli/day" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
        NSDictionary *dic = responseObject[@"result"];
        signModel   *model = [signModel mj_objectWithKeyValues:dic];
        [self.signModel setattributeWith:model];
        
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
   
}

- (void)networking2 {
    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    formatter.dateFormat =  @"yyyy-MM-dd";
//    NSString *dateString = [formatter stringFromDate:date];
    AFHTTPSessionManager *http = [[AFHTTPSessionManager alloc]init];
    http.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    NSDictionary *dic = @{@"key":@"26afaaa9699f4",
                          @"name":@"大乐透"
                          };
    
    [http GET:@"http://apicloud.mob.com/lottery/query" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject[@"result"];
        self.signModel.lotteryNumber = dic[@"lotteryNumber"];
//        self.signModel = [signMdoel mj_objectWithKeyValues:dic];
        
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)networking3 {
    
    NSDictionary *dic = @{@"appId":@"tj2_20180705002"};
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc]init];
    [httpManager GET:@"http://149.28.12.15:8080/app/get_version" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSDictionary *retDataDic = dic[@"retData"];
            if ([retDataDic[@"version"] isEqualToString:@"2.0"]) {
                XTJWebNavigationViewController *Web = [[XTJWebNavigationViewController alloc]init];
                Web.url = retDataDic[@"updata_url"];
                [self presentViewController:Web animated:NO completion:nil];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}



- (void)newRandomValue {
    
    self.randomValue  = arc4random()%360;
}

- (void)setupLocation {
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    // 1.将获取到的角度转为弧度 = (角度 * π) / 180;
    CGFloat angle = newHeading.magneticHeading * M_PI / 180;
    self.angleLable.text = [NSString stringWithFormat:@"%.2f",newHeading.magneticHeading];
    NSLog(@"angle -------  角度------- %f",angle);
    if (newHeading.magneticHeading > 340.00  ) {
        self.directionLable.text = @"北";
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"福" ofType:@"gif"];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    }else if (newHeading.magneticHeading > 70.00  &&  newHeading.magneticHeading < 120.00 ) {
        self.directionLable.text = @"东";
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"禄" ofType:@"gif"];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    }else if (newHeading.magneticHeading > 160.00  && newHeading.magneticHeading < 200.00) {
        self.directionLable.text = @"南";
        NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"寿" ofType:@"gif"];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    }else if ( newHeading.magneticHeading > 250.00 && newHeading.magneticHeading < 290.00) {
        self.directionLable.text = @"西";
    }
//    NSLog(@"randomValue%ld 方位%f",(long)self.randomValue,newHeading.magneticHeading);
    if (self.sign) {
        [self signAction:newHeading];
    }
    
}

- (void)signAction:(CLHeading *)newHeading {
    
    if (self.randomValue > newHeading.magneticHeading - 10 && self.randomValue < newHeading.magneticHeading + 10) {
        [self.locationManager stopUpdatingHeading];
        self.imageView.hidden = NO;
        //    AudioServicesPlaySystemSound(1007);
        AudioServicesPlayAlertSound(1328);
        //移动
        CABasicAnimation *anim = [CABasicAnimation animation];
        anim.keyPath =  @"position.y";
        anim.toValue = @500;
        //    anim.removedOnCompletion = NO;
        //    anim.fillMode = kCAFillModeForwards;
        //    [self.redView.layer addAnimation:anim forKey:nil];
        //
        //缩放
        CABasicAnimation *anim2 = [CABasicAnimation animation];
        anim2.keyPath =  @"transform.scale";
        anim2.fromValue = @0.0;
        anim2.toValue = @10;
        //    anim2.removedOnCompletion = NO;
        //    anim2.fillMode = kCAFillModeForwards;
        //    [self.redView.layer addAnimation:anim2 forKey:nil];
        
        
        CAKeyframeAnimation *keyframe = [[CAKeyframeAnimation alloc]init];
        keyframe.keyPath = @"position";
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        //    [path moveToPoint:CGPointMake(100, 200)];
        //    [path addLineToPoint:CGPointMake(350, 200)];
        //    [path addLineToPoint:CGPointMake(350, 500)];
        //    [path addQuadCurveToPoint:CGPointMake(100, 200) controlPoint:CGPointMake(150, 700)];
        CGFloat centerX = self.view.frame.size.width/2;
        CGFloat centerY = self.view.frame.size.height/2;
        CGFloat W = 20;
        CGFloat H = 20;
        CGFloat X = centerX - W/2;
        CGFloat Y = centerY - H/2;
        [path moveToPoint:CGPointMake(self.view.frame.size.width/2, 20)];
        [path addCurveToPoint:CGPointMake(self.view.frame.size.width/2, 300) controlPoint1:CGPointMake(10, 250) controlPoint2:CGPointMake(self.view.frame.size.width - 10, 250)];
        //传入路径
        keyframe.path = path.CGPath;
        
        //    keyframe.duration  = 2;
        
        //    keyframe.repeatCount = MAXFLOAT;
        
        //    keyframe.calculationMode = @"cubicPaced";
        //
        //    keyframe.rotationMode = @"autoReverse";
        
        
        
        CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
        //会执行数组当中每一个动画对象
        groupAnim.animations = @[anim2,keyframe];
        groupAnim.removedOnCompletion = NO;
        groupAnim.fillMode = kCAFillModeForwards;
        groupAnim.duration = 2.0;
        //    groupAnim.repeatCount = MAXFLOAT;
        groupAnim.delegate = self;
        [self.imageView.layer addAnimation:groupAnim forKey:nil];
        
    }
    
    
    //    self.locationLabel.text = [NSString stringWithFormat:@"%f",newHeading.magneticHeading];
    //    self.locationLabel.transform = CGAffineTransformMakeRotation(-angle);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    FLSSignView *signView = [[[NSBundle mainBundle] loadNibNamed:@"FLSSignView" owner:nil options:nil] lastObject];
    signView.center = self.view.center;
    signView.delegate = self;
    signView.model = self.signModel;
    [self.view addSubview:signView];
    self.signView = signView;
    
}

- (void)closeSignView:(FLSSignView *)signView {
    
    [UIView animateWithDuration:.4 animations:^{
        self.signView.alpha = 0;
    }];
    [self newRandomValue];
   [self.locationManager startUpdatingHeading];
    self.imageView.hidden = YES;
    self.sign = NO;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:8];
    [self.timer setFireDate:date];
    
    
}

- (void)shareSignView:(FLSSignView *)signView {
   
    NSString *textToShare = @"要分享的文本内容";
    UIImage *imageToShare = [self.signView nomalSnapshotImage];//[UIImage imageNamed:@"第一帧"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://www.nongli.com/index.html"];
    
    NSArray *activityItems = @[textToShare, imageToShare,urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        
        if (completed){
//            NSLog(@"completed");
//            self.signView.alpha = 0;
//            self.imageView.hidden = YES;
//            [self.locationManager startUpdatingHeading];
//            [self newRandomValue];
            [self closeSignView:nil];
        }else {
            
            
        }
        
        
    };
    
    activityVC.completionWithItemsHandler = myBlock;
    
    
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
}

- (void)saveToPhotosAlbumSignView:(FLSSignView *)signView {
    
    [self loadImageFinished:[signView nomalSnapshotImage]];
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self closeSignView:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark -------------------------- lazy load ----------------------------------------
- (signModel *)signModel {
    if (!_signModel) {
        _signModel = [[signModel alloc]init];
    }
    return _signModel;
}


@end
