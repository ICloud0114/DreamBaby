//
//  HospitalViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "HospitalViewController.h"
#import "ZixunCell.h"
#import "HosipitalDetailViewController.h"

#import "HTTPRequest.h"
#import "ATMHud.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonUtil.h"
#import "SVPullToRefresh.h"
#import "UIImageView+WebCache.h"

@interface HospitalViewController ()
{
    ATMHud *hud;
    NSInteger pageindex;
    NSInteger pageSize;
}

@property (nonatomic ,retain) NSMutableArray *dataArray;
@end

@implementation HospitalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageindex = 1;
        pageSize = 10;
    }
    return self;
}

- (void)dealloc
{
    RELEASE_SAFE(dropTable);
    RELEASE_SAFE(dropView);
    RELEASE_SAFE(tableImage);

    hud.delegate = nil;
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
    titleLabel.text =@"医院信息";  //设置标题
    if (self.infoArray && self.infoArray.count > 0) {
        
        for (NSDictionary *dictionary in self.infoArray) {
            NSString *tempId = [dictionary objectForKey:@"id"];
            if ([tempId isEqualToString:self.Id]) {
                NSString *title = [dictionary objectForKey:@"title"];
                titleLabel.text = title;
                break;
            }
        }
    }
    [titleBg addSubview:titleLabel];

    UIButton *dropBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [dropBtn setBackgroundImage:[UIImage imageNamed:@"top_btn_h"] forState:UIControlStateNormal];
    [dropBtn setBackgroundImage:[UIImage imageNamed:@"top_btn_h"] forState:UIControlStateHighlighted];
    [dropBtn addTarget:self action:@selector(showOrHiddenDropView) forControlEvents:UIControlEventTouchUpInside];
    dropBtn.frame=CGRectMake(80, 10, 24, 20);
    [titleBg addSubview:dropBtn];
    self.navigationItem.titleView = titleBg;
    RELEASE_SAFE(titleBg);
    
    
    //
    NSMutableArray *tempArray = [NSMutableArray array];
    self.dataArray = tempArray;
    flag=0;
    
    //下拉视图
    dropView=[[UIImageView alloc]initWithFrame:CGRectMake(110, 0, 124, 11)];
    dropView.image=[UIImage imageNamed:@"drop_down_bg"];
    dropView.hidden=NO;
    [self.view addSubview:dropView];
    
    tableImage=[[UIImageView alloc]initWithFrame:CGRectMake(110, 0, 101, 140)];
    tableImage.userInteractionEnabled=YES;
    tableImage.hidden=YES;
    tableImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"yiyuan_kuang"]];
    dropTable = [[UITableView alloc]initWithFrame:CGRectMake(1, 0, 100, 139)];
    dropTable.backgroundColor=[UIColor clearColor];
    dropTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    dropTable.delegate =self;
    dropTable.dataSource =self;
    [tableImage addSubview:dropTable];
    
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(10, 20, 300, self.view.frame.size.height-44-49) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    [mTableView release];
    
    //在table添加之后添加  以防止被挡住
    [self.view addSubview:tableImage];
    
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    
    
    
    //first request
    [self getRequest:YES];
    //second .....
    [mTableView addInfiniteScrollingWithActionHandler:^{
        [self getRequest:NO];
    }];
}



- (void)getRequest:(BOOL)isFirst
{
    if (isFirst)
    {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
    }
    
    NSLog(@"begin================");
    NSLog(@"pageIndex----->%d",pageindex);
    NSLog(@"end==================");
    dispatch_queue_t network;
    network = dispatch_queue_create("get_msg_info_list", nil);
    dispatch_async(network, ^{
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.Id,@"category_id",
                               [NSString stringWithFormat:@"%d",pageSize],@"page_size",
                               [NSString stringWithFormat:@"%d",pageindex],@"page_index",
                               nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:param method:@"get_msg_info_list"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
                NSLog(@"array = %@",array);
                [self.dataArray addObjectsFromArray:array];
                 NSLog(@"self.dataArray = %@",self.dataArray);
                [mTableView reloadData];

                if (array.count < pageSize)
                {
                    mTableView.infiniteScrollingView.enabled = NO;
                }else
                {
                    pageindex ++;

                }
                if (isFirst)
                {
                    [hud hideAfter:1.0f];

                }
            }else
            {
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
                
                [mTableView reloadData];
                if (isFirst)
                {
                    [hud hideAfter:1.0f];
                }
            }
            //[mTableView.pullToRefreshView stopAnimating];
            [mTableView.infiniteScrollingView stopAnimating];
        });
    });
}

