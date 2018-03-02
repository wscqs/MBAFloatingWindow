//
//  MBAFolatingWindow.m
//  MBAFloatingWindow
//
//  Created by mba on 2018/3/2.
//  Copyright © 2018年 cqs. All rights reserved.
//

#import "MBAFolatingWindow.h"

#define kk_WIDTH self.frame.size.width
#define kk_HEIGHT self.frame.size.height

#define kk_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kk_ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define animateDuration 0.3       //位置改变动画时间
#define statusChangeDuration  2.0    //状态改变时间
#define normalAlpha  1.0           //正常状态时背景alpha值
#define sleepAlpha  0.5           //隐藏到边缘时的背景alpha值

@interface MBAFolatingWindow ()

@property (strong, nonatomic) UIImageView *mShowImgView;

@end

@implementation MBAFolatingWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initCtrlWithFrame:frame];
    }
    return self;
}

-(void)_initCtrlWithFrame:(CGRect)frame{
    self.backgroundColor = [UIColor clearColor];
    self.windowLevel = UIWindowLevelAlert + 1;  //如果想在 alert 之上，则改成 + 2
    self.rootViewController = [UIViewController new];
    [self makeKeyAndVisible];

    _mShowImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    CGFloat showImgViewW = self.frame.size.width;
    _mShowImgView.frame = CGRectMake(0, 0, showImgViewW, showImgViewW);
    _mShowImgView.layer.cornerRadius = showImgViewW/2;
    _mShowImgView.layer.masksToBounds = true;
    _mShowImgView.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:_mShowImgView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    pan.delaysTouchesBegan = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:tap];

    [self performSelector:@selector(justbegin) withObject:nil afterDelay:statusChangeDuration];
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _mShowImgView.image = image;
}


- (void)dissmiss{
    [self stopAnimation];
    self.hidden = YES;
}
- (void)show{
    self.hidden = NO;
    [self startAnimation];
}

-(void)startAnimation{
    [_mShowImgView.layer removeAllAnimations];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [_mShowImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopAnimation{
    [_mShowImgView.layer removeAllAnimations];
}


- (void)justbegin{
    
    [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
    
    CGPoint panPoint = CGPointMake(kk_ScreenWidth-80, kk_ScreenHeight-150);
    
    [self changBoundsabovePanPoint:panPoint];
}

- (void)changBoundsabovePanPoint:(CGPoint)panPoint{
    
    if(panPoint.x <= kk_ScreenWidth/2)
    {
        if(panPoint.y <= 40+kk_HEIGHT/2 && panPoint.x >= 20+kk_WIDTH/2)
        {
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(panPoint.x, kk_HEIGHT/2);
            }];
        }
        else if(panPoint.y >= kk_ScreenHeight-kk_HEIGHT/2-40 && panPoint.x >= 20+kk_WIDTH/2)
        {
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(panPoint.x, kk_ScreenHeight-kk_HEIGHT/2);
            }];
        }
        else if (panPoint.x < kk_WIDTH/2+20 && panPoint.y > kk_ScreenHeight-kk_HEIGHT/2)
        {
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kk_WIDTH/2, kk_ScreenHeight-kk_HEIGHT/2);
            }];
        }
        else
        {
            CGFloat pointy = panPoint.y < kk_HEIGHT/2 ? kk_HEIGHT/2 :panPoint.y;
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kk_WIDTH/2, pointy);
            }];
        }
    }
    else if(panPoint.x > kk_ScreenWidth/2)
    {
        if(panPoint.y <= 40+kk_HEIGHT/2 && panPoint.x < kk_ScreenWidth-kk_WIDTH/2-20 )
        {
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(panPoint.x, kk_HEIGHT/2);
            }];
        }
        else if(panPoint.y >= kk_ScreenHeight-40-kk_HEIGHT/2 && panPoint.x < kk_ScreenWidth-kk_WIDTH/2-20)
        {
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(panPoint.x, kk_ScreenHeight-kk_HEIGHT/2);
            }];
        }
        else if (panPoint.x > kk_ScreenWidth-kk_WIDTH/2-20 && panPoint.y < kk_HEIGHT/2)
        {
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kk_ScreenWidth-kk_WIDTH/2, kk_HEIGHT/2);
            }];
        }
        else
        {
            CGFloat pointy = panPoint.y > kk_ScreenHeight-kk_HEIGHT/2 ? kk_ScreenHeight-kk_HEIGHT/2 :panPoint.y;
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kk_ScreenWidth-kk_WIDTH/2, pointy);
            }];
        }
    }
    
}
//改变位置
- (void)locationChange:(UIPanGestureRecognizer*)p
{
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        _mShowImgView.alpha = normalAlpha;
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
        
        [self changBoundsabovePanPoint:panPoint];
        
    }
}
//点击事件
- (void)click:(UITapGestureRecognizer*)p
{
    _mShowImgView.alpha = normalAlpha;
    
    //拉出悬浮窗
    if (self.center.x == 0) {
        self.center = CGPointMake(kk_WIDTH/2, self.center.y);
    }else if (self.center.x == kk_ScreenWidth) {
        self.center = CGPointMake(kk_ScreenWidth - kk_WIDTH/2, self.center.y);
    }else if (self.center.y == 0) {
        self.center = CGPointMake(self.center.x, kk_HEIGHT/2);
    }else if (self.center.y == kk_ScreenHeight) {
        self.center = CGPointMake(self.center.x, kk_ScreenHeight - kk_HEIGHT/2);
    }
    
    if (self.tapClickBlock) self.tapClickBlock();
}

- (void)changeStatus
{
    [UIView animateWithDuration:1.0 animations:^{
        _mShowImgView.alpha = sleepAlpha;
    }];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat x = self.center.x < 20+kk_WIDTH/2 ? 0 :  self.center.x > kk_ScreenWidth - 20 -kk_WIDTH/2 ? kk_ScreenWidth : self.center.x;
        CGFloat y = self.center.y < 40 + kk_HEIGHT/2 ? 0 : self.center.y > kk_ScreenHeight - 40 - kk_HEIGHT/2 ? kk_ScreenHeight : self.center.y;
        
        //禁止停留在4个角
        if((x == 0 && y ==0) || (x == kk_ScreenWidth && y == 0) || (x == 0 && y == kk_ScreenHeight) || (x == kk_ScreenWidth && y == kk_ScreenHeight)){
            y = self.center.y;
        }
        self.center = CGPointMake(x, y);
    }];
}



@end
