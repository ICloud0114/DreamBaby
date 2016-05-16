//
//  LoveTipsViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "LoveTipsViewController.h"
#import "MoreControllerCell.h"
#import "HospitalViewController.h"
#import "GovermentAnounceViewController.h"
#import "DayKnowledgeViewController.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "ATMHud.h"
#import "SVPullToRefresh.h"
#import "CareCell.h"
#import "JsonFactory.h"

@interface LoveTipsViewController ()
{
    ATMHud *hud;
    NSUInteger pageIndex;
    NSUInteger pageSize;
}

@property (nonatomic ,retain) NSMutableArray *loveArray;
@property (nonatomic ,retain) NSMutableArray *announcementArray;
@property (nonatomic ,retain) NSMutableArray *infoArray;
@end

@implementation LoveTipsViewController
@synthesize droplistArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageIndex = 1;
        pageSize = 10;
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(droplistArray);
    
    RELEASE_SAFE(dropTable);
    RELEASE_SAFE(dropView);
    RELEASE_SAFE(tableImage);
    hud.delegate=nil;
    [hud release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    UIView *titleBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 114, 40)];
    titleBg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHiddenDropView)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [titleBg addGestureRecognizer:tap];
    RELEASE_SAFE(tap);
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]; //设置文本字体与大小
    titleLabel.textColor = [UIColor  colorwithHexString:@"#ffffff"];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text =@"关爱提醒";  //设置标题
    
    [titleBg addSubview:titleLabel];
    RELEASE_SAFE(titleLabel);
    
    UIButton *dropBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [dropBtn setBackgroundImage:[UIImage imageNamed:@"top_btn_h"] forState:UIControlStateNormal];
    [dropBtn setBackgroundImage:[UIImage imageNamed:@"top_btn_h"] forState:UIControlStateHighlighted];
    [dropBtn addTarget:self action:@selector(showOrHiddenDropView) forControlEvents:UIControlEventTouchUpInside];
    dropBtn.frame=CGRectMake(80, 10, 24, 20);
//    [titleBg addSubview:dropBtn];
    self.navigationItem.titleView = titleBg;
    RELEASE_SAFE(titleBg);
    
    droplistArray = [[NSMutableArray alloc]init];
   // [droplistArray  addObject:@"关爱提醒"];
    [droplistArray addObject:@"政府公告"];
//    [droplistArray addObject:@"信息查询"];
    
    
    //
    NSMutableArray *tempArray1 = [NSMutableArray array];
    self.loveArray = tempArray1;
    
    NSMutableArray *tempArray2 = [NSMutableArray array];
    self.announcementArray = tempArray2;
    
    NSMutableArray *tempArray3 = [NSMutableArray array];
    self.infoArray = tempArray3;
    
    flag = 1;
    
    //下拉视图
    dropView=[[UIImageView alloc]initWithFrame:CGRectMake(95, 0, 124, 11)];
    dropView.image=[UIImage imageNamed:@"drop_down_bg"];
    dropView.hidden=NO;
    [self.view addSubview:dropView];
    
    tableImage=[[UIImageView alloc]initWithFrame:CGRectMake(95, 0, 124, 264)];
    tableImage.userInteractionEnabled=YES;
    tableImage.hidden=YES;
    tableImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"drop_down_bg02"]];
    dropTable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 104, 240)];
    dropTable.backgroundColor=[UIColor clearColor];
    dropTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    dropTable.delegate =self;
    dropTable.dataSource =self;
    [tableImage addSubview:dropTable];
    
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    loveTipTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20-44-49) style:UITableViewStylePlain];
    if(version>=7.0f)
    {
        loveTipTable.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20-44-49);
    }
    loveTipTable.backgroundView = nil;
    loveTipTable.backgroundColor = [UIColor clearColor];
    loveTipTable.delegate = self;
    loveTipTable.dataSource = self;
    loveTipTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    loveTipTable.separatorColor = [UIColor whiteColor];
    [self.view addSubview:loveTipTable];
    [loveTipTable release];
    
    
    
    infoCheckTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20-44-49) style:UITableViewStyleGrouped];
    if(version>=7.0f){
        infoCheckTable.frame = CGRectMake(10, 0, 300, self.view.frame.size.height-44-49);
    }
    infoCheckTable.backgroundView = nil;
    infoCheckTable.backgroundColor = [UIColor clearColor];
    infoCheckTable.delegate = self;
    infoCheckTable.dataSource = self;
    [self.view addSubview:infoCheckTable];
    [infoCheckTable release];
    infoCheckTable.hidden = YES;
    
    
    goverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20-44-49) style:UITableViewStyleGrouped];
    if(version>=7.0f){
        goverTableView.frame = CGRectMake(10, 0, 300, [UIScreen mainScreen].bounds.size.height - 20-44-49);
    }
    goverTableView.backgroundView = nil;
    goverTableView.backgroundColor = [UIColor clearColor];
    goverTableView.delegate = self;
    goverTableView.dataSource = self;
    [self.view addSubview:goverTableView];
    [goverTableView release];
    goverTableView.hidden = YES;
    
