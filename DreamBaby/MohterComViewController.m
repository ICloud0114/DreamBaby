//
//  MohterComViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MohterComViewController.h"
#import "JiaoLiuCell.h"
#import "ComuDetailViewController.h"


#import "SVPullToRefresh.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonUtil.h"
#import "HTTPRequest.h"
#import "IsLogIn.h"
#import "ATMHud.h"
#import "UIImageView+WebCache.h"
#import "ReplyViewController.h"

@interface MohterComViewController ()<reloadDataDelegate>
{
    ATMHud *hud;
    NSUInteger pageIndex;
    NSUInteger pageSize;
    UIButton *rightBtn;
}
@property (nonatomic ,retain) NSMutableArray *dataArray;
@end

@implementation MohterComViewController
@synthesize bgView;

- (void)dealloc
{
    RELEASE_SAFE(bgView);
    RELEASE_SAFE(_dataArray);
    hud.delegate = nil;
    [hud release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [chatIconImageView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageSize = 10;
        pageIndex = 1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (chatIconImageView == nil)
    {
        chatIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(85, 6, 32, 32)];
        [chatIconImageView setImage:[UIImage imageNamed:@"mama"]];
    }
    [self.navigationController.navigationBar addSubview:chatIconImageView];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [chatIconImageView removeFromSuperview];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"妈妈交流";
    
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    rightBtn.userInteractionEnabled = NO;
    [rightBtn setTitle:@"发帖" forState:UIControlStateNormal];
    [rightBtn setTitle:@"发帖" forState:UIControlStateHighlighted];
    [rightBtn setTitle:@"发帖" forState:UIControlStateSelected];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"pen_h"] forState:UIControlStateHighlighted];
//    [rightBtn setTitle:@"发帖" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.titleLabel.textColor=[UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(pushViewCtr) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = bar;
    [rightBtn release];
    [bar release];
    
    
    
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
    
    //
    NSMutableArray *array = [NSMutableArray array];
    self.dataArray = array;
    
     bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 49 - 10)];

    //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
    bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#e7d4df"].CGColor;
    bgView.layer.cornerRadius = 3;
    [self.view addSubview:bgView];
    
    mTableView =[[UITableView alloc] initWithFrame:bgView.bounds style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor colorwithHexString:@"#e7d4df"];
//    mTableView.backgroundColor = [UIColor greenColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [bgView addSubview:mTableView];
    [mTableView release];
    
    [mTableView addInfiniteScrollingWithActionHandler:^{
        [self getRequset:NO];
    }];
    [mTableView addPullToRefreshWithActionHandler:^{
        [self getRequset:YES];
    }];
//    replyView = [[ZZReplyView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 20 - 44 - 40, 320, 40) withReplyType:ZZReplayViewTypeNoShare];
//    [replyView.markButton addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
//    //[replyView.markButton addTarget:self action:@selector(collectProduct) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:replyView];
//    [replyView release];
//    [replyView.replyTextField setDelegate:self];
    
    
    //
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [self getRequset:YES];

}
#pragma mark replyviewDelegate
-(void)beginReloadData
{
    pageIndex = 1;
    [self.dataArray removeAllObjects];
    [self getRequset:YES];
}
-(void)pushViewCtr
{
    ReplyViewController *reply = [[ReplyViewController alloc] init];
    reply.IDstring = [IsLogIn instance].memberData.idString;
    reply.delegate = self;
    [self.navigationController pushViewController:reply animated:YES];
}
- (void)sendComment:(UIButton *)button
{
    if (replyView.replyTextView.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入想说的话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    
}
#pragma mark ----- request
- (void)getRequset:(BOOL)isFirst
{
    if (isFirst)
    {
        pageIndex = 1;
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
    }

    NSString *user_id = [IsLogIn instance].memberData.idString;
    NSLog(@"user_id==%@",user_id);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",
                           [NSString stringWithFormat:@"%d",pageIndex],@"page_index",
                           [NSString stringWithFormat:@"%d",pageSize],@"page_size",
                           nil];
    dispatch_queue_t network;
    network = dispatch_queue_create("get_mm_comment", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:param method:@"get_mm_comment"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                rightBtn.userInteractionEnabled = YES;
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
//                NSLog(@"arr = %@",array);
                if (isFirst)
                {
                    if (self.dataArray.count)
                    {
                        [self.dataArray removeAllObjects];
                    }
                    
                }
                
                [self.dataArray addObjectsFromArray:array];
                NSLog(@"self.dataArray  :%@",[self.dataArray description]);

                if (array.count < 10)
                {
                    if (isFirst)
                    {
                        [hud hideAfter:1.0f];
                    }
                    if (array.count == 0) {

                        if (isFirst) {
                            [hud setCaption:@"暂无交流信息"];
                            [hud setActivity:NO];
                            [hud update];
                            [hud hideAfter:1.0f];
                        }
                    }
                    
                    mTableView.infiniteScrollingView.enabled =  NO;
                    mTableView.contentInset = UIEdgeInsetsZero;
                }
                else
                {
                    pageIndex ++;
                    
                    
                    if (isFirst)
                    {
                        [hud hideAfter:1.0f];
                    }
                    
                }
               
                [mTableView reloadData];
            }else
            {
                [mTableView reloadData];
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    if (isFirst) {
                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud update];
                        [hud hideAfter:1.0f];
                    }
                }else
                {
                    if (isFirst) {
                        [hud setCaption:@"网络出问题了"];
                        [hud setActivity:NO];
                        [hud update];
                        [hud hideAfter:1.0f];
                    }
                }
            }
            
            [mTableView.pullToRefreshView stopAnimating];
            [mTableView.infiniteScrollingView stopAnimating];
        });
    });
}


