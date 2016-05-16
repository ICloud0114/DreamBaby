//
//  KnowledgeDetailViewController.m
//  DreamBaby
//
//  Created by easaa on 2/13/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "KnowledgeDetailViewController.h"
#import "DayKnowledgeCell.h"
#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "FBEncryptorDES.h"
#import "HTTPRequest.h"
#import "ATMHud.h"

#import "ZZAutoSizeImageView.h"

@interface KnowledgeDetailViewController ()<UIWebViewDelegate>
{
    ATMHud *hud;
    NSMutableDictionary *detailJsonMutableDicionary;
    CGFloat webViewHeight;
}
@end

@implementation KnowledgeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    webViewHeight = 0;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        detailJsonMutableDicionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(id)initWithDetail:(NSString*)entity Week:(int)num Weekday:(NSString *)weekday Date:(NSString *)date Title:(NSString *)title Image:(UIImage *)image
{
    self = [super init];
    if (self) {
        article_id = [entity retain];
        weekNum = num;
        weekdayStr=[weekday retain];
        dateStr=[date retain];
        titleStr=[title retain];
        iconImage=[image retain];
    }
    return self;
}
- (void)dealloc
{
    hud.delegate = nil;
    RELEASE_SAFE(hud);
    RELEASE_SAFE(iconImage);
    RELEASE_SAFE(titleStr);
    RELEASE_SAFE(dateStr);
    RELEASE_SAFE(weekdayStr);
    RELEASE_SAFE(article_id);
    RELEASE_SAFE(webStr);
    [detailJsonMutableDicionary release];
    
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"每日知识";
    
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

    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    [self performSelectorInBackground:@selector(getRequest) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getRequest
{
    //    NSString *snToken=@"123";
    
    NSDictionary *zixundetailDic=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"user_id",article_id,@"article_id",@"",@"sn",nil];
    NSString *reuquest=[HTTPRequest requestForGetWithPramas:zixundetailDic method:@"get_article_info"];
    [self performSelectorOnMainThread:@selector(JSonToChangeUI:) withObject:reuquest waitUntilDone:NO];
    
}
-(void)JSonToChangeUI:(NSString*)reuquest
{
    [hud hideAfter:1.0f];
    
    NSDictionary *json=[reuquest objectFromJSONString];
    if (json) {
        if ([[json objectForKey:@"msg"] boolValue]) {
            NSString *detailJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
            detailJson = [detailJson URLDecodedString];
        
            NSDictionary * returnDictionary =[detailJson objectFromJSONString];
            if ([returnDictionary isKindOfClass:[NSDictionary class]])
            {
                [detailJsonMutableDicionary setDictionary:returnDictionary];

            }
            
//            self.title=[detailJsonArr objectForKey:@"title"];
//            NSLog(@"---%@",detailJsonArr);
//            NSString *htmlStr=[NSString stringWithFormat:@"<style type=\"text/css\">body{background:#E2C9D7;}</style>%@",[detailJsonMutableDicionary valueForKey:@"content"]];
            NSString *htmlStr=[NSString stringWithFormat:@"<body style=\"background-color: transparent;margin-right:0px;margin-left:0px;\">%@",[detailJsonMutableDicionary valueForKey:@"content"]];
//            NSString *htmlStr=[detailJsonMutableDicionary valueForKey:@"content"];
            NSLog(@"%@",htmlStr);
            webStr =[htmlStr retain];
            [mTableView reloadData];
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            webview.delegate=self;
//            [webview loadHTMLString:[detailJsonArr valueForKey:@"content"]  baseURL:nil];
//            [self.view addSubview:webview];
//            RELEASE_SAFE(webview);
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
        
    }else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取数据失败,可能是你的网络不给力!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];
        RELEASE_SAFE(av);
    }
    
}


