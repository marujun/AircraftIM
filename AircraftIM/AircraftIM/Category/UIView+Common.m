//
//  UIView+Common.m
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (void)removeAllSubview
{
    for (UIView *item in self.subviews) {
        [item removeFromSuperview];
    }
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

+ (UIView *)titileViewWithTitle:(NSString *)title activity:(BOOL)activity
{
    UILabel *bigLabel = [[UILabel alloc] init];
    bigLabel.text = title;
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.textColor = [UIColor blackColor];
    bigLabel.font = [UIFont boldSystemFontOfSize:17];
    bigLabel.adjustsFontSizeToFitWidth = YES;
    [bigLabel sizeToFit];
    
    CGRect rect = bigLabel.frame;
    UIView *titleView = [[UIView alloc] initWithFrame:rect];
    titleView.backgroundColor = [UIColor clearColor];
    
    if (activity) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        CGRect activityRect = activityView.bounds;
        activityRect.origin.y = (rect.size.height-activityRect.size.height)/2;
        activityView.frame = activityRect;
        [titleView addSubview:activityView];
        
        rect.origin.x = activityRect.size.width+5;
        bigLabel.frame = rect;
    }
    [titleView addSubview:bigLabel];
    
    CGRect titleFrame = CGRectMake(0, 0, 0, rect.size.height);
    titleFrame.size.width = rect.origin.x+rect.size.width;
    titleView.frame = titleFrame;
    
    return titleView;
}

+ (UIView *)titileViewWithTitle:(NSString *)title image:(UIImage *)image
{
    UILabel *bigLabel = [[UILabel alloc] init];
    bigLabel.text = title;
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.textColor = [UIColor blackColor];
    bigLabel.font = [UIFont boldSystemFontOfSize:17];
    bigLabel.adjustsFontSizeToFitWidth = YES;
    [bigLabel sizeToFit];
    
    CGRect rect = bigLabel.frame;
    UIView *titleView = [[UIView alloc] initWithFrame:rect];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:bigLabel];
    
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect imageRect = CGRectMake(0, 0, 15, 15);
        imageRect.origin.x = rect.size.width+rect.origin.x+3;
        imageRect.origin.y = (rect.size.height-imageRect.size.height)/2;
        imageRect.size.width = image.size.width/(image.size.height/imageRect.size.height);
        imageView.frame = imageRect;
        [titleView addSubview:imageView];
        
        CGRect titleFrame = CGRectMake(0, 0, 0, rect.size.height);
        titleFrame.size.width = imageRect.origin.x+imageRect.size.width;
        titleView.frame = titleFrame;
    }
    
    return titleView;
}

//添加动画遮罩 并在duration秒之后移除
- (void)addMaskViewWithDuration:(float)duration
{
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    [self addSubview:maskView];
    [maskView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration];
    
}


#pragma mark - 获取父 viewController
- (UIViewController *)nearsetViewController
{
    UIViewController *viewController = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController*)nextResponder;
            break;
        }
    }
    return viewController;
}

@end
