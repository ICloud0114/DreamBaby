//
//  HospitalViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * mTableView;
    UILabel *titleLabel;
    
    NSMutableArray *droplistArray;
    UITableView *dropTable;
    UIImageView *dropView;
    UIView *tableImage;
    
   
    
    
    int flag;

}


@property (nonatomic ,copy) NSString *Id;
@property (nonatomic ,retain) NSArray  *infoArray;
@end
