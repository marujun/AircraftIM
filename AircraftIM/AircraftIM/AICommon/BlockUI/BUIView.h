//
//  BUIView.h
//  sample
//
//  Created by 张玺 on 12-9-10.
//  Copyright (c) 2012年 张玺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@interface UIView(BUIView) <UIAlertViewDelegate,UIActionSheetDelegate>

//UIAlertView
-(void)showWithCompletionBlock:(void (^)(NSInteger buttonIndex))completionBlock;

//UIActionSheet
-(void)showInView:(UIView *)view complete:(void (^)(NSInteger buttonIndex))complete;
-(void)showFromToolbar:(UIToolbar *)view complete:(void (^)(NSInteger buttonIndex))complete;
-(void)showFromTabBar:(UITabBar *)view complete:(void (^)(NSInteger buttonIndex))complete;
-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated complete:(void (^)(NSInteger buttonIndex))complete;
-(void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated complete:(void (^)(NSInteger buttonIndex))complete;

//注意： 必须使用weakSelf : __weak typeof(self) weakSelf = self;
- (void)setTapActionWithBlock:(void (^)(void))block;

@end