//    [self getRequestForListTableView];
    
    //在table添加之后添加  以防止被挡住
    [self.view addSubview:tableImage];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LOVETIPS"]) {
        NSString *dataString = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOVETIPS"];
        NSArray *array = [JsonUtil jsonToArray:dataString];
        [self.loveArray addObjectsFromArray:array];
//        NSLog(@"loveArray = %@",self.loveArray);
        [self getLovetipsUpdate];
    }else
    {
        [self getLoveTipsInfo:YES];
    }
    
    [goverTableView addInfiniteScrollingWithActionHandler:^{
        [self getGovernmentInfo:NO];
    }];
    
    if ([self.isLoveTip isEqualToString:@"love"]) {
        titleLabel.text =@"关爱提醒";
    }
    else if ([self.isLoveTip isEqualToString:@"goverment"])
    {

        titleLabel.text = @"新闻中心";
        loveTipTable.hidden = YES;
        goverTableView.hidden = NO;
        infoCheckTable.hidden = YES;
        
        if (self.announcementArray.count == 0) {
            [self getGovernmentInfo:YES];
        }
    }
    
//    NSLog(@"arrlist = %@",self.loveArray);
//    NSLog(@"week = %@",[[self.loveArray[0] objectForKey:@"week"] class]);
}




-(void)showOrHiddenDropView
{
    if (dropView.hidden==YES) {
        tableImage.hidden=YES;
        dropView.hidden=NO;
    }else{
        tableImage.hidden=NO;
        dropView.hidden=YES;
    }
}


#pragma mark - request love tips
- (void)getLoveTipsInfo:(BOOL)showActivity
{
    if (showActivity) {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
    }
    
    
    NSString *type = @"1";
    dispatch_queue_t network;
    network = dispatch_queue_create("get_remain_info", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:type,@"type", nil]
                                                          method:@"get_remain_info"];
        
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"dic=  %@",dictionary);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                NSLog(@"dictioanry :%@",[dictionary description]);
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
                
                [self.loveArray addObjectsFromArray:array];
                NSLog(@"LOVE= %@",self.loveArray);
                [loveTipTable reloadData];
                [self scrollToListTable];
                
                [[NSUserDefaults standardUserDefaults]setValue:dataString forKey:@"LOVETIPS"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [hud hideAfter:1.0f];
                
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                }
                [hud hideAfter:1.0f];
            }
        });
    });
   
}

- (void)getLovetipsUpdate
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    NSString *type = @"2";
    NSLog(@"self.loveArray = %@",self.loveArray);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"cate_id",type,@"type",[[[self.loveArray objectAtIndex:1] objectForKey:@"obj"][0] objectForKey:@"add_time"] ,@"visit_time", nil];
    dispatch_queue_t network;
    network = dispatch_queue_create("get_updated_info", nil);
    dispatch_async(network, ^{
        NSString *updateRequest=[HTTPRequest requestForGetWithPramas:param method:@"get_updated_info"];
        NSDictionary *json=[JsonUtil jsonToDic:updateRequest];
        NSLog(@"json = %@",json);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"] intValue] == 1) {
                [self.loveArray removeAllObjects];
                [self getLoveTipsInfo:NO];
            }else
            {
                [hud hideAfter:1.0f];
                [loveTipTable reloadData];
                [self scrollToListTable];

            }
        });
    });

}


