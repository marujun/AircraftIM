//
//  MatchParser.m
//  CoreTextMagazine
//
//  Created by marujun on 14-3-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MatchParser.h"

@interface MatchParser ()
{
    NSString* _platText;
}

@property(nonatomic) float iconWidth;           // 表情Size
@property(nonatomic) float iconHeight;

@end


@implementation MatchParser
@synthesize attributedString,images,font,textColor,highlightedColor,iconWidth,ctFrame=_ctFrame,height=_height,width,source=_source,miniWidth=_miniWidth;

-(id)init
{
    self=[super init];
    if(self){
        _strs=[[NSMutableArray alloc]init];
        self.font=[UIFont systemFontOfSize:14];
        self.textColor=[UIColor blackColor];
        self.highlightedColor=RGBCOLOR(7, 73, 209);
        self.iconWidth=16.0f;
        self.lineSpace=5.0f;
        self.limitHeight = 6*WINDOW_HEIGHT;
        self.mobieLink=YES;
        self.urlLink=YES;
        self.phoneLink=YES;
        self.nameColor = RGBCOLOR(10, 76, 113);
        faceName = [[NSDictionary alloc] initWithDictionary:[MatchParser getFaceNameMap]];
    }
    return self;
}


+(NSDictionary*)getFaceMap
{
    static NSDictionary * dic=nil;
    if(dic==nil){
        NSString* path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
        dic =[NSDictionary dictionaryWithContentsOfFile:path];
    }
    return dic;
}
+(NSDictionary*)getFaceNameMap
{
    static NSDictionary * dic=nil;
    NSMutableDictionary *faceName = [[NSMutableDictionary alloc]init];
    if(dic==nil){
        NSString* path=[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
        dic =[NSDictionary dictionaryWithContentsOfFile:path];
    }
    for (NSString*key in dic.allKeys) {
        [faceName setValue:key forKey:[dic objectForKey:key]];
    }
    return faceName;
}
+(NSString*)faceKeyForValue:(NSString*)value  map:(NSDictionary*) map
{
    NSArray * keys=[map allKeys];
    int count=[keys count];
    for(int i=0;i<count;i++)
    {
        NSString * key=[keys objectAtIndex:i];
        if([[map objectForKey:key] isEqualToString:value])
            return key;
    }
    return nil;
}
-(void)matchAttributedString:(NSMutableAttributedString*)attrString
{
    attributedString = attrString;
    _source =_platText = [attrString string];
    [self setLimitFitHeight];
    
    if (attributedString && _nameRangs.count) {
        NSDictionary *attributesNameClearColor = @{ NSForegroundColorAttributeName: _nameColor};
        for (NSString * rangStr in _nameRangs) {
            NSRange range = NSRangeFromString(rangStr);
            if (range.length <= _source.length) {
                [attributedString addAttributes:attributesNameClearColor range:range];
                // 设置自定义属性，绘制的时候需要用到
                [attributedString addAttribute:MatchParseAttributeType value:[NSNumber numberWithInt:10] range:range];
                [attributedString addAttribute:MatchParserRange value:[NSValue valueWithRange:range] range:range];
                NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[_source substringWithRange:range],MatchParserString,[NSValue valueWithRange:range],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserNameTypeUrl,MatchParserLinkType,nil];
                if (!_links) {
                    _links = [[NSMutableArray alloc]init];
                }
                if (!_backgroundColorBounds) {
                    _backgroundColorBounds = [[NSMutableArray alloc]init];
                }
                [_links removeAllObjects];
                [_links addObject:dic];
            }
            
        }
    }

    _limitHeight = _height;
    [self match:_source];
}