#pragma mark -----TableViewDeklegate
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 45)];
    
    
    UIImageView * shuruBG = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 300, 30)];
    shuruBG.image = [UIImage imageNamed:@"jiaoliu_list_kuang"];
    [view addSubview:shuruBG];
    [shuruBG release];
    
    //专家介绍
    UILabel* jieshaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 280, 20)];
    jieshaoLabel.text= @"天津市交流一区";
    jieshaoLabel.font = [UIFont boldSystemFontOfSize:14];
    jieshaoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jiaoliu_list_kuang"]];
    jieshaoLabel.textColor =[UIColor colorwithHexString:@"#d470a8"];
    jieshaoLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:jieshaoLabel];
    [jieshaoLabel release];
    
    
    return  view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    return 100.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idetifer = @"jiaoliu";
    JiaoLiuCell  * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"JiaoLiuCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (self.dataArray.count > 0) {
        NSLog(@"dictionary :%@",[[self.dataArray objectAtIndex:indexPath.row] description]);

    }
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    NSString *img_url = [dictionary objectForKey:@"avatar"];
//    NSLog(@"image.url = %@",img_url);
    if (![img_url hasPrefix:@"http://"]) {
        img_url = [@"http://" stringByAppendingString:img_url];
    }
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    NSString *title = [dictionary objectForKey:@"title"];
    NSString *comment = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"comment_count"]intValue]];
    NSString *content = [dictionary objectForKey:@"content"];
//    NSString *
    NSString *add_time = [dictionary objectForKey:@"time_span"];
    
    cell.titleLabel.text = title;
    cell.contentLabel.text = content;
    cell.commentLabel.text = comment;
//    cell.timeLabel.text = [self dateFromString:add_time];
    cell.timeLabel.text = add_time;
    
    NSDictionary *user_list  = nil;// = [dictionary objectForKey:@"user_list"];
    if (![[dictionary objectForKey:@"user_list"] isEqual:[NSNull null]]) {
        user_list = [dictionary objectForKey:@"user_list"];
    }
    if (![[user_list objectForKey:@"user_name"] isEqual:[NSNull null]]) {
        cell.nameLabel.text = [user_list objectForKey:@"user_name"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];

    ComuDetailViewController * motherDetailVC = [[ComuDetailViewController alloc]init];
    NSString *img_url = [dictionary objectForKey:@"img_url"];
    if (![img_url hasPrefix:@"http://"]) {
        img_url = [@"http://" stringByAppendingString:img_url];
    }
    NSDictionary *user_list  = nil;// = [dictionary objectForKey:@"user_list"];
    if (![[dictionary objectForKey:@"user_list"] isEqual:[NSNull null]]) {
        user_list = [dictionary objectForKey:@"user_list"];
    }
    if (![[user_list objectForKey:@"user_name"] isEqual:[NSNull null]]) {
        motherDetailVC.name = [user_list objectForKey:@"user_name"];
    }
    motherDetailVC.headImg_url = img_url;
    motherDetailVC.Id = [dictionary objectForKey:@"id"];
    
    motherDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:motherDetailVC animated:YES];
    [motherDetailVC release];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reLoadTableView) name:@"refreshMotherList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


-(void)reLoadTableView
{
    [self beginReloadData];
}

#pragma mark keyboardNotification
-(void)keyboardShow:(NSNotification *)senderNotification
{
    [UIView animateWithDuration:0.5 animations:^
     {
         [replyView setFrame:CGRectMake(replyView.frame.origin.x, self.view.bounds.size.height - [[[senderNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height - replyView.frame.size.height+2, replyView.frame.size.width, replyView.frame.size.height)];
         NSLog(@"___%f  %f",self.view.frame.size.height,self.view.bounds.size.height - [[[senderNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height - replyView.frame.size.height+49);
     }
     ];
}

-(void)keyboardHide:(NSNotification *)senderNotification
{
    [UIView animateWithDuration:0.2 animations:^
     {
         [replyView setFrame:CGRectMake(replyView.frame.origin.x, self.view.bounds.size.height - replyView.frame.size.height, replyView.frame.size.width, replyView.frame.size.height)];
     }
     ];
}

-(void)keyboardChange:(NSNotification *)senderNotification
{
    [UIView animateWithDuration:0.2 animations:^
     {
         [replyView setFrame:CGRectMake(replyView.frame.origin.x, self.view.bounds.size.height - [[[senderNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height - replyView.frame.size.height+49, replyView.frame.size.width, replyView.frame.size.height)];
     }
     ];
}

- (NSString *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter release];
    NSDate *date = [NSDate date];
    

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    int intervall = (int) [localeDate timeIntervalSinceDate: destDate];
 
    NSString *returnValue = @"";
    if (intervall < 60) {
        returnValue = [NSString stringWithFormat:@"%d分钟前",1];
    }else
    {
        if (intervall > 60)
        {
            int minute = intervall / 60;
            
            if (minute < 60) {
                returnValue = [NSString stringWithFormat:@"%d分钟前",minute];
            }else
            {
                int hour = minute / 60;
                if (hour < 60) {
                    returnValue = [NSString stringWithFormat:@"%d小时前",hour];
                }else
                {
                    int day = hour / 24;
                    if (day < 365) {
                        returnValue = [NSString stringWithFormat:@"%d天前",day];
                    }else
                    {
                        returnValue = [NSString stringWithFormat:@"%d年前",day/365];
                    }
                }
            }
        }
    }
    return returnValue; //[NSString stringWithFormat:@"%d",intervall];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
