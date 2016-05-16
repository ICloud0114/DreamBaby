//
//  HistoryViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * mTableView;
    
}
@property (nonatomic )NSInteger type;

@end