- (CGFloat)heightMatch:(NSString*)source
{
    CGSize size = [@"回" sizeWithFont:font];
    self.iconWidth = size.width ;
    self.iconHeight = size.height;
    
    if(source==nil||[source length]==0)
        
        return 0;
    _source=source;
    
    NSMutableString * plainText=[[NSMutableString alloc]init];
    NSMutableArray * imageArr=[[NSMutableArray alloc]init];
    _links=[[NSMutableArray alloc]init];
    _backgroundColorBounds = [[NSMutableArray alloc]init];
    NSRegularExpression * regular=[[NSRegularExpression alloc]initWithPattern:@"\\[[^\\[\\]\\s]+\\]" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * array = [regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    int count = [array count];
    NSInteger sourceLocation = 0;
    for(int i = 0; i < count; i++) {
        NSTextCheckingResult * result = array[i];
        NSRange resultRange = result.range;
        [plainText appendString:[source substringWithRange:NSMakeRange(sourceLocation, resultRange.location - sourceLocation)]];//表情字符串之间的普通文本字符
        
        NSString * string=[source substringWithRange:resultRange];
        NSString * icon=[faceName objectForKey:string];
        if(icon != nil) {
            NSString * iconStr=[NSString stringWithFormat:@"%@.png",icon];
            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            dic[MatchParserImage] = iconStr;
            dic[MatchParserLocation] = @([plainText length]);
            dic[MatchParserRects] = [NSNull null];
            
            [imageArr addObject:dic];
            [plainText appendString:@"回"];//空格用于给图片留位置
        }else{
            //如果找不到该表情对应的图片文件名字，不解析该表情
            [plainText appendString:string];
        }
        
        sourceLocation = resultRange.location + resultRange.length;
    }
    [plainText appendString:[source substringFromIndex:sourceLocation]];//剩余的普通文本字符
    
    NSDictionary *attributes = @{NSFontAttributeName: self.font, NSForegroundColorAttributeName: self.textColor};
    NSMutableAttributedString * attStr=[[NSMutableAttributedString alloc]initWithString:plainText attributes:attributes];
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    
    CGFloat lineSpace=self.lineSpace;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    //创建样式数组
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,lineSpaceStyle
    };
    
    //设置样式
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 2);
    NSMutableDictionary *styleAttributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    NSDictionary *attributesClearColor_1 = @{NSForegroundColorAttributeName: [UIColor clearColor],NSStrokeWidthAttributeName:[NSNumber numberWithFloat:0],NSKernAttributeName:[NSNumber numberWithFloat:3]};
    [attStr addAttributes:styleAttributes range:NSMakeRange(0, [plainText length])];
    for(NSDictionary * dic in imageArr) {
        NSInteger location= [dic[MatchParserLocation] integerValue];
        [attStr addAttributes:attributesClearColor_1 range:NSMakeRange(location, 1)];
    }
    
    if (_nameRangs.count > 0) {
        NSDictionary *attributesNameClearColor = @{ NSForegroundColorAttributeName: _nameColor};
        for (NSString * rangStr in _nameRangs) {
            NSRange range = NSRangeFromString(rangStr);
            if (range.length <= source.length) {
                [attStr addAttributes:attributesNameClearColor range:range];
                // 设置自定义属性，绘制的时候需要用到
                [attStr addAttribute:MatchParseAttributeType value:[NSNumber numberWithInt:10] range:range];
                [attStr addAttribute:MatchParserRange value:[NSValue valueWithRange:range] range:range];
                NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:[source substringWithRange:range],MatchParserString,[NSValue valueWithRange:range],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserNameTypeUrl,MatchParserLinkType,nil];
                [_links addObject:dic];
            }
            
        }
    }
    self.attributedString=attStr;
    self.images=imageArr;
    _platText = plainText;
    [self setLimitFitHeight];
    CFRelease(style);
    
    _limitHeight = _height;
    
    return _height;
}

