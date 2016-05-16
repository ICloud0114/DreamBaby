//
//  MoreViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *moreTable;
    BOOL isUp;
    NSString *inviteString;
}

@end