#pragma mark - request government info
- (void)getGovernmentInfo:(BOOL)isFirst
{
    if (isFirst) {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
    }
    
    
    NSString *type = @"2";
    dispatch_queue_t network;
    network = dispatch_queue_create("get_government_info", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  type,@"type",
                                                                  [NSString stringWithFormat:@"%d",pageIndex],@"page_index",
                                                                  [NSString stringWithFormat:@"%d",pageSize],@"page_size",
                                                                  nil]
                                                          method:@"get_other_info"];
        
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                NSLog(@"dictioanry :%@",[dictionary description]);
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
                [self.announcementArray addObjectsFromArray:array];
                
                [goverTableView reloadData];
                [goverTableView.infiniteScrollingView stopAnimating];

                if (array.count < 10) {
                    goverTableView.infiniteScrollingView.enabled = NO;
                }else
                {
                    pageIndex ++;
                }
                
                if (isFirst) {
                    [hud hideAfter:1.0f];
                }
            }else
            {
                [goverTableView.infiniteScrollingView stopAnimating];

                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    if (isFirst) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    }
                }else
                {
                    if (isFirst) {

                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                    }
                }
                if (isFirst) {
                    [hud hideAfter:1.0f];
                }
            }
        });
    });
}


#pragma mark - request info query
- (void)getInfoQueryRequest
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    dispatch_queue_t network;
    network = dispatch_queue_create("get_msg_category_list", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:nil method:@"get_msg_category_list"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
               
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
                [self.infoArray addObjectsFromArray:array];
                
                [infoCheckTable reloadData];
                
                [hud hideAfter:1.0f];
                
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                        [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                        [hud setActivity:NO];
                        [hud update];
                    
                }else
                {
                        [hud setCaption:@"网络出问题了"];
                        [hud setActivity:NO];
                        [hud update];
                    
                }
                    [hud hideAfter:1.0f];
            }
        });
    });
}

    
-(void)scrollToListTable
{
    //    ChangeDate *change=[ChangeDate instance];
    //    if ([change.type_id isEqualToString:@"1"]) {
    NSDate * putDate =  [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    //从现在开始到预产期还有多少天   212
    if ([putDate compare:[NSDate date]]>0) {
        
        int days=[self _getTime:putDate];

        days = 280 - days;
       
        int whichWeak = 0;
        if (days > 0)
        {
                whichWeak = days/7 -2;
           
        }
        if (whichWeak < 0) {
            whichWeak = 0;
        }
        NSLog(@"wichWeak =%d",whichWeak);
        [loveTipTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:whichWeak] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        if (self.loveArray.count>0) {
            
            NSInteger rowCount = [loveTipTable numberOfRowsInSection:self.loveArray.count];
            if (rowCount > 0 && rowCount != NSNotFound) {
                [loveTipTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.loveArray.count] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            } else {
                [loveTipTable scrollRectToVisible:CGRectMake(0, 0, loveTipTable.contentSize.width, loveTipTable.contentSize.height) animated:YES];
            }
            
        }
        
    }
    
}

-(int)_getTime:(NSDate *)lastOnlineTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [dateFormatter dateFromString:nowStr];
    NSTimeInterval time=[lastOnlineTime timeIntervalSinceDate:nowDate];
    int days=((int)time)/(3600*24);
    [dateFormatter release];
    NSLog(@"days = %d",days);
    return days;
}

//计算孕妇所有天数
- (void) calculateAllDay
{
    if (self.loveArray != nil && self.loveArray.count > 0)
    {
        allDay = 0;
        for (NSArray *ary in self.loveArray)
        {
            allDay += ary.count;
        }
    }
}

//计算怀孕日期
- (NSDate *) calculateHuaiYuanDate
{
    [self calculateAllDay];
    
    NSDate *yuanChanDate = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    NSDate *huaiYunDate = [NSDate dateWithTimeIntervalSince1970:([yuanChanDate timeIntervalSince1970] - (273*24*60*60))];
    return huaiYunDate;
}

