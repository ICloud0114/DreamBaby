//
//  MohterComViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

//妈妈交流

#import <UIKit/UIKit.h>
#import "ZZReplyView.h"

@interface MohterComViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIScrollView * contentScrollerView;
    UITableView * mTableView;
    ZZReplyView *replyView;
    
    UIImageView *chatIconImageView;
}
@property (nonatomic ,retain) UIView *bgView;

@end
