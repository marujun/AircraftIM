//
//  SafariViewController.h
//  MCFriends
//
//  Created by marujun on 14-5-16.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafariViewController : UIViewController<UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *commonWebView;
    __weak IBOutlet UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic, strong) NSString *url;

+ (SafariViewController *)initWithUrl:(NSString *)url;
+ (SafariViewController *)initWithTitle:(NSString *)title url:(NSString *)url;

@end
