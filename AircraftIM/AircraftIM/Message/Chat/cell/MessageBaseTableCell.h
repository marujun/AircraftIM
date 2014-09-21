//
//  MessageBaseTableCell.h
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "BaseTableCell.h"

@class MessageTextTableCell;
@class MessageTimeTableCell;
@class MessageImageTableCell;
@class MessageAudioTableCell;

@interface MessageBaseTableCell : BaseTableCell

+ (Class)classByObject:(id)obj;

@end