-(void)showOrHiddenDropView
{
    if (dropView.hidden==YES)
    {
        tableImage.hidden=YES;
        dropView.hidden=NO;
    }else{
        tableImage.hidden=NO;
        dropView.hidden=YES;
    }
    
}
#pragma mark -----TableViewDeklegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 5)];
    myView.backgroundColor = [UIColor clearColor];
    return [myView autorelease];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == dropTable) {
        return 0;
    }else
    {
        return 5;
        
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==dropTable) {
        if (self.infoArray) {
            return self.infoArray.count;
        }
        return 0;
    }else
    {
        if (self.dataArray) {
            return self.dataArray.count;
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == dropTable) {
        return 25;
    }else
    {
        return 68.0f;

    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==dropTable) {
        static NSString *dropIdentifier = @"identifier";
        
        UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:dropIdentifier];
        if (cell ==nil) {
            cell = [[[UITableViewCell alloc]initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:dropIdentifier] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor=[UIColor colorwithHexString:@"#878787"];
        }
        cell.textLabel.text=[[self.infoArray objectAtIndex:indexPath.section]valueForKey:@"title"];
        
        return cell;

    }else{
        static NSString *identifier = @"zixun2";
        ZixunCell  * cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
        if (cell==nil) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"ZixunCell" owner:self options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dictionary = self.dataArray[indexPath.section];
        NSLog(@"dictionary :%@",[dictionary description]);
        NSLog(@"row = %d",indexPath.row);
        
        NSString *img_url = [dictionary objectForKey:@"img_url"];
        if (![img_url hasPrefix:@"http://"]) {
            img_url = [@"http://" stringByAppendingString:img_url];
        }
        [cell.IconImageView setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"icon"]];
        cell.NameLabel.text = [dictionary objectForKey:@"title"];
        
        NSString *detailString = [dictionary objectForKey:@"address"];
        detailString = [detailString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.DetailLabel.text = detailString;
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row :%d",indexPath.section);

    
    if (tableView==dropTable) {
        NSLog(@"indexPath.row :%d",indexPath.section);
        self.Id = [[self.infoArray objectAtIndex:indexPath.section]valueForKey:@"id"];
        NSString *title = [[self.infoArray objectAtIndex:indexPath.section] objectForKey:@"title"];
        titleLabel.text = title;
        
        [self performSelector:@selector(change:) withObject:nil afterDelay:0];

        flag = indexPath.section + 1;
        
    }
    else if(tableView == mTableView)
    {
        NSString *Id  = [[self.dataArray objectAtIndex:indexPath.section]valueForKey:@"id"];
        HosipitalDetailViewController * zixunVC = [[HosipitalDetailViewController alloc]init];
        zixunVC.Id = Id;
        [self.navigationController pushViewController:zixunVC animated:YES];
        [zixunVC release];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
//    if (flag==1 && tableView!=dropTable) {
//        HosipitalDetailViewController * zixunVC = [[HosipitalDetailViewController alloc]init];
//        [self.navigationController pushViewController:zixunVC animated:YES];
//        [zixunVC release];
//    }else if (flag==0 && tableView!=dropTable) {
//        HosipitalDetailViewController * zixunVC = [[HosipitalDetailViewController alloc]init];
//        [self.navigationController pushViewController:zixunVC animated:YES];
//        [zixunVC release];
//    }
    
//    ZixunDetailViewController * zixunVC = [[ZixunDetailViewController alloc]init];
//    [self.navigationController pushViewController:zixunVC animated:YES];
//    [zixunVC release];
    
}
- (void)change:(id)sender
{
    pageindex = 1;
    [self.dataArray removeAllObjects];
    
    [self getRequest:YES];
    
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
