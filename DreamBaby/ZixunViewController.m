//
//  ZixunViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ZixunViewController.h"
#import "ZixunCell.h"
#import "ZixunDetailViewController.h"

#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "SVPullToRefresh.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"


#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"

#import "UIImageView+WebCache.h"


#import "EADoctorCell.h"
@interface ZixunViewController ()
{
    ATMHud *hud;
    NSInteger pageIndex;
    NSInteger pageSize;
}

@property (nonatomic ,retain) NSMutableArray *dataArray;
@end

@implementation ZixunViewController

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
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"专家咨询";
    
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
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(10, 20, 300, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 49 - 20) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    [mTableView release];

    /**
     *  刷新
     */
    
    
    [mTableView addInfiniteScrollingWithActionHandler:^{
        [self refreshRequest];
    }];
    
    
    //
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];

    [self firstRequest];
}


#pragma mark - request

- (void)firstRequest
{
    [hud setCaption:@"加载中.."];
    [hud setActivity:YES];
    [hud show];
    
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("get_other_info", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",
                              [NSString stringWithFormat:@"%d",pageSize],@"page_size",
                              [NSString stringWithFormat:@"%d",pageIndex],@"page_index",nil];
        
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"get_other_info"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"dict1:%@",[dictionary description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1) {
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array =  [JsonUtil jsonToArray:dataString];
                [self.dataArray  addObjectsFromArray:array];
                if (array.count < 10) {
                    mTableView.infiniteScrollingView.enabled = NO;
                }else
                {
                    pageIndex ++;
                }
                [hud hideAfter:1.0f];
                [mTableView reloadData];
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"] ];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                    
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                }
                [hud hideAfter:1.0f];
            }
            
            [mTableView.infiniteScrollingView stopAnimating];
            
        });
    });
}


- (void)refreshRequest
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("get_note_info_type1", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",
                              [NSString stringWithFormat:@"%d",pageSize],@"page_size",
                              [NSString stringWithFormat:@"%d",pageIndex],@"page_index",nil];
        
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"get_other_info"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"dict2:%@",[dictionary description]);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1) {
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array =  [JsonUtil jsonToArray:dataString];
                [self.dataArray  addObjectsFromArray:array];
                if (array.count < 10) {
                    mTableView.infiniteScrollingView.enabled = NO;
                }else
                {
                    pageIndex ++;
                }
                [mTableView reloadData];
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                  
                }else
                {
                    
                }
            }
            
            [mTableView.infiniteScrollingView stopAnimating];
            [mTableView.infiniteScrollingView stopAnimating];
        });
        
    });
}

- (void)loadMoreToRequest
{
    
}

#pragma mark -----TableViewDeklegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 5)];
    myView.backgroundColor = [UIColor clearColor];
    
    return [myView autorelease];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArray) {
        return self.dataArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idetifer = @"zixun";
    EADoctorCell  * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EADoctorCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.section];

//    NSString *name =  [@"专家咨询:" stringByAppendingString:[dictionary objectForKey:@"title"]];
//    [cell.NameLabel setText:name];
    [cell.doctorName setText:[dictionary objectForKey:@"title"]];
    
    NSString *info = [dictionary objectForKey:@"address"];
    info = [info URLDecodedString];
//    info = [@"擅长: " stringByAppendingString:info];
    [cell.doctorDetail setText:info];
    
    NSString *imageUrl = [dictionary objectForKey:@"img_url"];
    if (![imageUrl hasPrefix:@"http://"]) {
        imageUrl = [@"http://" stringByAppendingString:imageUrl];
    }
    [cell.doctorPicture setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.section];

    ZixunDetailViewController * zixunVC = [[ZixunDetailViewController alloc]init];
    zixunVC.Id = [dictionary objectForKey:@"id"];
    [zixunVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:zixunVC animated:YES];
    [zixunVC release];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
