//
//  ChatViewController.m
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageTimeTableCell.h"
#import "MessageBaseTableCell.h"

#define KPageCount 20

@interface ChatViewController ()
{
    dispatch_queue_t _messageQueue;
    NSMutableArray *_dataSource;
    
    NSDate *_chatTagDate;
}

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newMessage:)
                                                     name:kNewMessageNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _conversation.chatter;
    _dataSource = [NSMutableArray array];
    _messageQueue = dispatch_queue_create("chat.witmob.com", NULL);
    
    [self fetchDataAsync:true complete:^{
        //
    }];
}

//新消息
- (void)newMessage:(NSNotification *)note
{
    EMMessage *message = note.object;
    if (!message) {
        message = note.userInfo[@"send"];
        for (int i = 0; i < _dataSource.count; i ++) {
            EMMessage *item = [_dataSource objectAtIndex:i];
            if ([message.messageId isEqualToString:item.messageId]) {
                [_tableView beginUpdates];
                [_dataSource replaceObjectAtIndex:i withObject:item];
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationNone];
                [_tableView endUpdates];
                
                break;
            }
        }
    }else if ([_conversation.chatter isEqualToString:message.conversation.chatter]){
        NSMutableArray *messages = [@[message] mutableCopy];
        NSMutableArray *indexPaths = [@[[NSIndexPath indexPathForRow:0 inSection:0]] mutableCopy];
        
        NSString *time = [self timeStringWithStamp:message.timestamp];
        if (time) {
            [messages addObject:time];
            [indexPaths addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
        }
        
        for (id obj in messages) {
            [_dataSource insertObject:obj atIndex:0];
        }
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markMessagesAsRead:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markMessagesAsRead:YES];
}

//通过会话管理者获取已收发消息(是否使用异步方式)
- (void)fetchDataAsync:(BOOL)async complete:(void (^)(void))complete
{
    void(^loadBlock)(void) = ^(void){
        NSInteger currentCount = [_dataSource count];
        EMMessage *latestMessage = [_conversation latestMessage];
        NSTimeInterval beforeTime = 0;
        if (latestMessage) {
            beforeTime = latestMessage.timestamp + 1;
        }else{
            beforeTime = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
        }
        
        NSArray *chats = [_conversation loadNumbersOfMessages:(currentCount + KPageCount)
                                                       before:beforeTime];
        if ([chats count] > currentCount) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[self sortChatSource:chats]];
        }
    };
    void(^completeBlock)(void) = ^(void){
        [_tableView reloadData];
        
        complete?complete():nil;
    };
    
    if (async) {
        dispatch_async(_messageQueue, ^{
            loadBlock();
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock();
            });
        });
    }else{
        loadBlock();
        completeBlock();
    }
}

- (NSArray *)sortChatSource:(NSArray *)array
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (array && [array count] > 0) {
        for (EMMessage *message in array) {
            [resultArray insertObject:message atIndex:0];
            
            NSString *time = [self timeStringWithStamp:message.timestamp];
            if (time) {
                [resultArray insertObject:time atIndex:0];
            }
        }
    }
    
    return resultArray;
}

- (NSString *)timeStringWithStamp:(double)timestamp
{
    NSDate *createDate = [NSDate dateWithTimeStamp:timestamp];
    
    _chatTagDate = _chatTagDate?:[NSDate dateWithTimeStamp:0];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:_chatTagDate];
    
    NSString *string =nil;
    if (tempDate > 60 || tempDate < -60) {
        string = [MessageTimeTableCell stringWithDate:createDate];
    }
    _chatTagDate = createDate;
    
    return string;
}

#pragma mark - TableViewDelegate & TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *msg = [_dataSource objectAtIndex:indexPath.row];
    Class class = [MessageBaseTableCell classByObject:msg];
    
    return [class heightWithData:msg];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *msg = [_dataSource objectAtIndex:indexPath.row];
    Class class = [MessageBaseTableCell classByObject:msg];
    
    NSString *identify = NSStringFromClass(class);
    MessageBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];;
    }
    [cell initWithData:msg indexPath:indexPath];
    
    return cell;
}



- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager stopPlayingAudio];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
