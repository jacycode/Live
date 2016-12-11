//
//  PullViewController.m
//  LiveDemo
//
//  Created by 刘清 on 2016/12/10.
//  Copyright © 2016年 刘清. All rights reserved.
//

#import "PullViewController.h"
#import <WebKit/WebKit.h>

@interface PullViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self createHLSView];
    [self createWKHLSView];
    
}

- (void)createHLSView{
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.marrymin.com:81/hls/test.m3u8"]]];
    [self.view addSubview:_webView];
}

- (void)createWKHLSView{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.marrymin.com:81/hls/test.m3u8"]]];
    [self.view addSubview:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