#pragma mark -----TableViewDeklegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    
    
    UIImageView * shuruBG = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 67, 2, 67, 29)];
    shuruBG.image = [UIImage imageNamed:@"zhouqi"];
    [view addSubview:shuruBG];
    [shuruBG release];
    
    //专家介绍
    UILabel* jieshaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 50, 15)];
    if (weekNum==0)
    {
        jieshaoLabel.text=[NSString stringWithFormat:@"备孕期"];
    }
    else
    {
        jieshaoLabel.text=[NSString stringWithFormat:@"孕%d周",weekNum];
    }
    jieshaoLabel.font = [UIFont boldSystemFontOfSize:14];
    jieshaoLabel.backgroundColor = [UIColor clearColor];
    jieshaoLabel.textColor =[UIColor whiteColor];
    jieshaoLabel.textAlignment = NSTextAlignmentLeft;
    [shuruBG addSubview:jieshaoLabel];
    [jieshaoLabel release];
    
    
    return  [view autorelease];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 213.0f + (webViewHeight > 0 ? webViewHeight:299.0f);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idetifer = @"dayKnowledge";
    DayKnowledgeCell  * cell = [tableView dequeueReusableCellWithIdentifier:idetifer ];
    if (cell==nil)
    {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"DayKnowledgeCell" owner:self options:nil]objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.TilLabel.text=titleStr;
        cell.WeekLabel.text=weekdayStr;
        cell.Daylabel.text=dateStr;
        if ([detailJsonMutableDicionary objectForKey:@"img_url"] == [NSNull null]|| [[detailJsonMutableDicionary objectForKey:@"img_url"] isEqualToString:@""])
        {
            [cell.IconImage setImage:[UIImage imageNamed:@"icon"]];
        }
        else
        {
            [cell.IconImage setImageWithURL:[NSURL URLWithString:[detailJsonMutableDicionary objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"icon"]];
        }

//        ZZAutoSizeImageView *photoImage = [[ZZAutoSizeImageView alloc]initWithFrame:CGRectMake(10, 75, 300, 147)];
//        [cell addSubview:photoImage];
//        if ([[detailJsonMutableDicionary objectForKey:@"img_url"] isEqualToString:@""])
//        {
//            
////            [photoImage setImage:[UIImage imageNamed:@"icon"]];
//            [photoImage setPlaceholderImage:[UIImage imageNamed:@"icon"]];
//        }
//        else
//        {
//            [photoImage setPlaceholderImage:[UIImage imageNamed:@"icon"]];
//            [photoImage setImageWithURL:[NSURL URLWithString:[detailJsonMutableDicionary objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"icon"]];
//            NSLog(@"----->image url %@",[detailJsonMutableDicionary objectForKey:@"img_url"]);
//        }
//        [photoImage release];
//
//        cell.IconImage.image=iconImage;
        
        cell.ContentWeb.backgroundColor = [UIColor clearColor];
        cell.ContentWeb.opaque = NO;
        [cell.ContentWeb loadHTMLString:webStr baseURL:Nil];
        if (!webViewHeight)
        {
           cell.ContentWeb.delegate = self;
        }
        else
        {
            CGRect webFrame = cell.ContentWeb.frame;
            webFrame.size.height = webViewHeight;
            cell.ContentWeb.frame = webFrame;
        }
        cell.ContentWeb.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        cell.ContentWeb.scalesPageToFit = NO;
        cell.ContentWeb.scrollView.scrollEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    currentCell = cell;
    
    return cell;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if (webView.scrollView.contentSize.height > webView.frame.size.height)
    {
        CGRect rect = webView.frame;
        rect.size.height = webView.scrollView.contentSize.height;
        [webView setFrame:rect];
        webViewHeight = webView.scrollView.contentSize.height;
        NSLog(@"web height---->%f",webViewHeight);
        [mTableView reloadData];
//        [bgView setFrame:CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.size.width, webView.frame.origin.y + webView.frame.size.height)];
//        [listView setFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height, contentScrollerView.frame.size.width, listView.frame.size.height)];
//        [contentScrollerView setContentSize:CGSizeMake(contentScrollerView.frame.size.width, listView.frame.origin.y + listView.frame.size.height)];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == mTableView)
    {
        if (currentCell.ContentWeb.scrollView.contentSize.height > currentCell.ContentWeb.frame.size.height)
        {
            CGRect rect = currentCell.ContentWeb.frame;
            rect.size.height = currentCell.ContentWeb.scrollView.contentSize.height;
            [currentCell.ContentWeb setFrame:rect];
            webViewHeight = currentCell.ContentWeb.scrollView.contentSize.height;
            NSLog(@"web height---->%f",webViewHeight);
            [mTableView reloadData];

        }
    }
 
}

@end