#pragma mark---TableVeiw methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView==loveTipTable) {
      
        //view.backgroundColor = [UIColor redColor];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        UIImageView * shuruBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        shuruBG.image = [UIImage imageNamed:@"list_biaoti02"];
        if (section==0) {
            shuruBG.image = [UIImage imageNamed:@"list_biaoti01"];
        }
        [view addSubview:shuruBG];
        [shuruBG release];
        
        //专家介绍
        UILabel* jieshaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 320, 20)];
        NSNumber *number = [self.loveArray[section] objectForKey:@"week"];
        int week = number.intValue;
        if (week==0) {
            jieshaoLabel.text=[NSString stringWithFormat:@"备孕期"];
        }else
        {
            jieshaoLabel.text=[NSString stringWithFormat:@"孕%d周",week];
        }
        jieshaoLabel.font = [UIFont boldSystemFontOfSize:14];
        jieshaoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jiaoliu_list_kuang"]];
        jieshaoLabel.textColor =[UIColor colorwithHexString:@"#d470a8"];
        jieshaoLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:jieshaoLabel];
        [jieshaoLabel release];
        
        
        return  [view autorelease];
        
        
    }else
    {
        UIView *hideView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        return hideView;
    }
   
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView== loveTipTable) {
        return 35.0f;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==dropTable) {
        return 1;
    }
    if (tableView==goverTableView) {
        if (self.announcementArray) {
            return self.announcementArray.count;
        }
        return 0;
    }
    if (tableView == infoCheckTable) {
        if (self.infoArray) {
            return self.infoArray.count;
        }
    }
    if (tableView == loveTipTable) {
        if (self.loveArray) {
            return [[[self.loveArray objectAtIndex:section]objectForKey:@"obj"] count];
        }
    }
    int num = 0;
    return num;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==dropTable || tableView==goverTableView) {
        return 1;
    }
    if (tableView == infoCheckTable) {
        return 1;
    }
    if (tableView == loveTipTable) {
        if (self.loveArray) {
            return self.loveArray.count;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==dropTable) {
        return 30;
    }
    return 36.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if(version<7.0f){
        //tableView.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    //static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:nil];
  
    
    if (tableView==dropTable)
    {
        if (cell ==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=[droplistArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor=[UIColor colorwithHexString:@"#c27575"];
    }
    
    if (tableView==loveTipTable)
    {
        static NSString *identifier = @"MoreControllerCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"MoreControllerCell" owner:self options:nil]lastObject];
            ((MoreControllerCell *)cell).moreArticalLabel.textColor = [UIColor blackColor];
//            ((MoreControllerCell *)cell).moreStateLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_arrow"]];
            cell.accessoryView = view ;
            [view release];
        }
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_type_1"]]autorelease];
        
        if ([[[[self.loveArray objectAtIndex:indexPath.section] objectForKey:@"obj"]objectAtIndex:indexPath.row] objectForKey:@"title"]!=[NSNull null]) {
            
            ((MoreControllerCell *)cell).textLabel.text = [[[[self.loveArray objectAtIndex:indexPath.section] objectForKey:@"obj" ] objectAtIndex:indexPath.row] objectForKey:@"title"];
            ((MoreControllerCell *)cell).moreArticalLabel.hidden = YES;
//            ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
            ((MoreControllerCell *)cell).moreAccessView.hidden = YES;
        }
    }
    
    
    if (tableView==infoCheckTable) {
        static NSString *identifier = @"MoreControllerCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"MoreControllerCell" owner:self options:nil]lastObject];
            ((MoreControllerCell *)cell).moreArticalLabel.textColor = [UIColor blackColor];
//            ((MoreControllerCell *)cell).moreStateLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_arrow"]];
            cell.accessoryView = view ;
            [view release];
        }
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];

        NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];
        ((MoreControllerCell *)cell).textLabel.text = [dictionary objectForKey:@"title"];
        ((MoreControllerCell *)cell).moreArticalLabel.hidden = YES;
//        ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
        ((MoreControllerCell *)cell).moreAccessView.hidden = YES;
        
    }
    
    
    if (tableView==goverTableView) {
        static NSString *identifier = @"MoreControllerCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"MoreControllerCell" owner:self options:nil]lastObject];
            ((MoreControllerCell *)cell).moreArticalLabel.textColor = [UIColor blackColor];
//            ((MoreControllerCell *)cell).moreStateLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_arrow"]];
            cell.accessoryView = view ;
            [view release];
        }
        
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
        NSDictionary *dictionary = [self.announcementArray objectAtIndex:indexPath.row];
        NSLog(@"dictionary :%@",[dictionary description]);
        
        ((MoreControllerCell *)cell).textLabel.text = [dictionary objectForKey:@"title"];
        ((MoreControllerCell *)cell).moreArticalLabel.hidden = YES;
