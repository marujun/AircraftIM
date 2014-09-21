//
//  MatchParser.h
//  CoreTextMagazine
//
//  Created by marujun on 14-3-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#define BEGIN_TAG @"["
#define END_TAG @"]"

#define MatchParserString @"string"
#define MatchParserRange @"range"
#define MatchParserRects @"rects"
#define MatchParserImage @"image"
#define MatchParserLocation @"location"
#define MatchParserLine @"line"
#define MatchParserLinkType @"lineType"

#define  MatchParserNameTypeUrl @"MatchParserNameTypeUrl"
#define  MatchParserLinkTypeUrl @"MatchParserLinkTypeUrl"
#define  MatchParserLinkTypePhone @"MatchParserLinkTypePhone"
#define  MatchParserLinkTypeMobie   @"MatchParserLinkTypeMobie"
#define  MatchParseAttributeType   @"MatchParseAttributeType"
@interface MatchParser : NSObject
{
    NSMutableArray * _strs;
    
    NSString * _source;
    
    float _height;
    
    id _ctFrame;
    
    int _numberOfTotalLines;
    
    float _heightOflimit;
   
    NSDictionary * faceName;
}

//绘制界面时使用的属性
@property(nonatomic,strong) NSMutableAttributedString * attributedString;
@property(nonatomic,strong) NSArray * images;
@property(nonatomic,strong) NSMutableArray * links;
@property(nonatomic,strong) NSMutableArray * backgroundColorBounds;
@property(nonatomic,assign) BOOL phoneLink;
@property(nonatomic,assign) BOOL mobieLink;
@property(nonatomic,assign) BOOL urlLink;
@property(nonatomic,readonly)  id ctFrame;
@property(nonatomic,readonly)  NSString *source;                //原始内容

//可设置的属性
@property(nonatomic,assign) float lineSpace;                    //行距
@property(nonatomic,assign) float width;                        //宽度
@property(nonatomic,strong) UIFont * font;                      //字体
@property(nonatomic,strong) UIColor * textColor;                //文字颜色
@property(nonatomic,strong) UIColor * highlightedColor;         //网址或电话链接的颜色（默认蓝色）
@property(nonatomic,assign) int numberOfLimitLines;             // 行数限定 (等于0 代表 行数不限) 只能通过行数限制限定高度
//可设置适用于聊天评论中有姓名的情况 类似QQ中得评论
@property(nonatomic,strong)    NSArray * nameRangs;
@property(nonatomic,strong)    UIColor * nameColor;

//可读取的属性
@property(nonatomic,assign) float limitHeight;               // 限定行数后的内容高度
@property(nonatomic,assign) float height;                    // 总内容的高度
@property(nonatomic,assign) float miniWidth;                 //只有一行时，内容宽度



//下面两个方法不能同时使用
-(void)match:(NSString*)text;                                       //普通的文本
-(void)matchAttributedString:(NSMutableAttributedString*)attrString;  //带样式的文本

@end
