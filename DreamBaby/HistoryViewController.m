//
//  HistoryViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"

@interface HistoryViewController ()

@property (nonatomic ,retain) NSArray *dataArray;
@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    RELEASE_SAFE(_dataArray);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"历史记录";
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:titleLabel];
    
    if (self.title != nil)
    {
        [titleLabel setText:self.title];
    }
    if (self.navigationItem.title != nil)
    {
        [titleLabel setText:self.navigationItem.title];
    }
    
    if (self.type == 1) {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:MomHistory]) {
            self.dataArray = [[NSUserDefaults standardUserDefaults]objectForKey:MomHistory];
        }else
        {
            self.dataArray = [NSMutableArray array];
        }
    }else
    {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:BabyHistory])  {
            self.dataArray = [[NSUserDefaults standardUserDefaults]objectForKey:BabyHistory];
        }else
        {
            self.dataArray = [NSMutableArray array];
        }
    }
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20-44-49) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    [mTableView release];
    
    if (self.dataArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"暂无记录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}


#pragma mark -----TableViewDeklegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray) {
        return self.dataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idetifer = @"historyCell";
    HistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"HistoryCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    if (self.type == 1) {
        NSString *height = [dictionary objectForKey:@"height"];
        NSString *weight = [dictionary objectForKey:@"weight"];
        NSString *result = [dictionary objectForKey:@"result"];
        NSString *time = [dictionary objectForKey:@"time"];
        
        cell.NameLabel.text = [NSString stringWithFormat:@"身高:%.0fcm    体重:%@kg",[height floatValue]*100,weight];
        cell.DateLabel.text = time;
        if ([result intValue] == 1) {
            result = @"偏轻";
        }else if ([result intValue] == 2)
        {
            result = @"标准";
        }else
        {
            result = @"超重";
        }
        cell.ResultLabel.text = result;
    }else
    {
        NSString *days = [dictionary objectForKey:@"days"];
        NSString *weight = [dictionary objectForKey:@"weight"];
        NSString *result = [dictionary objectForKey:@"result"];
        NSString *time = [dictionary objectForKey:@"time"];
        cell.NameLabel.text = [NSString stringWithFormat:@"天数:%.d天    体重:%@kg",[days intValue],weight];
        cell.DateLabel.text = time;
        if ([result intValue] == 3) {
            result = @"轻度营养不良";
        }else if ([result intValue] == 4)
        {
            result = @"标准";
        }else if (result.intValue == 5)
        {
            result = @"超重";
        }else if (result.intValue == 1)
        {
           result = @"严重营养不良";
        }
        else if (result.intValue == 2)
        {
            result = @"重度营养不良";
        }
        cell.ResultLabel.text = result;
        
    }
    
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
