//
//  MainViewController.m
//  OC与JS交互学习
//
//  Created by zsf on 2016/12/16.
//  Copyright © 2016年 zsf. All rights reserved.
//

#import "MainViewController.h"
#import "WKViewController.h"
#import "UIWebViewController.h"
#import "WKViewMessageHandler.h"
#import "JavaScriptCoreController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)useUIWebView:(UIButton *)sender {
    UIWebViewController *webVc = [[UIWebViewController alloc] init];
    [self.navigationController pushViewController:webVc animated:YES];
    
    
}
- (IBAction)useWKWebView:(UIButton *)sender {
    WKViewController *wkVc = [[WKViewController alloc] init];
    [self.navigationController pushViewController:wkVc animated:YES];
}
- (IBAction)messageHandler {
    
    WKViewMessageHandler *handlerVc = [[WKViewMessageHandler alloc] init];
    [self.navigationController pushViewController:handlerVc animated:YES];
}
- (IBAction)javaScriptCore {
    
    JavaScriptCoreController *handlerVc = [[JavaScriptCoreController alloc] init];
    [self.navigationController pushViewController:handlerVc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
