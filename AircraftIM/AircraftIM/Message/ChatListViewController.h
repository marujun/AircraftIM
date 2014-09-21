//
//  ChatListViewController.h
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListViewController : UIViewController
{
    __weak IBOutlet UITableView *_tableView;
}

- (void)refreshDataSource;

@end
