//
//  YuerHistoryViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "YuerHistoryViewController.h"
#import "ZixunCell.h"
#import "GovermentAnounceViewController.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "JsonUtil.h"
#import "NSString+URLEncoding.h"
#import "UIImageView+WebCache.h"
#import "ATMHud.h"

@interface YuerHistoryViewController ()
{
    ATMHud *hud;
}
@end

@implementation YuerHistoryViewController

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
    RELEASE_SAFE(listArray);
    RELEASE_SAFE(_article_id);
    RELEASE_SAFE(_myBackMusic);
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"育儿故事";
    
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
    
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-49) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    [mTableView release];
    
    listArray=[[NSMutableArray alloc]init];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    [self performSelectorInBackground:@selector(getRequest) withObject:nil];


}


-(void)getRequest
{
    NSDictionary *sendDic=[NSDictionary dictionaryWithObjectsAndKeys:self.article_id,@"id", nil];
    NSString *reuquest=[HTTPRequest requestForGetWithPramas:sendDic method:@"get_musics"];
    NSDictionary *json=[JsonUtil jsonToDic:reuquest];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAfter:1.0f];
        
        if ([[json objectForKey:@"msg"] boolValue]) {
            NSString *listJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
            listJson = [listJson URLDecodedString];
            NSLog(@" 音乐列表=%@",[listJson objectFromJSONString]);
            [listArray setArray:[JsonUtil jsonToArray:listJson]] ;
            [mTableView reloadData];
        }
        else
        {
            if ([json objectForKey:@"msgbox"]!=NULL) {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[json objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);
                NSLog(@"error :%@", [json objectForKey:@"msgbox"]);
            }
            else
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取数据失败,可能是你的网络不给力!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);
            }
        }
    });
    
    
    
}

#pragma mark -----TableViewDeklegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (listArray) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listArray) {
        return listArray.count;
    }
    return 0;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idetifer = @"zixun";
    ZixunCell  * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ZixunCell" owner:self options:nil]objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.PlayBtn addTarget:self action:@selector(PlayMovieAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.IconImageView setImageWithURL:[NSURL URLWithString:[[listArray objectAtIndex:indexPath.row] objectForKey:@"img_url"]]placeholderImage:[UIImage imageNamed:@"list_pic"]];
    cell.NameLabel.text = [[listArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    
 
    /**
     *
     */
    NSString *title = [[listArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *content = [[listArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    content = [content URLDecodedString];
    
    GovermentAnounceViewController * zixunVC = [[GovermentAnounceViewController alloc]init];
    [zixunVC setValue:@"003" forKey:@"flageType"];
    zixunVC.title = title;
    zixunVC.content = content;
    [self.navigationController pushViewController:zixunVC animated:YES];
    [zixunVC release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
