//
//  ChatListTableCell.h
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListTableCell : BaseTableCell
{
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_unreadLabel;
    __weak IBOutlet UILabel *_detailLabel;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UIImageView *avatarImageView;
}

@end
