//
//  ChatListViewController.m
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListTableCell.h"
#import "ChatViewController.h"

@interface ChatListViewController ()
{
    NSMutableArray *_dataSource;
}
@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(newMessage:)
                                                     name:kNewMessageNotification
                                                   object:nil];
        
        // 监测Xmpp连接状态
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(xmppConnectChanged:)
                                                     name:kXmppConnectChangedNotification
                                                   object: nil];
    }
    return self;
}

//新消息
- (void)newMessage:(NSNotification *)note
{
    [self refreshDataSource];
}

//Xmpp连接状态发生变化
- (void)xmppConnectChanged:(NSNotification *)note
{
    //
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"会话";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
}

- (void)refreshDataSource
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    _dataSource = [[NSMutableArray alloc] initWithArray:sorte];
    
    [_tableView reloadData];
}


#pragma mark - TableViewDelegate & TableViewDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ChatListTableCell";
    ChatListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:self options:nil] firstObject];
    }
    [cell initWithData:_dataSource[indexPath.row] indexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:nil bundle:nil];
    chatVC.conversation = [_dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
}


@end
