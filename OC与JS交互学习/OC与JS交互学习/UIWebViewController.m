//
//  UIWebViewController.m
//  OC与JS交互学习
//
//  Created by zsf on 2016/12/16.
//  Copyright © 2016年 zsf. All rights reserved.
//

#import "UIWebViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UIWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}



- (void)initUI
{
    self.title = @"UIWebView拦截URL";
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    NSURL *htmlUrl = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlUrl];
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}


- (void)hanleCustomAction:(NSURL *)url
{
    NSString *host = [url host];
    if ([host isEqualToString:@"scanClick"]) {
        NSLog(@"扫一扫");
    }else if ([host isEqualToString:@"shareClick"]){
        [self share:url];
    }else if ([host isEqualToString:@"getLocation"]) {
        [self getLocation];
    } else if ([host isEqualToString:@"setColor"]) {
        [self changeBGColor:url];
    } else if ([host isEqualToString:@"payAction"]) {
        [self payAction:url];
    } else if ([host isEqualToString:@"shake"]) {
        [self shakeAction];
    } else if ([host isEqualToString:@"goBack"]) {
        [self goBack];
    }
}


- (void)share:(NSURL *)url
{
    NSArray *params = [url.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *str in params) {
        NSArray *dicArray = [str componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    
    NSString *title = [tempDic objectForKey:@"title"];
    NSString *content = [tempDic objectForKey:@"content"];
    NSString *urlStr = [tempDic objectForKey:@"url"];
    
    
    //将分享结果返给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,urlStr];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)getLocation
{
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"上海市"];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)changeBGColor:(NSURL *)url
{
    NSArray *params =[url.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    
    CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
    CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
    CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
    CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
    
    self.view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

- (void)payAction:(NSURL *)URL
{
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    //    NSString *orderNo = [tempDic objectForKey:@"order_no"];
    //    long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
    //    NSString *subject = [tempDic objectForKey:@"subject"];
    //    NSString *channel = [tempDic objectForKey:@"channel"];
    
    // 支付操作
    
    // 将支付结果返回给js
    NSUInteger code = 1;
    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@',%lu)",@"支付成功",(unsigned long)code];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)shakeAction
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void)goBack
{
    [self.webView goBack];
}


#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"haleyaction"]) {
        [self hanleCustomAction:url];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //往html的JS环境插入全局变量、js方法等
    [webView stringByEvaluatingJavaScriptFromString:@"var arr = [1,2,'abc']"];
}

@end
