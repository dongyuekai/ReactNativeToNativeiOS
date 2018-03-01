//
//  RNViewController.m
//  ReactNativeToNativeiOS
//
//  Created by dyk on 2018/3/1.
//  Copyright © 2018年 dyk. All rights reserved.
//

#import "RNViewController.h"

@interface RNViewController ()

@end

@implementation RNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * strUrl = @"http://localhost:8081/index.ios.bundle?platform=ios&dev=true";
    NSURL *jsCodeLocation = [NSURL URLWithString:strUrl];
    RCTRootView *rootView = [[RCTRootView alloc]initWithBundleURL:jsCodeLocation moduleName:@"ReactNativeToNativeiOS" initialProperties:nil launchOptions:nil];
    self.view = rootView;
}

@end
