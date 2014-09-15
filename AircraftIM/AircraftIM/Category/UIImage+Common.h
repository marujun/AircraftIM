//
//  UIImage+Common.h
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage *)defaultImage;
+ (UIImage *)defaultAvatar;
- (UIImage *)circleAvaterImage;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithView:(UIView *)view;
- (UIImage *)imageScaledToSize:(CGSize)newSize;
- (UIImage *)imageClipedWithRect:(CGRect)clipRect;

//模糊化图片
- (UIImage *)bluredImageWithRadius:(CGFloat)blurRadius;

//黑白图片
- (UIImage*)monochromeImage;

@end
