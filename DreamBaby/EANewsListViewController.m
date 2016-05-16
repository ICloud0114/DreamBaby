//
//  EANewsListViewController.m
//  梦想宝贝
//
//  Created by easaa on 7/10/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EANewsListViewController.h"

#import "EANewsListCell.h"

#import "GovermentAnounceViewController.h"

#import "ATMHud.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "SVPullToRefresh.h"
#import "JsonFactory.h"
#import "UIImageView+WebCache.h"


@interface EANewsListViewController ()
{
    ATMHud *hud;
    NSUInteger pageIndex;
    NSUInteger pageSize;
}
@property (retain, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic ,retain) NSMutableArray *announcementArray;
@end

@implementation EANewsListViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = self.item;
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
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
    // Do any additional setup after loading the view from its nib.
    
    [self.myTableview addInfiniteScrollingWithActionHandler:^{
        [self getGovernmentInfo:NO];
    }];
    self.announcementArray = [NSMutableArray array];
    
    [self getGovernmentInfo:YES];
    
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    RELEASE_SAFE(_announcementArray);
    hud.delegate=nil;
    [hud release];
    [_myTableview release];
    [super dealloc];
}
- (void)viewDidUnload
{

    [self setMyTableview:nil];
    [super viewDidUnload];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.announcementArray) {
        return self.announcementArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    EANewsListCell *cell = [[NSBundle mainBundle]loadNibNamed:@"EANewsListCell" owner:self options:nil][0];
    
    NSDictionary *dictionary = [self.announcementArray objectAtIndex:indexPath.row];
    NSLog(@"dictionary :%@",[dictionary description]);
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.headerPic setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    cell.itemLabel.text = [dictionary objectForKey:@"title"];
    
    cell.contentLabel.text = [[dictionary objectForKey:@"address"] URLDecodedString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dictionary = [self.announcementArray objectAtIndex:indexPath.row];
    
    GovermentAnounceViewController * zixunVC = [[GovermentAnounceViewController alloc]init];
    zixunVC.Id = [dictionary objectForKey:@"id"];
    NSLog(@"zixun==%@",zixunVC.Id);
    [self.navigationController pushViewController:zixunVC animated:YES];
    [zixunVC release];
}

#pragma mark - request government info
- (void)getGovernmentInfo:(BOOL)isFirst
{
    if (isFirst) {
        [hud setCaption:@"加载中"];
        [hud setActivity:YES];
        [hud show];
    }
    
    
//    NSString *type = @"3";
    dispatch_queue_t network;
    network = dispatch_queue_create("get_other_info", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  self.type,@"type",
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
                
                [self.myTableview reloadData];
                [self.myTableview.infiniteScrollingView stopAnimating];
                
                if (array.count < pageSize)
                {
                    self.myTableview.infiniteScrollingView.enabled = NO;
                }else
                {
                    pageIndex ++;
                }
                
                if (isFirst)
                {
                    [hud hideAfter:1.0f];
                }
            }else
            {
                [self.myTableview.infiniteScrollingView stopAnimating];
                
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

@end
