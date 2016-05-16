//
//  AppAdviceViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "AppAdviceViewController.h"
#import "AppAdviceCell.h"
#import "SVPullToRefresh.h"
#import "ATMHud.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "JsonUtil.h"
#import "NSString+URLEncoding.h"
#import "UIImageView+WebCache.h"
#import "iHasApp.h"

@interface AppAdviceViewController ()
{
    ATMHud *hud;
    NSInteger pageIndex;
    NSInteger pageSize;
}

@property (nonatomic ,retain) NSMutableArray *dataArray;
@property (nonatomic ,retain) NSArray        *installedArray;
@end

@implementation AppAdviceViewController

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
    RELEASE_SAFE(_dataArray);
    RELEASE_SAFE(_installedArray);
     hud.delegate = nil;
    [hud release];
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self detectMyApp];
    [super viewWillAppear:animated];
}

- (void)detectMyApp
{
    iHasApp *detectionObject = [[iHasApp alloc] init];
    [detectionObject detectAppDictionariesWithIncremental:^(NSArray *appDictionaries) {
        NSLog(@"Incremental appDictionaries.count: %i", appDictionaries.count);
    } withSuccess:^(NSArray *appDictionaries) {
        NSLog(@"Successful appDictionaries.count: %i", appDictionaries.count);
        NSLog(@"appDictionaries :%@",[appDictionaries description]);
        self.installedArray = appDictionaries;
        [mTableView reloadData];
    } withFailure:^(NSError *error) {
        NSLog(@"Failure: %@", error.localizedDescription);
    }];
//    [detectionObject release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"应用推荐";
    
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
    
    NSMutableArray *tempArray = [NSMutableArray array];
    self.dataArray = tempArray;

    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20-44-49) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    [mTableView release];
    
    
    [mTableView addInfiniteScrollingWithActionHandler:^{
        [self getRequestIsFirst:NO];
    }];
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];

    [self getRequestIsFirst:YES];
}


- (void)getRequestIsFirst:(BOOL)isFirst
{
    if (isFirst) {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
    }
    
    dispatch_queue_t network ;
    network = dispatch_queue_create("get_app_rec", nil);
    dispatch_async(network, ^{
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",[NSString stringWithFormat:@"%d",pageSize],@"page_size",[NSString stringWithFormat:@"%d",pageIndex],@"page_index",nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:param method:@"get_app_rec"];
        NSDictionary *json = [JsonUtil jsonToDic:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"]intValue] == 1) {
                [mTableView.infiniteScrollingView stopAnimating];
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
                if (isFirst) {
                    if (array.count == 0) {
                        [hud setCaption:@"暂无应用推荐"];
                        [hud setActivity:NO];
                        [hud update];
                        [hud hideAfter:1.0f];
                    }
                    [hud hideAfter:1.0f];
                }
                
                if (array.count < pageSize)
                {
                    mTableView.infiniteScrollingView.enabled = NO;
                }else
                {
                    pageIndex ++;
                }
                [self.dataArray addObjectsFromArray:array];
                [mTableView reloadData];
            }else
            {
                [mTableView.infiniteScrollingView stopAnimating];

                if ([json objectForKey:@"msgbox"] != NULL) {
                    if (isFirst) {
                        [hud setCaption:[json objectForKey:@"msgbox"] ];
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
        });
    });
    
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
    return 37.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idetifer = @"appAdvice";
    AppAdviceCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil) {
         cell =[[[NSBundle mainBundle]loadNibNamed:@"AppAdviceCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    NSString *appName = [dictionary objectForKey:@"title"];
   
    cell.NmaeLabel.text = appName;
    
    
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundIMG.image = [UIImage imageNamed:@"row_type_1"];
    }
    else
    {
        cell.backgroundIMG.image = [UIImage imageNamed:@"row_type_2"];
    }
    
    
//    cell.DetailLabel.text = [NSString stringWithFormat:@"%@M | %@推荐",[dictionary objectForKey:@"size"],[dictionary objectForKey:@"recommend"]];
    [cell.IconImageView setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"yingyong_pic"]];
    
    cell.DownloadBtn.tag = 10000+indexPath.row;
    [cell.DownloadBtn addTarget:self action:@selector(downLoadApp:) forControlEvents:UIControlEventTouchUpInside];
    if ([self hasInstalled:appName]) {
//        cell.DowloadLabel.text = @"已安装";
        cell.DownloadBtn.hidden = YES;
    }else
    {
//        cell.DowloadLabel.text = @"下载";
        cell.DownloadBtn.hidden = NO;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.row];
    NSString *link_url = [dictionary objectForKey:@"link_url"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link_url]];
}

- (void)downLoadApp:(UIButton *)button
{
    NSInteger tag = button.tag - 10000;
    NSDictionary *dictionary = [self.dataArray objectAtIndex:tag];
    NSString *link_url = [dictionary objectForKey:@"link_url"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:link_url]];

}

- (BOOL)hasInstalled:(NSString *)name
{
    if (self.installedArray) {
        for (NSDictionary *appDictionary in self.installedArray) {
            NSString *trackName = [appDictionary objectForKey:@"trackName"];
            if ([name isEqualToString:trackName]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
