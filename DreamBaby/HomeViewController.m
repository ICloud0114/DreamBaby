//
//  HomeViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "HomeViewController.h"
#import "MyDiaryViewController.h"
#import "AppAdviceViewController.h"
#import "ZixunViewController.h"
#import "MohterComViewController.h"
#import "LoveTipsViewController.h"
#import "ValuableBookViewController.h"
#import "PinceViewController.h"
#import "InfoQueryViewController.h"
#import "GovermentAnounceViewController.h"
#import "EANewsCenterViewController.h"
#import "EAAdDetailViewController.h"


#import "isLogin.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"

#import "UIImageView+WebCache.h"

#import "BMAdScrollView.h"


@interface HomeViewController ()<UIScrollViewDelegate,ValueClickDelegate>
{
    UILabel *dateLabel;
    UILabel *dateLabel1;
    
    BMAdScrollView *AdScrollView;
    
    UIPageControl *pageController;
    NSTimer *myTimer;
    
    NSTimer *moveLabel;
    int page;
    BOOL isBottom;
    
}
@property (nonatomic ,retain) NSMutableArray *dataArray;
@end


@implementation HomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeProductTime) name:@"updateProductDate" object:Nil];
        
    }
    return self;
}

- (void)dealloc
{
    [myTimer finalize];
    [moveLabel finalize];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [AdScrollView pauseTimer];
    self.dataArray = nil;
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{

    
//    [myTimer setFireDate:[NSDate distantPast]];
//    [moveLabel setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [myTimer setFireDate:[NSDate distantFuture]];
//    [moveLabel setFireDate:[NSDate distantFuture]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    UIImageView *titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baby"]];
    [titleImage setFrame:CGRectMake(0, 0, 80, 32)];
    self.navigationItem.titleView = titleImage;
    [titleImage release];
//    self.navigationItem.title = @"梦想宝贝";
//    
//    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.navigationItem setTitleView:titleLabel];
//    
//    if (self.title != nil)
//    {
//        [titleLabel setText:self.title];
//    }
//    if (self.navigationItem.title != nil)
//    {
//        [titleLabel setText:self.navigationItem.title];
//    }
    
    
    //育儿宝典按钮
    yuerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yuerBtn.frame = CGRectMake(10, 144, 145, 80);
    [yuerBtn setTitle:@"孕期宝典" forState:UIControlStateNormal];
    yuerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    yuerBtn.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
    [yuerBtn addTarget:self action:@selector(yuer:) forControlEvents:UIControlEventTouchUpInside];
    [yuerBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn5"] forState:UIControlStateNormal];
    [yuerBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn5_h"] forState:UIControlStateHighlighted];
    [self.view addSubview:yuerBtn];
    
    
    //我的日记按钮
    diaryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    diaryBtn.frame = CGRectMake(10, 228, 145, 50);
    [diaryBtn setTitle:@"我的日记" forState:UIControlStateNormal];
    diaryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    diaryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [diaryBtn addTarget:self action:@selector(diary:) forControlEvents:UIControlEventTouchUpInside];
    [diaryBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn6"] forState:UIControlStateNormal];
    [diaryBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn6_h"] forState:UIControlStateHighlighted];
    [self.view addSubview:diaryBtn];
    

    
    //专家咨询按钮
    zixunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zixunBtn.frame = CGRectMake(10, 282, 145, 80);
    [zixunBtn setTitle:@"专家咨询" forState:UIControlStateNormal];
    zixunBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    zixunBtn.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
    [zixunBtn addTarget:self action:@selector(zixun:) forControlEvents:UIControlEventTouchUpInside];
    [zixunBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn7"] forState:UIControlStateNormal];
    [zixunBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn7_h"] forState:UIControlStateHighlighted];
    [self.view addSubview:zixunBtn];
    
    //关爱提醒按钮
//    loveTipsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    loveTipsBtn.frame = CGRectMake(160-45, 20+120+120, 90, 90);
//    [loveTipsBtn setTitle:@"新闻中心" forState:UIControlStateNormal];
//    loveTipsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//    loveTipsBtn.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
//    [loveTipsBtn addTarget:self action:@selector(loveTips:) forControlEvents:UIControlEventTouchUpInside];
//    [loveTipsBtn setBackgroundImage:[UIImage imageNamed:@"btn08"] forState:UIControlStateNormal];
//    [loveTipsBtn setBackgroundImage:[UIImage imageNamed:@"btn08_h"] forState:UIControlStateHighlighted];
//    [self.view addSubview:loveTipsBtn];

    
    //应用推荐按钮
    appAdviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    appAdviceBtn.frame = CGRectMake(165, 144, 145, 50);
    [appAdviceBtn setTitle:@"应用推荐" forState:UIControlStateNormal];
    appAdviceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    appAdviceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [appAdviceBtn addTarget:self action:@selector(appAdvice:) forControlEvents:UIControlEventTouchUpInside];
    [appAdviceBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn8"] forState:UIControlStateNormal];
    [appAdviceBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn8_h"] forState:UIControlStateHighlighted];
    [self.view addSubview:appAdviceBtn];
    
    
    //妈妈交流按钮
    communicationsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    communicationsBtn.frame = CGRectMake(165, 198, 145, 80);
    [communicationsBtn setTitle:@"妈妈交流" forState:UIControlStateNormal];
    communicationsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    communicationsBtn.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
    [communicationsBtn addTarget:self action:@selector(communication:) forControlEvents:UIControlEventTouchUpInside];
    [communicationsBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn9"] forState:UIControlStateNormal];
    [communicationsBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn9_h"] forState:UIControlStateHighlighted];
    [self.view addSubview:communicationsBtn];
    
    //评测信息按钮
    //信息查询
    
    checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(165, 282, 145, 80);
    [checkBtn setTitle:@"信息查询" forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    checkBtn.titleEdgeInsets = UIEdgeInsetsMake(50, 0, 0, 0);
    [checkBtn addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn10"] forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"bottom_btn10_h"] forState:UIControlStateHighlighted];
    [self.view addSubview:checkBtn];
    
    
    if ([UIScreen mainScreen].bounds.size.height==568) {
        zixunBtn.frame = CGRectMake(zixunBtn.frame.origin.x, zixunBtn.frame.origin.y*1.18+10, zixunBtn.frame.size.width, zixunBtn.frame.size.height);
        communicationsBtn.frame = CGRectMake(communicationsBtn.frame.origin.x, communicationsBtn.frame.origin.y*1.18+10, communicationsBtn.frame.size.width, communicationsBtn.frame.size.height);
        loveTipsBtn.frame = CGRectMake(loveTipsBtn.frame.origin.x, loveTipsBtn.frame.origin.y*1.18+10, loveTipsBtn.frame.size.width, loveTipsBtn.frame.size.height);
        yuerBtn.frame = CGRectMake(yuerBtn.frame.origin.x, yuerBtn.frame.origin.y*1.18+10, yuerBtn.frame.size.width, yuerBtn.frame.size.height);
        appAdviceBtn.frame = CGRectMake(appAdviceBtn.frame.origin.x, appAdviceBtn.frame.origin.y*1.18+10, appAdviceBtn.frame.size.width, appAdviceBtn.frame.size.height);
        checkBtn.frame = CGRectMake(checkBtn.frame.origin.x, checkBtn.frame.origin.y*1.18+10, checkBtn.frame.size.width, checkBtn.frame.size.height);
        diaryBtn.frame = CGRectMake(diaryBtn.frame.origin.x, diaryBtn.frame.origin.y*1.18+10, diaryBtn.frame.size.width, diaryBtn.frame.size.height);
    }
    
    
    //广告
    
    AdScrollView = [[BMAdScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)];
    AdScrollView.vDelegate = self;
    [self.view addSubview:AdScrollView];
    
    
//    page = 0;
//    
//    AdScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)];
//    [self.view addSubview:AdScrollView];
//    
//    [AdScrollView release];
//    
    [self getAdInfomation];
//
//    myTimer=[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changePage:) userInfo:nil repeats:YES];
//    
//    pageController=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 100, 100, 20)];
//    
//    pageController.center=CGPointMake(160, 110);
//    
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 6.0)
//    {
//        pageController.pageIndicatorTintColor=[UIColor grayColor];
//        pageController.currentPageIndicatorTintColor=[UIColor  colorwithHexString:@"#DD2E94"];
//    }
//    
//    [pageController addTarget:self action:@selector(onPageChange:) forControlEvents:UIControlEventValueChanged];
//    
//    [self.view addSubview:pageController];
    //提醒时间
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 450, 20)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont boldSystemFontOfSize:11];
    dateLabel.textColor = [UIColor whiteColor];
    
    
    dateLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(450, 0, 450, 20)];
    dateLabel1.backgroundColor = [UIColor clearColor];
    dateLabel1.textAlignment = NSTextAlignmentCenter;
    dateLabel1.font = [UIFont boldSystemFontOfSize:11];
    dateLabel1.textColor = [UIColor whiteColor];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 20)];
    timeView.backgroundColor = [UIColor clearColor];
    moveLabel =[NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(moveLabel:) userInfo:nil repeats:YES];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    [bgView setBackgroundColor:[UIColor colorwithHexString:@"#DD2E94"]];
    bgView.alpha = 0.3;
    
    [timeView addSubview:bgView];
    
    [timeView addSubview:dateLabel];
    [timeView addSubview:dateLabel1];
    
    [self.view addSubview:timeView];
    
    
    [timeView release];
    [bgView release];
    
    [self noticeProductTime];
    
    //新闻按钮
    UIButton *newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newsBtn setFrame:CGRectMake(0, 0, 46, 30)];
//    [newsBtn setTitle:@"新闻" forState:UIControlStateNormal];
    [newsBtn setImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
    [newsBtn setImage:[UIImage imageNamed:@"btn_01_h"] forState:UIControlStateHighlighted];
    [newsBtn addTarget:self action:@selector(showNewsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:newsBtn];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:newsBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    [newsBtn release];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"fanhui" style:UIBarButtonItemStylePlain target:self action:@selector(who)];
//    self.navigationItem.leftBarButtonItem = bar;
    
}
-(void)moveLabel:(id)sender
{
    [dateLabel setFrame:CGRectMake(dateLabel.frame.origin.x - 1, dateLabel.frame.origin.y, dateLabel.frame.size.width, dateLabel.frame.size.height)];
    
    [dateLabel1 setFrame:CGRectMake(dateLabel1.frame.origin.x - 1, dateLabel1.frame.origin.y, dateLabel1.frame.size.width, dateLabel1.frame.size.height)];
    
    if (dateLabel.frame.origin.x == - 450)
    {
        [dateLabel setFrame:CGRectMake(450, dateLabel.frame.origin.y, dateLabel.frame.size.width, dateLabel.frame.size.height)];
    }
    if (dateLabel1.frame.origin.x == - 450)
    {
        [dateLabel1 setFrame:CGRectMake(450, dateLabel1.frame.origin.y, dateLabel1.frame.size.width, dateLabel1.frame.size.height)];
    }
}

- (void)onPageChange:(id)sender
{
    
}

//-(void)changePage:(id)sender{
//    if (isBottom)
//    {
//        page --;
//    }
//    else
//    {
//        page ++;
//    }
//    if (page == self.dataArray.count)
//    {
//        isBottom = YES;
//    }
//    if (page == 0)
//    {
//        isBottom = NO;
//    }
//    page ++;
//    if (page == self.dataArray.count)
//    {
//        page = 0;
//    }
//    pageController.currentPage = page;
//    [AdScrollView setContentOffset:CGPointMake( page * 320,0)animated:YES];
//}



-(void)getAdInfomation
{
    dispatch_queue_t network ;
    network = dispatch_queue_create("get_advert", nil);
    dispatch_async(network, ^{
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:param method:@"get_advert"];
        NSDictionary *json = [JsonUtil jsonToDic:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"]intValue] == 1)
            {
//                [mTableView.infiniteScrollingView stopAnimating];
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSArray *array = [JsonUtil jsonToArray:dataString];
            
                [self.dataArray addObjectsFromArray:array];
                
                AdScrollView.dataSource = self.dataArray;
                [AdScrollView resumeTimer];
                
                NSLog(@"ad data ---->%@",array);
            }
        });
    });
}


#pragma mark ScrollerView
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int viewPage=scrollView.contentOffset.x/scrollView.frame.size.width;
    pageController.currentPage = viewPage;
}

//广告详情
- (void)showAdDetail:(UIButton *)sender
{
    UIButton *btn = sender;
    NSDictionary *dictionary = [self.dataArray objectAtIndex:btn.tag];
    
    EAAdDetailViewController *adDetail = [[[EAAdDetailViewController alloc]initWithNibName:@"EAAdDetailViewController" bundle:nil]autorelease];
    adDetail.dataDictionary = dictionary;
    [self.navigationController pushViewController:adDetail animated:YES];
}

//fix
- (void)buttonClick:(int)vid value:(NSDictionary *)dictionary
{
    EAAdDetailViewController *adDetail = [[[EAAdDetailViewController alloc]initWithNibName:@"EAAdDetailViewController" bundle:nil]autorelease];
    adDetail.dataDictionary = dictionary;
    [self.navigationController pushViewController:adDetail animated:YES];
}


//新闻中心
- (void)showNewsAction:(id)sender
{
//    LoveTipsViewController * mamVC = [[LoveTipsViewController alloc]init];
//    mamVC.isLoveTip=@"goverment";
//    [self.navigationController pushViewController:mamVC animated:YES];
//    [mamVC release];
    
    
    EANewsCenterViewController *newsCenter = [[[EANewsCenterViewController alloc]initWithNibName:@"EANewsCenterViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:newsCenter animated:YES];
}
- (void)noticeProductTime
{
    IsLogIn *login = [IsLogIn instance];
    
    
    NSLog(@"begin================ 用户名");
    NSLog(@"%@",login.memberData.user_name );
    NSLog(@"end==================");
    NSDate *productDate = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    
    
    int productDay = [self _getTime:productDate];
    
    int week = (280 - productDay) / 7;
    int day = (280 - productDay) % 7;
    NSString *weekString = @"备孕周";
    if (week >= 3)
    {
        if (day == 0)
        {
             weekString = [NSString stringWithFormat:@"孕%d周",week];
        }
        else
        {
             weekString = [NSString stringWithFormat:@"孕%d周%d天",week,day];
        }
       
    }
    
    NSDateFormatter *formtter=[[NSDateFormatter alloc]init];
    formtter.dateFormat=@"YYYY年MM月dd日  EEEE";
    
    if ([weekString isEqualToString:@"备孕周"])
    {
        dateLabel.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ %@ ",login.memberData.user_name,[formtter stringFromDate:[NSDate date]],weekString];
        
        dateLabel1.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ %@ ",login.memberData.user_name,[formtter stringFromDate:[NSDate date]],weekString];
    }
    else
    {
        dateLabel.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ %@ 距离预产期还有%d天",login.memberData.user_name,[formtter stringFromDate:[NSDate date]],weekString,productDay];
        
        dateLabel1.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ %@ 距离预产期还有%d天",login.memberData.user_name,[formtter stringFromDate:[NSDate date]],weekString,productDay];
    }
    
    NSString *weekStr = [NSString stringWithFormat:@"%d",(280 - productDay ) / 7];
    
    if (productDay >= 280)
    {
        dateLabel.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ 备孕周",login.memberData.user_name,[formtter stringFromDate:[NSDate date]]];
        
        dateLabel1.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ 备孕周",login.memberData.user_name,[formtter stringFromDate:[NSDate date]]];

    }
    if (productDay <= 0)
    {
        dateLabel.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ 备孕周",login.memberData.user_name,[formtter stringFromDate:[NSDate date]]];
        
        dateLabel1.text = [NSString stringWithFormat:@"你好，%@ 今天是%@ 备孕周",login.memberData.user_name,[formtter stringFromDate:[NSDate date]]];
    }
    
    [formtter release];
    [[NSUserDefaults standardUserDefaults]setObject:weekStr forKey:@"week"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//-(UIColor *)randomColor
//{
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
//    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//}
//我的日记
- (void)diary:(UIButton *)sender
{
    MyDiaryViewController * myDiaryVC = [[MyDiaryViewController alloc]init];
    [self.navigationController pushViewController:myDiaryVC animated:YES];
    [myDiaryVC release];
}

//信息查询
- (void)check:(UIButton *)sender
{
    InfoQueryViewController * yuerVC = [[InfoQueryViewController alloc]init];
    [self.navigationController pushViewController:yuerVC animated:YES];
    [yuerVC release];
}
- (void)appAdvice:(UIButton *)sender
{
    AppAdviceViewController * appAd = [[AppAdviceViewController alloc]init];
    [self.navigationController pushViewController:appAd animated:YES];
    [appAd release];
}
- (void)yuer:(UIButton *)sender
{
    ValuableBookViewController * yuerVC = [[ValuableBookViewController alloc]init];
    [self.navigationController pushViewController:yuerVC animated:YES];
    [yuerVC release];
}
- (void)zixun:(UIButton *)sender
{
    ZixunViewController * zixunVC = [[ZixunViewController alloc]init];
    [self.navigationController pushViewController:zixunVC animated:YES];
    [zixunVC release];

}
- (void)communication:(UIButton *)sender
{
    MohterComViewController * mamVC = [[MohterComViewController alloc]init];
//    mamVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mamVC animated:YES];
    [mamVC release];

}
- (void)loveTips:(UIButton *)sender
{
    LoveTipsViewController * mamVC = [[LoveTipsViewController alloc]init];
    mamVC.isLoveTip=@"goverment";
    [self.navigationController pushViewController:mamVC animated:YES];
    [mamVC release];
//    GovermentAnounceViewController *cover=[[GovermentAnounceViewController alloc]init];
//    [self.navigationController pushViewController:cover animated:YES];
//    [cover release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//
- (int)_getTime:(NSDate *)lastOnlineTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *nowDate = [dateFormatter dateFromString:nowStr];
    NSTimeInterval time=[lastOnlineTime timeIntervalSinceDate:nowDate];
    int days = ((int)time) / (3600 * 24) - 1;
    [dateFormatter release];
    NSLog(@"days= %d",days);
    return days;
}

@end
