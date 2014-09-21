//
//  ChatListTableCell.m
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "ChatListTableCell.h"

@implementation ChatListTableCell

- (void)awakeFromNib
{
    _unreadLabel.layer.cornerRadius = 10;
    _unreadLabel.clipsToBounds = YES;
    _unreadLabel.backgroundColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (!_unreadLabel.hidden) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (!_unreadLabel.hidden) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)updateDisplay
{
    EMConversation *conversation = self.dataInfo;
    
    int unReadCount = [self unreadCountByConversation:conversation];
    if (unReadCount) {
        _unreadLabel.hidden = false;
        _unreadLabel.text = [NSString stringWithFormat:@"%d",unReadCount];
    }else{
        _unreadLabel.hidden = true;
    }
    
    _nameLabel.text = conversation.chatter;
    _detailLabel.text = [self subTitleByConversation:conversation];
    _timeLabel.text = [self lastTimeByConversation:conversation];
}

// 得到最后消息时间
- (NSString *)lastTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        
        ret = [date stringWithDateFormat:@"HH:mm"];
    }
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
- (NSString *)subTitleByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            }
                break;
            case eMessageBodyType_Text:{
                ret = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Voice:{
                ret = @"[声音]";
            }
                break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            }
                break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            }
                break;
            default:
                break;
        }
    }
    
    return ret;
}

@end
