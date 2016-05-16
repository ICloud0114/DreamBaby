//
//  TaijiaoMusicViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "TaijiaoMusicViewController.h"
#import "ZixunCell.h"
#import "AppDelegate.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "JsonUtil.h"
#import "NSString+URLEncoding.h"
#import "UIImageView+WebCache.h"
#import "ATMHud.h"

#import "EAMusicCell.h"
@interface TaijiaoMusicViewController ()
{
    ATMHud *hud;
}
@end

@implementation TaijiaoMusicViewController
- (void)dealloc
{
    RELEASE_SAFE(listArray);
    RELEASE_SAFE(_article_id);
     hud.delegate = nil;
    [hud release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"胎教音乐";
    
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
    
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44 - 49) style:UITableViewStylePlain];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    
    mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mTableView.separatorColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [mTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 49 - 20)];
    }
    
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
        
        if ([[json objectForKey:@"msg"] boolValue]) {
            NSString *listJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
            listJson = [listJson URLDecodedString];
            NSLog(@" 音乐列表=%@",[listJson objectFromJSONString]);
            [listArray setArray:[JsonUtil jsonToArray:listJson]] ;
            [mTableView reloadData];
            [hud hideAfter:1.0f];
        }
        else
        {
            [hud hideAfter:1.0f];
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
        return [listArray  count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString * idetifer = @"zixun";
    EAMusicCell  * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"EAMusicCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell.PlayBtn addTarget:self action:@selector(PlayMovieAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row % 2 == 0 )
    {
        
        cell.backgroundIMG.image = [UIImage imageNamed:@"row_type_1"];

    }
    else
    {
        cell.backgroundIMG.image = [UIImage imageNamed:@"row_type_2"];

    }
    
    
    [cell.headerPic setImageWithURL:[NSURL URLWithString:[[listArray objectAtIndex:indexPath.row] objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"riji_pic03"] ];
    
    
    cell.titleLabel.text=[[listArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    cell.titleLabel.textColor = [UIColor colorwithHexString:@"#F94BB3"];
    
    UIButton* sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame=CGRectMake(0, 0, 320, 35);
    sharebtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [sharebtn setImage:[UIImage imageNamed:@"tongyonglist_icon"] forState:UIControlStateNormal];
    sharebtn.tag = indexPath.row + 2014;
    [cell addSubview:sharebtn];
    [sharebtn addTarget:self action:@selector(PlayMovieAction:) forControlEvents:UIControlEventTouchUpInside];
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    ZixunDetailViewController * zixunVC = [[ZixunDetailViewController alloc]init];
//    [self.navigationController pushViewController:zixunVC animated:YES];
//    [zixunVC release];
    
}
-(void)PlayMovieAction:(UIButton *)button
{
    
     int row = button.tag - 2014;
    NSURL *url = [NSURL URLWithString:[[listArray objectAtIndex:row] objectForKey:@"music_url"]];
    //视频URL
    //视频播放对象
    MPMoviePlayerViewController *moviePlayer = [ [ MPMoviePlayerViewController alloc]initWithContentURL:url];
    moviePlayer.title = @"1111";
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    label.text = @"1111111111111111";
    
    [label release];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.navigationController presentMoviePlayerViewControllerAnimated:moviePlayer];
    [moviePlayer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