- (void)setLimitFitHeight
{
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectMake(0,0, width, _limitHeight);
    CGPathAddRect(path, NULL, textFrame);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)self.attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);

    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame); //1
    NSUInteger const lineCount = [lines count];
    CGPoint origins[lineCount];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins); //2
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
    //  获取限定行数后内容的高度
    if (_numberOfLimitLines<= lineCount && _numberOfLimitLines != 0) {
        CTLineRef line1=(__bridge CTLineRef)(lines[_numberOfLimitLines-1]);
        float line_y = (float) origins[_numberOfLimitLines -1].y;  //最后一行line的原点y坐标
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineGetTypographicBounds(line1, &ascent, &descent, &leading);
        float total_height =_limitHeight- line_y + descent+1 ;    //+1为了纠正descent转换成int小数点后舍去的值
        _height = total_height;
        return ;
    }
    //#pragma -mark 获得内容的总高度
    if(lineCount > 0) {
        float line_y = (float) origins[lineCount -1].y;  //最后一行line的原点y坐标
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineRef line1 = (__bridge CTLineRef) [lines lastObject];
        CTLineGetTypographicBounds(line1, &ascent, &descent, &leading);
        float total_height = _limitHeight- line_y + descent+1;    //+1为了纠正descent转换成int小数点后舍去的值
        
        if (_limitHeight < total_height +30) {
            _limitHeight += 10*WINDOW_HEIGHT;
            [self setLimitFitHeight];
        }else
        {
            _height=total_height;
        }
    } else {
        _height = 0;
    }
    
}
/*! 解析表情 生成数据结构 */
-(void)match:(NSString*)source
{
    if(source==nil||[source length]==0){
        return ;
    }
//    NSDate *date = [NSDate date];
    
    if (!attributedString) {
        [self heightMatch:source];
    }
    
    NSDictionary *attributesClearColor_1 = @{ NSForegroundColorAttributeName: [UIColor clearColor],NSStrokeWidthAttributeName: [NSNumber numberWithFloat:3.0],NSKernAttributeName:[NSNumber numberWithFloat:3]};
    NSDictionary *attributesClearColor_2 = @{ NSForegroundColorAttributeName:[UIColor clearColor],NSStrokeWidthAttributeName: [NSNumber numberWithFloat:3.1],NSKernAttributeName:[NSNumber numberWithFloat:3]};
    int index = 0;
    for(NSDictionary * dic in self.images) {
        index ++ ;
        NSInteger location= [dic[MatchParserLocation] integerValue];
        if (index%2) {
            [self.attributedString addAttributes:attributesClearColor_2 range:NSMakeRange(location, 1)];
        }else
        {
            [self.attributedString addAttributes:attributesClearColor_1 range:NSMakeRange(location, 1)];
        }
    }
    
    if(self.urlLink){
        [self matchUrlLink:_platText attrString:self.attributedString offset:0 link:nil];
    }
    if(self.mobieLink){
        [self matchMobieLink:_platText attrString:self.attributedString offset:0 link:nil];
    }
    if(self.phoneLink){
        [self matchPhoneLink:_platText attrString:self.attributedString offset:0 link:nil];
    }
    
   
    [self buildFrames];
    
//    FLOG(@"match = %f",[[NSDate date] timeIntervalSinceDate:date]);
}

#pragma -mark 私有方法
-(void)buildFrames
{
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectMake(0,0, width, _limitHeight);
    CGPathAddRect(path, NULL, textFrame);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame); //1
    NSUInteger const lineCount = [lines count];
    CGPoint origins[lineCount];
    _numberOfTotalLines = lineCount;
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins); //2
    
    CFRelease(path);
    CFRelease(framesetter);
    lines = (__bridge NSArray *)CTFrameGetLines(frame); //1
    CGPoint Origins[lineCount];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), Origins); //2
    //#pragma -mark 获取内容行数 以及 一行时，内容的宽度
    _numberOfTotalLines=lineCount;
    if(_numberOfTotalLines>1){
        _miniWidth = self.width;
    }else{
        CTLineRef lineOne=(__bridge CTLineRef)lines[0];
        _miniWidth=CTLineGetTypographicBounds(lineOne, nil, nil, nil);
    }
    
    //解析 背景颜色
    for (CFIndex i = 0; i < lineCount; ++i) {
        CTLineRef line = (__bridge CTLineRef) (lines[i]);
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        for (CFIndex j = 0; j < CFArrayGetCount(runs); ++j) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary *attDic = (__bridge NSDictionary *)CTRunGetAttributes(run);
            NSNumber *num = [attDic objectForKey:MatchParseAttributeType];
            NSValue *value =[attDic objectForKey:MatchParserRange];
            
            if ([num intValue] == 10) {
                CGRect runBounds;
                CGFloat ascent;
                CGFloat descent;
                CGFloat leading;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
                runBounds.size.height = ascent + descent + self.lineSpace ;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringIndicesPtr(run)[0], NULL);
                runBounds.origin.x =  origins[i].x + xOffset;
                runBounds.origin.y = origins[i].y - descent - self.lineSpace/2;
                NSMutableDictionary * dicTemp=[NSMutableDictionary dictionaryWithObjectsAndKeys:value,MatchParserRange,NSStringFromCGRect(runBounds),MatchParserRects,nil];
                [_backgroundColorBounds addObject:dicTemp];
            }
        }
    }
