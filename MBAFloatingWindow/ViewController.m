//
//  ViewController.m
//  MBAFloatingWindow
//
//  Created by mba on 2018/3/2.
//  Copyright © 2018年 cqs. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (strong, nonatomic) AppDelegate *mAppDelegate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mAppDelegate = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    
}
- (IBAction)show:(id)sender {
    [self.mAppDelegate.flatingWindow show];
}
- (IBAction)dismiss:(id)sender {
    [self.mAppDelegate.flatingWindow dissmiss];
}
- (IBAction)startAnimation:(id)sender {
    [self.mAppDelegate.flatingWindow startAnimation];
}
- (IBAction)stopAnimation:(id)sender {
    [self.mAppDelegate.flatingWindow stopAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
