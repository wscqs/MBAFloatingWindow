//
//  MBAFolatingWindow.h
//  MBAFloatingWindow
//
//  Created by mba on 2018/3/2.
//  Copyright © 2018年 cqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBAFolatingWindow : UIWindow

@property (strong, nonatomic) UIImage *image;

// 显示（默认）
- (void)show;
// 隐藏
- (void)dissmiss;

- (void)startAnimation;
- (void)stopAnimation;

@property (strong, nonatomic) void(^tapClickBlock)(void);



@end
