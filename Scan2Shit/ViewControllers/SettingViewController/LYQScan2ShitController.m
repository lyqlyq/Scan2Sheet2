//
//  FoodViewController.m
//  iFood
//
//  Created by lyq on 2019/6/23.
//  Copyright © 2019 www.ipadown.com. All rights reserved.
//

#import "LYQScan2ShitController.h"

#define LYQScan2Shit_View_TAG 1440
#define LYQScan2Shit_H_TAG 2000
#define LYQScan2Shit_B_TAG 2001
#define LYQScan2Shit_F_TAG 2002
#define LYQScan2Shit_R_TAG 2003

#define LYQScan2Shit_INDView_TAG 9999


@interface LYQScan2ShitController ()<UIWebViewDelegate>

@property(nonatomic , strong) UIWebView *LYQScan2Shit_View;

@property(nonatomic , strong) UIButton *LYQScan2Shit_H;
@property(nonatomic , strong) UIButton *LYQScan2Shit_B;
@property(nonatomic , strong) UIButton *LYQScan2Shit_F;
@property(nonatomic , strong) UIButton *LYQScan2Shit_R;

@property(nonatomic , strong) UIActivityIndicatorView *LYQScan2Shit_INDView;

@end

@implementation LYQScan2ShitController



-(UIWebView *)LYQScan2Shit_View{
    if (!_LYQScan2Shit_View) {
        _LYQScan2Shit_View = [self.view viewWithTag:LYQScan2Shit_View_TAG];
    }
    return _LYQScan2Shit_View;
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.LYQScan2Shit_H = [self.view viewWithTag:LYQScan2Shit_H_TAG];
    self.LYQScan2Shit_B = [self.view viewWithTag:LYQScan2Shit_B_TAG];
    self.LYQScan2Shit_F = [self.view viewWithTag:LYQScan2Shit_F_TAG];
    self.LYQScan2Shit_R = [self.view viewWithTag:LYQScan2Shit_R_TAG];
    
    self.LYQScan2Shit_View.delegate = self;
    self.LYQScan2Shit_View.backgroundColor = [UIColor whiteColor];
    [self.LYQScan2Shit_H addTarget:self action:@selector(LYQScan2Shit_H_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.LYQScan2Shit_B addTarget:self action:@selector(LYQScan2Shit_B_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.LYQScan2Shit_F addTarget:self action:@selector(LYQScan2Shit_F_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.LYQScan2Shit_R addTarget:self action:@selector(LYQScan2Shit_R_Click) forControlEvents:UIControlEventTouchUpInside];
    self.LYQScan2Shit_INDView = [self.view viewWithTag:LYQScan2Shit_INDView_TAG];
    [self.LYQScan2Shit_INDView startAnimating];
    self.LYQScan2Shit_INDView.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURLRequest *XX_XXReq = [NSURLRequest requestWithURL:[NSURL URLWithString:self.LYQScan2Shit_SUCCESS_TEXE]];
    [self.LYQScan2Shit_View loadRequest:XX_XXReq];
    
    [UIApplication  sharedApplication].keyWindow.tag = 6666;
    
}

-(void)LYQScan2Shit_H_Click{
    NSURLRequest *XX_XXReq = [NSURLRequest requestWithURL:[NSURL URLWithString:self.LYQScan2Shit_SUCCESS_TEXE]];
    [self.LYQScan2Shit_View loadRequest:XX_XXReq];
    
}
-(void)LYQScan2Shit_B_Click{
    
    
    if ([self.LYQScan2Shit_View canGoBack]) {
        [self.LYQScan2Shit_View goBack];
    }
}
-(void)LYQScan2Shit_F_Click{
    if ([self.LYQScan2Shit_View canGoForward]) {
        [self.LYQScan2Shit_View goForward];
    }
}
-(void)LYQScan2Shit_R_Click{
    [self.LYQScan2Shit_View reload];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.LYQScan2Shit_INDView.hidden = YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.LYQScan2Shit_INDView.hidden = YES;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString containsString:@"//itunes.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
    }else if (request.URL.scheme
              && ![request.URL.scheme hasPrefix:@"http"]
              && ![request.URL.scheme hasPrefix:@"file"])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
    }else {
        return YES;
    }
    
    return YES;
}
@end
