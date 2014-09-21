//
//  BaseTableCell.m
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "BaseTableCell.h"

@interface BaseTableCell ()
{
    UIWebView * phoneCallWebView ;
}

@end

static NSMutableDictionary *matchParserUtil;

@implementation BaseTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initWithData:(id)data indexPath:(NSIndexPath *)indexPath
{
    _dataInfo = data;
    _indexPath = indexPath;
    
    [self updateDisplay];
}

- (void)updateDisplay
{
    
}

+ (CGFloat)heightWithData:(id)data
{
    return 44;
}

#pragma mark - 获取父 ScrollView
- (UIScrollView *)nearsetScrollView
{
    UIScrollView *scrollView = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIScrollView class]]) {
            if (![[(UIScrollView *)nextResponder superview] isKindOfClass:[UITableViewCell class]]) {
                scrollView = (UIScrollView *)nextResponder;
                break;
            }
        }
    }
    return scrollView;
}

+ (MatchParser *)matchText:(NSString *)text width:(float)width
{
    float fontSize = 15;
    
    matchParserUtil = matchParserUtil?:[NSMutableDictionary dictionary];
    NSString *key = [[NSString stringWithFormat:@"%@%f%f",text,width,fontSize] md5];
    
    MatchParser *match = matchParserUtil[key];
    if (!match) {
        match = [[MatchParser alloc]init];
        match.width = width;
        match.font = [UIFont systemFontOfSize:fontSize];
        [match match:text];
        @synchronized(matchParserUtil) {
            [matchParserUtil setObject:match forKey:key];
        }
    }
    
    return match;
}

#pragma mark - HBCoreLabelDelegate
- (void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr
{
    FLOG(@"网址： %@",linkStr);
    SafariViewController *vc = [SafariViewController initWithUrl:linkStr];
    [self.nearsetViewController.navigationController pushViewController:vc animated:true];
}
- (void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr
{
    [self coreLabel:coreLabel phoneClick:linkStr];
}
- (void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr
{
    FLOG(@"电话号码： %@",linkStr);
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%@可能是个电话",linkStr]
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"呼叫",@"复制",nil];
    [action showInView:KeyWindow complete:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",linkStr]];
            if ( !phoneCallWebView ) {
                phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        }else if (buttonIndex == 1){
            @try {
                [UIPasteboard generalPasteboard].string = linkStr;
            }
            @catch (NSException *exception) {}
        }
    }];
}

@end
