//
//  MacroToolHeader.h
//  HLMagic
//
//  Created by chen ying on 13-10-6.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//



#ifndef HLMagic_MacroToolHeader_h
#define HLMagic_MacroToolHeader_h


#ifdef DEBUG
#define FLOG(fmt,...)    NSLog((@"[%@][%d] " fmt),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,##__VA_ARGS__)
#else
#define FLOG(str, args...) ((void)0)
#endif

#define ShortSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_6 (ShortSystemVersion < 7)
#define IS_IOS_7 (ShortSystemVersion >= 7 && ShortSystemVersion < 8)
#define IS_IOS_8 (ShortSystemVersion >= 8)
#define radians(degrees)  (degrees)*M_PI/180.0f

#define WINDOW_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width

#define userDefaults     [NSUserDefaults standardUserDefaults]
#define KeyWindow        [[[UIApplication sharedApplication] delegate] window]

#define DocumentPath        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]    //获取Document文件夹的路径
#define ResourcePath        [[NSBundle mainBundle] resourcePath]    //获取自定义文件的bundle路径
#define ImageNamed(name)    [UIImage imageWithContentsOfFile:[ResourcePath stringByAppendingPathComponent:name]]
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]         //RGB进制颜色值
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]       //RGBA进制颜色值
#define HexColor(hexValue)  [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1.0]   //16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000



//获取随机数
#define Random(from, to) (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
#define ARC4RANDOM_MAX (0x100000000 * 20)

//弹出简单警告
#define AlertMessage(alertString) [[[UIAlertView alloc] initWithTitle:nil message:alertString delegate:nil cancelButtonTitle:@"关闭"  otherButtonTitles: nil] show];



#endif
