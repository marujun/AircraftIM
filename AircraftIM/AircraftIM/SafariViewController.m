//
//  SafariViewController.m
//  MCFriends
//
//  Created by marujun on 14-5-16.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "SafariViewController.h"

@interface SafariViewController ()

@end

@implementation SafariViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (SafariViewController *)initWithUrl:(NSString *)url
{
    return [self initWithTitle:@"" url:url];
}

+ (SafariViewController *)initWithTitle:(NSString *)title url:(NSString *)url
{
    SafariViewController *safariVC = [[SafariViewController alloc] initWithNibName:nil bundle:nil];
    safariVC.url = url;
    safariVC.title = title;
    return safariVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setNavigationBackButtonDefault];
    
    if ([_url hasSuffix:@".jpg"] || [_url hasSuffix:@".png"]) {
        //加载本地缓存中的图片
        NSString *filePath = [UIImage getImagePathWithURL:_url];
        NSString *jpgPath = [filePath stringByAppendingString:@".jpg"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:jpgPath]) {
            [self startLoadURL:[NSURL fileURLWithPath:jpgPath]];
        }else{
            [activityIndicatorView startAnimating];
            [UIImage imageWithURL:_url callback:^(UIImage *image) {
                [fileManager moveItemAtPath:filePath toPath:jpgPath error:nil];
                [self startLoadURL:[NSURL fileURLWithPath:jpgPath]];
            }];
        }
        return;
    }
    
    if (_url && ![_url hasPrefix:@"http"]) {
        _url = [NSString stringWithFormat:@"http://%@",_url];
    }
    [self startLoadURL:[NSURL URLWithString:_url]];
}

- (void)startLoadURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [commonWebView loadRequest:request];
    [commonWebView setScalesPageToFit:true];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.title || !self.title.length) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    FLOG(@"网页加载失败 Error : %@",error);
}

@end
