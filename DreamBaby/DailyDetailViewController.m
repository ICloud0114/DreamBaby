//
//  DailyDetailViewController.m
//  GoodMom
//
//  Created by easaa on 7/8/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import "DailyDetailViewController.h"
#import "UIColor+ColorUtil.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "FBEncryptorDES.h"
#import "ATMHud.h"
#import "DayKnowledgeCell.h"
#import "UIImageView+WebCache.h"

@interface DailyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    UITableView *mTableView;
    ATMHud *hud;
    CGFloat webViewHeight;
    DayKnowledgeCell *currentCell;
}

@property (nonatomic ,retain) NSDictionary *infoArray;
@end

@implementation DailyDetailViewController
- (void)dealloc
{
    hud.delegate=nil;
    [hud release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        webViewHeight = 0;
    }
    return self;
}
-(id)initWithDetail:(NSString*)entity
{
    self = [super init];
    if (self) {
        article_id = [entity retain];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    mTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-49) style:UITableViewStylePlain];
    mTableView.showsVerticalScrollIndicator=NO;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    [mTableView release];
    
    hud  = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    [self performSelectorInBackground:@selector(getRequest) withObject:nil];
 
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
            NSMutableDictionary *detailJsonArr=[detailJson objectFromJSONString];
            self.infoArray = detailJsonArr;
//            NSLog(@"info== %@",self.infoArray);
            self.navigationItem.title = [detailJsonArr objectForKey:@"title"];
            
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
            
            
            [mTableView reloadData];
            
//            NSLog(@"---%@",detailJsonArr);
//            NSString *htmlStr=[NSString stringWithFormat:@"<div  style=\'width:320px;overflow:hidden\'>%@</div>",[detailJsonArr valueForKey:@"content"]];
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
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    
//}
//
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    
//    
//
//}
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


#pragma mark -----TableViewDeklegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    
    
    UIImageView * shuruBG = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 67, 2, 67, 29)];
    shuruBG.image = [UIImage imageNamed:@"zhouqi"];
    [view addSubview:shuruBG];
    [shuruBG release];
    
    //专家介绍
    UILabel* jieshaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 50, 15)];
    NSLog(@"time_range==%@",[self.infoArray objectForKey:@"time_range"]);
    
//    if (![[self.infoArray objectForKey:@"time_range"] isEqual:[NSNull null]]) {
//        jieshaoLabel.text = [self.infoArray objectForKey:@"time_range"];
//    }
//    if (jieshaoLabel.text == nil) {
//        jieshaoLabel.text = @"备孕期";
//    }
    
//    NSNumber *time_range = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectWeek"];
    //    NSLog(@"time_range :%d",[time_range intValue]);
//    int week = time_range.intValue;
    if (self.section <= 2)
    {
        jieshaoLabel.text=[NSString stringWithFormat:@"备孕期"];
    }
    else
    {
        jieshaoLabel.text=[NSString stringWithFormat:@"孕%d周",self.section];
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
    if (self.infoArray) {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 213.0f + (webViewHeight > 0 ? webViewHeight:299.0f);
}
//计算怀孕日期
- (NSDate *) calculateHuaiYuanDate
{
  
    
    NSDate *yuanChanDate = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"push"]!= NULL)
    {
        NSDate *huaiYunDate = [NSDate dateWithTimeIntervalSince1970:([yuanChanDate timeIntervalSince1970] - ((280 - self.section * 7 - self.row) * 24 * 60 * 60))];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"push"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return huaiYunDate;
    }
    else
    {
        if (self.section == 2)
        {
            NSDate *huaiYunDate = [NSDate dateWithTimeIntervalSince1970:([yuanChanDate timeIntervalSince1970] - ((280 - self.row) * 24 * 60 * 60))];
            return huaiYunDate;
        }
        else
        {
            NSDate *huaiYunDate = [NSDate dateWithTimeIntervalSince1970:([yuanChanDate timeIntervalSince1970] - ((280 - self.section * 7- self.row) * 24 * 60 * 60))];
            return huaiYunDate;
        }
        
    }
    