#pragma -mark  解析表情图片
    NSUInteger imgCount = self.images.count;
    for (NSInteger imgIndex = 0; imgIndex < imgCount; ++imgIndex) {
        
        NSMutableDictionary *tmpImageDic = self.images[imgIndex];
        
        NSRange tmpImageLocation = NSMakeRange([tmpImageDic[MatchParserLocation] integerValue], 1);
        
        
        BOOL hasFind = NO;
        for (NSInteger lineIndex = 0; lineIndex < lineCount; ++lineIndex) {
            
            CTLineRef tmpLine = (__bridge CTLineRef)lines[lineIndex];
            NSArray *tmpRuns = (__bridge NSArray *)CTLineGetGlyphRuns(tmpLine);
            
            NSUInteger runCount = tmpRuns.count;
            for (NSInteger runIndex = 0; runIndex < runCount; ++runIndex) {
                CTRunRef run = (__bridge CTRunRef)tmpRuns[runIndex];
                CFRange runRange = CTRunGetStringRange(run);
                if (runRange.location == tmpImageLocation.location) {
                    
                    CGRect runBounds = CGRectMake(0, 0, _iconHeight ,_iconHeight);
                    
                    CGPoint point;
                    CTRunGetPositions(run, CFRangeMake(0, 1), &point);
                    runBounds.origin.x = point.x+Origins[lineIndex].x;
                    runBounds.origin.y = point.y+Origins[lineIndex].y- (_iconHeight - iconWidth + 1);
                    tmpImageDic[MatchParserRects] = [NSValue valueWithCGRect:runBounds];
                    tmpImageDic[MatchParserLine] = [NSNumber numberWithInt:lineIndex];
                    hasFind = YES;
                    
                    break;
                }
            }
            
            if (hasFind) {
                break;
            }
        }
    }
    
#pragma -mark  解析网址链接
    
    // 解析网址链接
    if([self.links count]>0){
        int linkIndex = 0; //3
        
        self.links = [[self.links sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSValue *value1 = [obj1 objectForKey:MatchParserRange];
            NSValue *value2 = [obj2 objectForKey:MatchParserRange];
            NSComparisonResult result = NSOrderedSame;
            if (value1.rangeValue.location < value2.rangeValue.location) {
                result = NSOrderedAscending;
            } else if (value1.rangeValue.location > value2.rangeValue.location) {
                result = NSOrderedDescending;
            }
            return result;
        }] mutableCopy];
        
        NSDictionary* nextLink = [self.links objectAtIndex:linkIndex];
        NSRange linkRange =[[nextLink objectForKey:MatchParserRange] rangeValue];
        int lineIndex = 0;
        for (id lineObj in lines) { //5
            CTLineRef line1 = (__bridge CTLineRef)lineObj;
            for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line1)) { //6
                CTRunRef run = (__bridge CTRunRef)runObj;
                CFRange runRange = CTRunGetStringRange(run);
                if ( runRange.location>=linkRange.location&&runRange.location<= (linkRange.location+linkRange.length)) { //7
                    CGRect runBounds;
                    
                    CGFloat ascent;
                    CGFloat descent;
                    
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL) + self.lineSpace; //8
                    
                    runBounds.size.height = ascent + descent + self.lineSpace;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line1, CTRunGetStringRange(run).location, NULL); //9
                    runBounds.origin.x = Origins[lineIndex].x  + xOffset ;
                    runBounds.origin.y = Origins[lineIndex].y ;
                    runBounds.origin.y = _limitHeight-runBounds.origin.y-runBounds.size.height;
                    
                    //      NSLog(@"poing x: %f, y:%f",point.x,point.y);
                    NSMutableDictionary * dic=[self.links objectAtIndex:linkIndex];
                    NSMutableArray * rects=[dic objectForKey:MatchParserRects];
                    [rects addObject:[NSValue valueWithCGRect:runBounds]];
                    
                    //load the next image //12
                    if((runRange.location+runRange.length)>=(linkRange.location+linkRange.length)){
                        linkIndex++;
                        if (linkIndex < [self.links count]) {
                            nextLink = [self.links objectAtIndex: linkIndex];
                            linkRange = [[nextLink objectForKey: MatchParserRange] rangeValue];
                        }else{
                            _ctFrame=(__bridge id)frame;
                            CFRelease(frame);
                            return;
                        }
                    }
                }
            }
            lineIndex++;
        }
    }
    
    _ctFrame=(__bridge id)frame;
    CFRelease(frame);
    
}

