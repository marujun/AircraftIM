//
//  BaseTableCell.h
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCoreLabel.h"
#import "SafariViewController.h"

@interface BaseTableCell : UITableViewCell

@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong) id dataInfo;

- (void)updateDisplay;
+ (CGFloat)heightWithData:(id)data;
- (UIScrollView *)nearsetScrollView;
- (void)initWithData:(id)data indexPath:(NSIndexPath *)indexPath;

+ (MatchParser *)matchText:(NSString *)text width:(float)width;

@end
