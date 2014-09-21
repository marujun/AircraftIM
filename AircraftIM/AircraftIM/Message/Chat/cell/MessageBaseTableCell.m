//
//  MessageBaseTableCell.m
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MessageBaseTableCell.h"
#import "MessageTextTableCell.h"
#import "MessageImageTableCell.h"
#import "MessageAudioTableCell.h"
#import "MessageTimeTableCell.h"

@implementation MessageBaseTableCell

- (void)updateDisplay
{
    //测试用
    EMMessage *msg = (EMMessage *)self.dataInfo;
    EMTextMessageBody *messageBody = msg.messageBodies.lastObject;
    
    self.textLabel.text = messageBody.text;
}


+ (Class)classByObject:(id)obj
{
    Class class = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        return [MessageTimeTableCell class];
    }else{
        id<IEMMessageBody> messageBody = ((EMMessage *)obj).messageBodies.lastObject;
        
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                class = [MessageImageTableCell class];
                break;
            }
            case eMessageBodyType_Text:{
                class = [MessageTextTableCell class];
                break;
            }
            case eMessageBodyType_Voice:{
                class = [MessageAudioTableCell class];
                break;
            }
            default:
                break;
        }
    }
    
    return class;
}

@end