//匹配网址
-(void)matchUrlLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(int)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        NSRange range = NSMakeRange(result.range.location+offset,result.range.length);
        if(link==nil){
            NSDictionary *attributesClearColor = @{ NSForegroundColorAttributeName:highlightedColor};
            [attrString1 addAttributes:attributesClearColor range:NSMakeRange(result.range.location+offset,result.range.length)];
            // 设置自定义属性，绘制的时候需要用到
            [attrString1 addAttribute:MatchParseAttributeType value:[NSNumber numberWithInt:10] range:range];
            [attrString1 addAttribute:MatchParserRange value:[NSValue valueWithRange:range] range:range];
        }else{
            link(attrString1,range);
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,MatchParserString,[NSValue valueWithRange:range],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserLinkTypeUrl,MatchParserLinkType,nil];
        [_links addObject:dic];
    }
}

//匹配手机号
-(void)matchMobieLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(int)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"((\\+86)|(86))?(13[0-9]|15[0-9]|18[0-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        NSRange range = NSMakeRange(result.range.location+offset,result.range.length);
        if(link==nil){
            for (NSDictionary *item in _links) {
                NSRange tempRange = [item[MatchParserRange] rangeValue];
                if (range.location > tempRange.location && range.location < (tempRange.location+tempRange.length)) {
                    return;
                }
            }
            NSDictionary *attributesClearColor = @{ NSForegroundColorAttributeName:highlightedColor};
            [attrString1 addAttributes:attributesClearColor range:NSMakeRange(result.range.location+offset,result.range.length)];
            // 设置自定义属性，绘制的时候需要用到
            [attrString1 addAttribute:MatchParseAttributeType value:[NSNumber numberWithInt:10] range:range];
            [attrString1 addAttribute:MatchParserRange value:[NSValue valueWithRange:range] range:range];
        }else{
            link(attrString1,range);
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,MatchParserString,[NSValue valueWithRange:range],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserLinkTypeMobie,MatchParserLinkType,nil];
        [_links addObject:dic];
    }
}

//匹配座机号
-(void)matchPhoneLink:(NSString*)source attrString:(NSMutableAttributedString*)attrString1 offset:(int)offset link:(void(^)(NSMutableAttributedString*attrString,NSRange range))link
{
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\(0\\d{2,3}\\)|0\\d{2,3}-|\\s)?[2-9]\\d{6,7}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array=[regular matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    for( NSTextCheckingResult * result in array){
        NSRange range = NSMakeRange(result.range.location+offset,result.range.length);
        if(link==nil){
            for (NSDictionary *item in _links) {
                NSRange tempRange = [item[MatchParserRange] rangeValue];
                if (range.location > tempRange.location && range.location < (tempRange.location+tempRange.length)) {
                    return;
                }
            }
            NSDictionary *attributesClearColor = @{ NSForegroundColorAttributeName:highlightedColor};
            [attrString1 addAttributes:attributesClearColor range:NSMakeRange(result.range.location+offset,result.range.length)];
            // 设置自定义属性，绘制的时候需要用到
            [attrString1 addAttribute:MatchParseAttributeType value:[NSNumber numberWithInt:10] range:range];
            [attrString1 addAttribute:MatchParserRange value:[NSValue valueWithRange:range] range:range];
        }else{
            link(attrString1,range);
        }
        NSString * string=[source substringWithRange:result.range];
        NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:string,MatchParserString,[NSValue valueWithRange:range],MatchParserRange,[[NSMutableArray alloc]init],MatchParserRects,MatchParserLinkTypePhone,MatchParserLinkType,nil];
        [_links addObject:dic];
    }
}


@end
