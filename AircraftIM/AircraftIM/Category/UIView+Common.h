//
//  UIView+Common.h
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KeyboardAnimationCurve  (IS_IOS_7?7:0) << 16
#define KeyboardAnimationDuration  0.25

@interface UIView (Common)

//移除所有的子视图
- (void)removeAllSubview;

//添加动画遮罩 并在duration秒之后移除
- (void)addMaskViewWithDuration:(float)duration;

//标题View（是否loadingView）
+ (UIView *)titileViewWithTitle:(NSString *)title activity:(BOOL)activity;

//标题View（带图片）
+ (UIView *)titileViewWithTitle:(NSString *)title image:(UIImage *)image;

- (UIViewController *)nearsetViewController;
- (UIView *)findFirstResponder;

@end
