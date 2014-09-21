//
//  RootViewController.m
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "RootViewController.h"
#import "ChatListViewController.h"

@interface RootViewController ()
{
    UINavigationController *rootNavigationController;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ChatListViewController *listViewController = [[ChatListViewController alloc] initWithNibName:nil bundle:nil];
    rootNavigationController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    [self addChildViewController:rootNavigationController];
    [self.view addSubview:rootNavigationController.view];
    
    rootNavigationController.interactivePopGestureRecognizer.delegate = self;
    [rootNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [XmppManager loginWithUsername:@"18612191103"
                          password:@"111111"
                        completion:^(NSDictionary *loginInfo, EMError *error) {
                            [listViewController refreshDataSource];
                        }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

@end
