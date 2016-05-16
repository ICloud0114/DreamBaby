//
//  GovernmentViewController.m
//  DreamBaby
//
//  Created by easaa on 14-2-13.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "GovernmentViewController.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"

#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "ATMHud.h"
#import "SVPullToRefresh.h"
#import "MoreControllerCell.h"
#import "GovermentAnounceViewController.h"

@interface GovernmentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ATMHud *hud;
    UITableView * goverTableView;
    NSUInteger pageIndex;
    NSUInteger pageSize;
}

@property (nonatomic ,retain) NSMutableArray *announcementArray;

@end

@implementation GovernmentViewController

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
     hud.delegate = nil;
    [hud release];
    RELEASE_SAFE(_announcementArray);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"公告";
    
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
    self.announcementArray = tempArray;

    
    CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    goverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-49) style:UITableViewStyleGrouped];
    if(version>=7.0f){
        goverTableView.frame = CGRectMake(10, 0, 300, self.view.frame.size.height-44-49);
    }
    goverTableView.backgroundView = nil;
    goverTableView.backgroundColor = [UIColor clearColor];
    goverTableView.delegate = self;
    goverTableView.dataSource = self;
    [self.view addSubview:goverTableView];
    [goverTableView release];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [goverTableView addInfiniteScrollingWithActionHandler:^{
        [self getGovernmentInfo:NO];
    }];
    
    [self getGovernmentInfo:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark---TableVeiw methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (self.announcementArray) {
        return self.announcementArray.count;
    }
    return 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
//    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:nil];
    
    
    static NSString *identifier = @"MoreControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"MoreControllerCell" owner:self options:nil]lastObject];
        ((MoreControllerCell *)cell).moreArticalLabel.textColor = [UIColor blackColor];
//        ((MoreControllerCell *)cell).moreStateLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_arrow"]];
//        cell.accessoryView = view ;-
//        [view release];
//        UIImageView *accessory = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_arrow"]];
//        
//        cell.accessoryView = accessory;
//        [accessory release];
        
    }
    
//    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
    NSDictionary *dictionary = [self.announcementArray objectAtIndex:indexPath.row];
    NSLog(@"dictionary :%@",[dictionary description]);
    
    ((MoreControllerCell *)cell).textLabel.text = [dictionary objectForKey:@"title"];
    ((MoreControllerCell *)cell).moreArticalLabel.hidden = YES;
//    ((MoreControllerCell *)cell).moreStateLabel.hidden = YES;
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
    
    
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        NSDictionary *dictionary = [self.announcementArray objectAtIndex:indexPath.row];
        
        GovermentAnounceViewController * zixunVC = [[GovermentAnounceViewController alloc]init];
        zixunVC.Id = [dictionary objectForKey:@"id"];
        [self.navigationController pushViewController:zixunVC animated:YES];
        [zixunVC release];
    
  
}
@end
