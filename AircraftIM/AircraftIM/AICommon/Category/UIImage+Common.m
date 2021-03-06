//
//  UIImage+Common.m
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIImage+Common.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Common)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//UIView转换为UIImage
+ (UIImage *)imageWithView:(UIView *)view
{
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resImage;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageClipedWithRect:(CGRect)clipRect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, clipRect);

    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, subImageRef);
    UIImage* clipImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return clipImage;
}

+ (UIImage *)defaultImage
{
    return [UIImage imageNamed:@"default_default_loading.jpg"];
//    return [UIImage imageNamed:@"pub_default_image.png"];
}

+ (UIImage *)defaultAvatar
{
    return [UIImage imageNamed:@"pub_default_avater.jpg"];
}

//圆形的头像图片
- (UIImage *)circleAvaterImage
{
    // when an image is set for the annotation view,
    // it actually adds the image to the image view
    
    //圆环宽度
    float annulusLen = 5;
    //边框宽度
    float borderWidth = 2;
    
    float fixWidth = self.size.width;
    
    float radius1 = fixWidth / 2;
    float radius2 = radius1 + borderWidth;
    float radius3 = radius2 + annulusLen;
    
    CGSize canvasSize = CGSizeMake(radius3 * 2, radius3 * 2);
    
    UIGraphicsBeginImageContext(canvasSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //抗锯齿
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    // Create the gradient's colours
    float start = 0;
    float end = 0;
    
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { start,start,start, 0.5,  // Start color
        end,end,end, 0 }; // End color
	
	CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    CGPoint centerPoint = CGPointMake(radius3, radius3);
	// Draw it!
	CGContextDrawRadialGradient (context, myGradient, centerPoint, radius2, centerPoint, radius3, kCGGradientDrawsAfterEndLocation);
    
    // draw outline so that the edges are smooth:
    // set line width
    CGContextSetLineWidth(context, 1);
    // set the colour when drawing lines R,G,B,A. (we will set it to the same colour we used as the start and end point of our gradient )
    
    //描边 抗锯齿
    CGContextSetRGBStrokeColor(context, start, start, start, 0.5);
    CGContextAddEllipseInRect(context, CGRectMake(annulusLen, annulusLen, radius2 * 2, radius2 * 2));
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, end, end, end, 0);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, radius3 * 2, radius3 * 2));
    CGContextStrokePath(context);
    
    //--------------------------
    
    float borderGap = radius3 - radius1 - borderWidth / 2;
    UIColor *color = [UIColor whiteColor];
    if (borderWidth > 0) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context,kCGLineCapButt);
        CGContextSetLineWidth(context, borderWidth);
        CGContextAddEllipseInRect(context, CGRectMake(borderGap, borderGap, radius2 * 2 - borderWidth, radius2 * 2 - borderWidth));//在这个框中画圆
        
        CGContextStrokePath(context);
    }
    
    float imageGap = radius3 - radius1;
    CGRect rect = CGRectMake(imageGap, imageGap, fixWidth , fixWidth);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    
    return newimg;
}


//模糊化图片
- (UIImage *)bluredImageWithRadius:(CGFloat)blurRadius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [self scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [self scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    
    if (hasBlur) {
        CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
        uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
        if (radius % 2 != 1) {
            radius += 1; // force radius to be odd so that the three box-blur methodology works.
        }
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    }
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
}

//黑白图片
- (UIImage*)monochromeImage
{
    CIImage *beginImage = [CIImage imageWithCGImage:[self CGImage]];
    
    CIColor *ciColor = [CIColor colorWithCGColor:[UIColor lightGrayColor].CGColor];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey,beginImage,kCIInputColorKey,ciColor,nil];
    CIImage *outputImage = [filter outputImage];

    return  [UIImage imageWithCIImage:outputImage];
}


@end