//    NSLog(@"section== %d",self.section);
//    NSLog(@"huai = %@", huaiYunDate);
    
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
//        NSLog(@"add_time==%@",[self.infoArray objectForKey:@"add_time"]);
//        NSString *addtime = [self.infoArray objectForKey:@"add_time"];
//        NSDate *date = [self dateFromString:addtime];
        NSDate *date = [self calculateHuaiYuanDate];
        NSString *month = [self monthFromDate:date];
        NSString *day = [self dayFromDate:date];
        NSString *week = [self weekFromDate:date];
        
        cell.WeekLabel.text=week;
        cell.Daylabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        
        NSLog(@"imageUrl = %@",[self.infoArray objectForKey:@"img_url"]);
        if ([self.infoArray objectForKey:@"img_url"] == [NSNull null]|| [[self.infoArray objectForKey:@"img_url"] isEqualToString:@""])
        {
            [cell.IconImage setImage:[UIImage imageNamed:@"icon"]];
            
//            CGRect rect = cell.ContentWeb.frame;
//            rect.origin.y = 60;
//            cell.ContentWeb.frame = rect;
        }
        else
        {
            [cell.IconImage setImageWithURL:[NSURL URLWithString:[self.infoArray objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"icon"]];
        }
        cell.TilLabel.text=[self.infoArray objectForKey:@"title"];
        //html css
        NSString *htmlStr=[NSString stringWithFormat:@"<body style=\"background-color: transparent;margin-right:0px;margin-left:0px;\"> %@",[self.infoArray valueForKey:@"content"]];
        NSString *temstr=@"<style type=\"text/css\">img{max-width:100%;height:auto;} </style>";
        htmlStr = [temstr stringByAppendingString:htmlStr];
        NSLog(@"html = %@",htmlStr);
//        cell.ContentWeb.autoresizesSubviews = YES;
//        cell.ContentWeb.scalesPageToFit = YES;
        [cell.ContentWeb loadHTMLString:htmlStr baseURL:[NSURL URLWithString:IMAGEURL]];
        cell.ContentWeb.backgroundColor = [UIColor clearColor];
        cell.ContentWeb.opaque = NO;
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
        //        cell.ContentWeb.scalesPageToFit = NO;
        cell.ContentWeb.scrollView.scrollEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //            if (stringIsEmpty([[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"content"])==NO) {
        //                cell.ContentLabel.text=[[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"content"];
        //            }
        //            if (arrayIsEmpty([[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"list"])==NO) {
        //                if (stringIsEmpty([[[[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"list"] objectAtIndex:0]objectForKey:@"img_url"])==NO) {
        //                    [cell.IconImage setImageWithURL:[NSURL URLWithString:[[[[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"list"] objectAtIndex:0]objectForKey:@"img_url"]]];
        //                }
        //            }
        //
        //
        //            if (stringIsEmpty([[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"])==NO) {
        //                cell.TilLabel.text=[[[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
        //            }
//        //            //计算日期
//        //            NSDate * putDate =  [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
//        //            NSDate *cellDate=[[putDate dateByAddingTimeInterval:-266*24*60*60] dateByAddingTimeInterval:(indexPath.section-1)*7*24*60*60+(indexPath.row+1)*24*60*60];
//        //            //            NSLog(@"---cell时间===%@",cellDate);
//        //            NSCalendar *calenar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];;
//        //            NSInteger day= [calenar daysFromDate:cellDate toDate:[NSDate date]];
//        //            NSLog(@"---- 相隔时间 %d",day);
//        //            NSDateComponents *dayCom= [self ReturnNSDateComponents:cellDate];
//        //            //                NSDateComponents *weekCom= [self ReturnNSDateComponents:cellDate];
//        //            NSLog(@"---- 相隔---- %d",dayCom.weekday);
//        //            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        //            [dateFormatter setDateFormat:@"MM月dd日"];
//        //            NSString *nowStr = [[NSString alloc]init];
//        //            nowStr = [dateFormatter stringFromDate:cellDate];
//        //            cell.Daylabel.text=nowStr;
//        //            switch (dayCom.weekday) {
//        //                case 1:
//        //                    cell.WeekLabel.text=@"周一";
//        //                    break;
//        //                case 2:
//        //                    cell.WeekLabel.text=@"周二";
//        //                    break;
//        //                case 3:
//        //                    cell.WeekLabel.text=@"周三";
//        //                    break;
//        //                case 4:
//        //                    cell.WeekLabel.text=@"周四";
//        //                    break;
//        //                case 5:
//        //                    cell.WeekLabel.text=@"周五";
//        //                    break;
//        //                case 6:
//        //                    cell.WeekLabel.text=@"周六";
//        //                    break;
//        //                case 7:
//        //                    cell.WeekLabel.text=@"周日";
//        //                    break;
//        //                    
//        //                default:
//        //                    break;
//        //            }
        
    }
    currentCell = cell;
    return cell;
}


- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [dateFormatter release];
    
    return destDate;
    
}

- (NSString *)monthFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld", (long)[dd month]];
    
}

- (NSString *)dayFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld", (long)[dd day]];
}


- (NSString *)weekFromDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSCalendarUnitWeekday;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    NSString *week = @"";
    switch ([dd weekday] - 1) {
        case 0:
            week = @"星期日";
            break;
        case 1:
            week = @"星期一";
            break;
        case 2:
            week = @"星期二";
            break;
        case 3:
            week = @"星期三";
            break;
        case 4:
            week = @"星期四";
            break;
        case 5:
            week = @"星期五";
            break;
        case 6:
            week = @"星期六";
            break;
        default:
            break;
    }
    return week;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