//        ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
        ((MoreControllerCell *)cell).moreAccessView.hidden = YES;
        /*
        ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
        if (indexPath.row==0) {
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinxi_list_shang_bg"]]autorelease];
            ((MoreControllerCell *)cell).moreArticalLabel.text = @"关爱提醒通知";
            ((MoreControllerCell *)cell).moreStateLabel.text = @"打开";
            ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
            ((MoreControllerCell *)cell).moreStateLabel.textAlignment=NSTextAlignmentRight;
            
        }
        if (indexPath.row==9) {
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinxi_list_xia_bg"]]autorelease];
            ((MoreControllerCell *)cell).moreArticalLabel.text = @"关爱提醒通知";
            ((MoreControllerCell *)cell).moreStateLabel.text = @"打开";
            ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
            ((MoreControllerCell *)cell).moreStateLabel.textAlignment=NSTextAlignmentRight;
            
        }
         */
        
    }

   
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==dropTable) {
        if (flag == 1)
        {
            flag = 2;
            [droplistArray removeAllObjects];
            [droplistArray addObject:@"关爱提醒"];
        }
        else if (flag == 2)
        {
            flag = 1;
            [droplistArray removeAllObjects];
            [droplistArray addObject:@"政府公告"];
        }
        [self performSelector:@selector(change:) withObject:nil afterDelay:0];
        [dropTable reloadData];
        //flag=indexPath.row+1;
    }
    if (tableView==infoCheckTable) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary *dictionary = [self.infoArray objectAtIndex:indexPath.row];

        HospitalViewController * zixunVC = [[[HospitalViewController alloc]init]autorelease];
        zixunVC.Id = [dictionary objectForKey:@"id"];
        zixunVC.infoArray = [self.infoArray copy];
        [self.navigationController pushViewController:zixunVC animated:YES];

    }
    if (tableView==goverTableView) {
        NSDictionary *dictionary = [self.announcementArray objectAtIndex:indexPath.row];

        GovermentAnounceViewController * zixunVC = [[GovermentAnounceViewController alloc]init];
        zixunVC.Id = [dictionary objectForKey:@"id"];
        NSLog(@"zixun==%@",zixunVC.Id);
        [self.navigationController pushViewController:zixunVC animated:YES];
        [zixunVC release];
    }
    if (tableView==loveTipTable) {
        DailyDetailViewController *dailyDetailVC=[[DailyDetailViewController alloc]initWithDetail:[[[[self.loveArray objectAtIndex:indexPath.section] objectForKey:@"obj"] objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSNumber *number = [self.loveArray[indexPath.section] objectForKey:@"week"];
        int week = number.intValue;
        dailyDetailVC.section=week;
        [self.navigationController pushViewController:dailyDetailVC animated:YES];
        [dailyDetailVC release];


    }
}
- (void)change:(id)sender
{
    if (flag==1) {
        titleLabel.text = @"关爱提醒";
        loveTipTable.hidden = NO;
        goverTableView.hidden = YES;
        infoCheckTable.hidden = YES;
        
    }
    if (flag==2) {
        titleLabel.text = @"政府公告";
        loveTipTable.hidden = YES;
        goverTableView.hidden = NO;
        infoCheckTable.hidden = YES;
        
        if (self.announcementArray.count == 0) {
            [self getGovernmentInfo:YES];
        }
    }
    if (flag==3) {
        titleLabel.text = @"信息查询";
        loveTipTable.hidden = YES;
        goverTableView.hidden = YES;
        infoCheckTable.hidden = NO;
        if (self.infoArray.count == 0) {
            [self getInfoQueryRequest];
        }
    }
    
    if (dropView.hidden==YES) {
        tableImage.hidden=YES;
        dropView.hidden=NO;
    }else{
        tableImage.hidden=NO;
        dropView.hidden=YES;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
