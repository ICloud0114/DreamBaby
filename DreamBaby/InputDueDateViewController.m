//
//  InputDueDateViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "InputDueDateViewController.h"
#import "HomeViewController.h"
#import "NearByViewController.h"
#import "MemberViewController.h"
#import "MoreViewController.h"
#import "MyNavigationController.h"
#import "UIActionSheet+PrivateAction.h"


#import "isLogin.h"
#import "JsonUtil.h"
#import "FBEncryptorDES.h"

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
@interface InputDueDateViewController ()<CLLocationManagerDelegate>
{
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIView *leftView;
    UIView *rightView;
    
    CLLocationManager *lm;
    
}
@end

@implementation InputDueDateViewController

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
    RELEASE_SAFE(putDate);
    RELEASE_SAFE(pickArr);
    RELEASE_SAFE(putDate2);
    [lm stopUpdatingLocation];
    lm.delegate = nil;
    [lm release];
//    mainTabBar.delegate = nil;
    
    [super dealloc];
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    currentIndex = 3;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    putDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    pickArr=[[NSMutableArray alloc]init];
    putDate2 = [[NSDate alloc] initWithTimeIntervalSinceNow:0];

    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"预产期";
    
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
    
    //视图背景
    viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 260)];
    [self.view addSubview:viewBG];
    [viewBG release];

    
//    //左侧选项卡视图
//    leftView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 15, 305, 237)];
//    leftView.userInteractionEnabled = YES;
////    leftView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg02"];
//    [viewBG addSubview:leftView];
//    [leftView release];
    leftView = [[UIView alloc]initWithFrame:CGRectMake(20, 82, 280, 100)];
    
    [leftView setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:leftView];
    //末次月经时间
    UIImageView *lastTime = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yuchangqi_zhouqi"]];
    [lastTime setFrame:CGRectMake(0, 0, 280, 30)];
    [leftView addSubview:lastTime];
    //月经周期
    UIImageView *circleTime = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yuchangqi_zhouqi"]];
    [circleTime setFrame:CGRectMake(0, 32, 280, 30)];
    [leftView addSubview:circleTime];
    
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 30)];
    label1.backgroundColor=[UIColor clearColor];
    label1.textColor=[UIColor colorwithHexString:@"#ffffff"];
    label1.text=@"末次月经时间";
    label1.font=[UIFont systemFontOfSize:14];
    [leftView addSubview:label1];
    
    timeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.tag=1;
    timeBtn.frame=CGRectMake(130, 0, 120, 30);
    timeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [timeBtn setTitleColor:[UIColor colorwithHexString:@"#b4b4b5"] forState:UIControlStateNormal];
//    [timeBtn setBackgroundImage:[UIImage imageNamed:@"pingche_shurukuang"] forState:UIControlStateNormal];
    //末次月经时间
    //NSDate * putDate01 = [[NSUserDefaults standardUserDefaults] objectForKey:LastMenstruation];
    NSDate * putDate01 = [NSDate date];
    if (putDate01!=NULL){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//        NSString *nowStr = [[NSString alloc]init];
       NSString *nowStr = [dateFormatter stringFromDate:putDate01];
        [timeBtn setTitle:nowStr forState:UIControlStateNormal];
        putDate=[putDate01 copy];
       
        [dateFormatter release];
    }
    [timeBtn addTarget:self action:@selector(chooseDateForPreproduction:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:timeBtn];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 32, 120, 30)];
    label2.backgroundColor=[UIColor clearColor];
    label2.textColor=[UIColor colorwithHexString:@"#ffffff"];
    label2.text=@"月经周期（天）";
    label2.font=[UIFont systemFontOfSize:14];
    [leftView addSubview:label2];

//    CGRectMake(212, 173, 65, 35)
    menstrualDayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menstrualDayBtn.tag=3;
    menstrualDayBtn.frame=CGRectMake(130, 32, 65, 35);
    menstrualDayBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [menstrualDayBtn setTitleColor:[UIColor colorwithHexString:@"#b4b4b5"] forState:UIControlStateNormal];
//    [menstrualDayBtn setBackgroundImage:[UIImage imageNamed:@"pingche_shurukuang"] forState:UIControlStateNormal];
//    int menstrualNum = [[[NSUserDefaults standardUserDefaults]objectForKey:MenstruationCycle]integerValue];
//    if (menstrualNum) {
//        [menstrualDayBtn setTitle:[NSString stringWithFormat:@"%d",menstrualNum] forState:UIControlStateNormal];
//    }
    [menstrualDayBtn setTitle:[NSString stringWithFormat:@"%d",28] forState:UIControlStateNormal];
     [menstrualDayBtn addTarget:self action:@selector(chooseMenstrualCycle:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:menstrualDayBtn];
    for (int index=0; index<21; index++) {
        NSString *str=[NSString stringWithFormat:@"%d",index+25];
        [pickArr addObject:str];
    }

    
    
//    //右侧选项卡视图
//    rightView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 15, 305, 170)];
//    rightView.userInteractionEnabled = YES;
////    rightView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg01"];
//    [viewBG addSubview:rightView];
//    [rightView release];
//    rightView.hidden = YES;
    
    rightView = [[UIView alloc]initWithFrame:CGRectMake(20, 82, 280, 100)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    [viewBG addSubview:rightView];
    
    rightView.hidden = YES;
    
    UIImageView *productTime = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yuchangqi_zhouqi"]];
    [lastTime setFrame:CGRectMake(0, 0, 280, 30)];
    [rightView addSubview:productTime];
    
    
    UILabel *label3= [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 30)];
    label3.backgroundColor=[UIColor clearColor];
    label3.textColor=[UIColor colorwithHexString:@"#ffffff"];
    label3.text=@"请输入预产期";
    label3.font=[UIFont systemFontOfSize:14];
    [rightView addSubview:label3];
    
    timeBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn2.tag=2;
    timeBtn2.frame=CGRectMake(160, 0, 115, 35);
    timeBtn2.titleLabel.font=[UIFont systemFontOfSize:12];
    [timeBtn2 setTitleColor:[UIColor colorwithHexString:@"#b4b4b5"] forState:UIControlStateNormal];
//    [timeBtn2 setBackgroundImage:[UIImage imageNamed:@"pingche_shurukuang"] forState:UIControlStateNormal];
//    NSDate * putDate00 = [[NSUserDefaults standardUserDefaults] objectForKey:ProductionDate];
    NSDate * putDate00 = [NSDate date];
    if (putDate00!=NULL){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//        NSString *nowStr = [[NSString alloc]init];
       NSString * nowStr = [dateFormatter stringFromDate:putDate00];
        [timeBtn2 setTitle:nowStr forState:UIControlStateNormal];
        putDate2=[putDate00 copy];
//        [nowStr release];
        [dateFormatter release];
    }
    [timeBtn2 addTarget:self action:@selector(chooseDateForPreproduction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:timeBtn2];

    
    
    
    //左边选项卡按钮
    leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];

    leftBtn.frame=CGRectMake(20, 35+15, 140, 30);
    [leftBtn setTitle:@"计算预产期" forState:UIControlStateNormal];
//    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 0, 0);
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_h"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(changeChooseView:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag=111;
    leftBtn.selected=YES;
    [viewBG addSubview:leftBtn];
    
    //左边选项卡按钮
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(160, 35+15, 140, 30);
    [rightBtn setTitle:@"输入预产期" forState:UIControlStateNormal];
//    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 0, 0);
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_h"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(changeChooseView:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag=112;
    //    leftBtn.selected=YES;
    [viewBG addSubview:rightBtn];
    
    
    
    nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame=CGRectMake(20, 275, 280, 30);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateHighlighted];
//    [sharebtn setBackgroundImage:[UIImage imageNamed:@"riji_tuanchu_btn_h"] forState:UIControlStateHighlighted];
    //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn addTarget:self action:@selector(jumpToNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    
    
    
   

}
//日期按钮
-(void)chooseDateForPreproduction:(UIButton*)sender
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        datePicker = [[[UIDatePicker alloc] init] autorelease];
        if (sender.tag==1) {
            datePicker.date = putDate;
        }else if (sender.tag==2)
        {
            datePicker.date = putDate2;
        }
        datePicker.datePickerMode = UIDatePickerModeDate;
        [alertController.view addSubview:datePicker];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (sender.tag==1) {//选择末次月经时间
                putDate = [datePicker.date copy];
                //flagDate = [datePicker.date copy];
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy年MM月dd日"];
                NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
                //            flagLastTime = [NSString stringWithFormat:@"%@",putDate];
                //            flagLastTime = [flagLastTime stringByReplacingOccurrencesOfString:@"+" withString:@""];
                //            NSLog(@"flagLastTime=====%@",flagLastTime);
                [formater setLocale:usLocale];
                NSString * curTime = [formater stringFromDate:putDate];
                [timeBtn setTitle:curTime forState:UIControlStateNormal];
                [formater release];
            }
            
            else if (sender.tag==2)//输入预产期
            {
                putDate2 = [datePicker.date copy];
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy年MM月dd日"];
                NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
                [formater setLocale:usLocale];
                NSString * curTime = [formater stringFromDate:putDate2];
                [timeBtn2 setTitle:curTime forState:UIControlStateNormal];
                NSDateFormatter *formater2 = [[ NSDateFormatter alloc] init];
                [formater2 setDateFormat:@"yyyy-MM-dd"];
                
                [formater release];
                [formater2 release];
                return;
            }
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil] autorelease];
        actionSheet.tag = sender.tag;
        actionSheet.userInteractionEnabled = YES;
        datePicker = [[[UIDatePicker alloc] init] autorelease];
        if (sender.tag==1) {
            datePicker.date = putDate;
        }else if (sender.tag==2)
        {
            datePicker.date = putDate2;
        }
        datePicker.datePickerMode = UIDatePickerModeDate;
        [actionSheet addSubview:datePicker];
        [actionSheet showInView:self.view];
    }
    
    
    
}
- (void)jumpToNext
{
    
    
    IsLogIn * isLog = [IsLogIn instance];
    
    
    
    if (rightBtn.selected)
    {
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formater stringFromDate:putDate2];
        NSLog(@"%@",putDate2);
        [formater release];
         NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"expected_date",isLog.memberData.idString,@"user_id",nil];
        //输入预产期
        [[NSUserDefaults standardUserDefaults]setObject:putDate2 forKey:ProductionDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
        lm = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled])
        {
            lm.delegate = self;
            lm.desiredAccuracy = kCLLocationAccuracyBest;
            lm.distanceFilter = 1000.0f;
            [lm startUpdatingLocation];
        }
        [self performSelector:@selector(updateProductDateByDictionary:) withObject:dataDic afterDelay:1.0];
//        [self updateProductDateByDictionary:dataDic];
        
    
    }
    else
    {
        
        //输入末次月经时间   月经周期
        
        NSTimeInterval secondsPerDay1 = 24 * 60 * 60 * 280+([[pickArr objectAtIndex:currentIndex] intValue] - 28) * 60 * 60 * 24;
        NSLog(@"%d",[[pickArr objectAtIndex:currentIndex] intValue]);
        
        NSDate *yesterDay = [putDate dateByAddingTimeInterval:secondsPerDay1];
        
        NSDateFormatter *formater2 = [[ NSDateFormatter alloc] init];
        [formater2 setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formater2 stringFromDate:yesterDay];
        [formater2 release];
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"expected_date",isLog.memberData.idString,@"user_id",nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:yesterDay forKey:ProductionDate];
        [[NSUserDefaults standardUserDefaults]setObject:putDate forKey:LastMenstruation];
        [[NSUserDefaults standardUserDefaults]setInteger:[[pickArr objectAtIndex:currentIndex] intValue] forKey:MenstruationCycle];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        lm = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled])
        {
            lm.delegate = self;
            lm.desiredAccuracy = kCLLocationAccuracyBest;
            lm.distanceFilter = 1000.0f;
            [lm startUpdatingLocation];
        }
//         [self updateProductDateByDictionary:dataDic];
        [self performSelector:@selector(updateProductDateByDictionary:) withObject:dataDic afterDelay:1.0];
        
    }
    
    

}


#pragma mark 上传预产期
- (void)updateProductDateByDictionary:(NSDictionary *)DataDictionary
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:DataDictionary method:@"update_user_fetation"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                
                
                
                mainTabBar = [[UITabBarController alloc] init];
                //    mainTabBar.delegate = self;
                mainTabBar.tabBar.backgroundImage = [UIImage imageNamed:@"bottom_btn01"];
                //首页
                HomeViewController *home = [[HomeViewController alloc] init];
                MyNavigationController *homeNavigation = [[MyNavigationController alloc] initWithRootViewController:home];
                RELEASE_SAFE(home);
                //医院信息
                NearByViewController *nearbyVC = [[NearByViewController alloc] init];
                MyNavigationController *nearByNavigation = [[MyNavigationController alloc] initWithRootViewController:nearbyVC ];
                RELEASE_SAFE(nearbyVC);
                //会员信息
                MemberViewController* memberController = [[MemberViewController alloc] init];
                MyNavigationController *memberNavigation = [[MyNavigationController alloc] initWithRootViewController:memberController];
                RELEASE_SAFE(memberController);
                //更多
                MoreViewController *more = [[MoreViewController alloc] init];
                MyNavigationController *moreNavigation = [[MyNavigationController alloc] initWithRootViewController:more];
                RELEASE_SAFE(more);
                [mainTabBar addChildViewController:homeNavigation];
                RELEASE_SAFE(homeNavigation);
                [mainTabBar addChildViewController:nearByNavigation];
                RELEASE_SAFE(nearByNavigation);
                [mainTabBar addChildViewController:memberNavigation];
                RELEASE_SAFE(memberNavigation);
                [mainTabBar addChildViewController:moreNavigation];
                RELEASE_SAFE(moreNavigation);
                
                
                
                //    [[UIApplication sharedApplication].delegate window].rootViewController = mainTabBar;
                [[[UIApplication sharedApplication]keyWindow]setRootViewController:mainTabBar];
                
                mainTabBar.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                //    RELEASE_SAFE(mainTabBar);
                [mainTabBar release];
                
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                
            }else
            {
                
                if ([dictionary objectForKey:@"msgbox"] != nil)
                {
                    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[dictionary objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [av show];
                }
                
            }
        });
    });

}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    MyNavigationController *nowNav = (MyNavigationController *)viewController;
    if ([nowNav isKindOfClass:[MyNavigationController class]])
    {
        if (nowNav.viewControllers.count > 0)
        {
            if (nowNav.viewControllers.count > 1)
            {
                [nowNav popToRootViewControllerAnimated:NO];
            }
            int classId=100;
            if ([nowNav.viewControllers[0] isKindOfClass:[HomeViewController class]]) {
                classId = 0;
            }
            else if ([nowNav.viewControllers[0] isKindOfClass:[NearByViewController class]]){
                classId = 1;
            }
            else if ([nowNav.viewControllers[0] isKindOfClass:[MemberViewController class]]){
                classId = 2;
            }
            else if ([nowNav.viewControllers[0] isKindOfClass:[MoreViewController class]]){
                classId = 3;
            }
            NSLog(@"classId = %d", classId);
            int nowSelect = tabBarController.selectedIndex;
            if (classId == nowSelect)
            {
                return NO;
            }
        }
        
    }


    return YES;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    //返回rootViewController
//    MyNavigationController *nowNav = (MyNavigationController *)viewController;
//    NSLog(@"class = %@",[nowNav.viewControllers[0] class]);
//    if (nowNav.viewControllers.count > 1)
//    {
//        [nowNav popToRootViewControllerAnimated:NO];
//    }
    
    int selectIndex = tabBarController.selectedIndex;
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bottom_btn0%d",selectIndex+1]]];
}
-(void)chooseMenstrualCycle:(UIButton*)sender
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        picker = [[[UIPickerView alloc] init] autorelease];
        picker.tag = sender.tag;
        picker.dataSource = self;
        picker.showsSelectionIndicator=YES;
        picker.delegate = self;
        [alertController.view addSubview:picker];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
            [UIView animateWithDuration:0.3 animations:^{
                
                currentIndex = [picker selectedRowInComponent:0];
                [menstrualDayBtn setTitle:[NSString stringWithFormat:@"%@天",[pickArr objectAtIndex:currentIndex]] forState:UIControlStateNormal];
                flagDays = [[pickArr objectAtIndex:currentIndex]integerValue];
                
            }];
        }];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil] autorelease];
        picker = [[[UIPickerView alloc] init] autorelease];
        picker.tag = sender.tag;
        picker.dataSource = self;
        picker.showsSelectionIndicator=YES;
        picker.delegate = self;
        [actionSheet addSubview:picker];
        actionSheet.tag = sender.tag;
        actionSheet.userInteractionEnabled = YES;
        [actionSheet showInView:self.view];
    }
    
    
}
-(void)changeChooseView:(UIButton*)sender
{
    if (sender.tag== 112) {
//        leftView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg01"];
//        leftView.frame = CGRectMake(7, 15, 305, 170);
        
        leftView.hidden = YES;
        rightView.hidden = NO;
        rightBtn.selected = YES;
        leftBtn.selected = NO;
        
        nextBtn.frame=CGRectMake(20, 275-67, 280, 30);
    }else{
//        leftView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg02"];
//        leftView.frame = CGRectMake(7, 15, 305, 237);
        leftView.hidden = NO;
        rightView.hidden = YES;
        
        rightBtn.selected = NO;
        leftBtn.selected = YES;
        nextBtn.frame=CGRectMake(20, 275, 280, 30);
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (actionSheet.tag==1) {//选择末次月经时间
            putDate = [datePicker.date copy];
            //flagDate = [datePicker.date copy];
            NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy年MM月dd日"];
            NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
            //            flagLastTime = [NSString stringWithFormat:@"%@",putDate];
            //            flagLastTime = [flagLastTime stringByReplacingOccurrencesOfString:@"+" withString:@""];
            //            NSLog(@"flagLastTime=====%@",flagLastTime);
            [formater setLocale:usLocale];
            NSString * curTime = [formater stringFromDate:putDate];
            [timeBtn setTitle:curTime forState:UIControlStateNormal];
            [formater release];
        }
        
        else if (actionSheet.tag==2)//输入预产期
        {
            putDate2 = [datePicker.date copy];
            NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy年MM月dd日"];
            NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
            [formater setLocale:usLocale];
            NSString * curTime = [formater stringFromDate:putDate2];
            [timeBtn2 setTitle:curTime forState:UIControlStateNormal];
            NSDateFormatter *formater2 = [[ NSDateFormatter alloc] init];
            [formater2 setDateFormat:@"yyyy-MM-dd"];
            
            [formater release];
            [formater2 release];
            return;
        }
        else//输入月经周期
        {
            currentIndex = [picker selectedRowInComponent:0];
            [menstrualDayBtn setTitle:[NSString stringWithFormat:@"%@天",[pickArr objectAtIndex:currentIndex]] forState:UIControlStateNormal];
            flagDays = [[pickArr objectAtIndex:currentIndex]integerValue];
        }
        
    }
   // [self jiSuan];
}




#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickArr objectAtIndex:row];
}

#pragma mark -
#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickArr.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 获取定位 ios2.0-6.0
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    [manager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (placemarks.count > 0)
         {
             NSLog(@"城市placemarks:%@,error:%@",[(MKPlacemark *)[placemarks objectAtIndex:0] locality],error);
             
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             [[NSUserDefaults standardUserDefaults]setObject:placemark.locality forKey:CityArea];
             [[NSUserDefaults standardUserDefaults] synchronize];
             //             NSLog(@"---%@",placemark.subLocality);
             [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
         }
     }];
    [geoCoder release];
}

#pragma mark 获取定位 ios6.0-->
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0)
    {
        //        ((CLLocation *)[locations objectAtIndex:0]).coordinate.latitude;
        //        ((CLLocation *)[locations objectAtIndex:0]).coordinate.longitude;
    }
    [manager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:(CLLocation *)[locations objectAtIndex:0] completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (placemarks.count > 0)
         {
             NSLog(@"城市placemarks:%@,error:%@",[(MKPlacemark *)[placemarks objectAtIndex:0] locality],error);
             
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             [[NSUserDefaults standardUserDefaults]setObject:placemark.locality forKey:CityArea];
             [[NSUserDefaults standardUserDefaults] synchronize];
             //             NSLog(@"---%@",placemark.subLocality);
             [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
         }
     }];
    [geoCoder release];
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"未知城市" forKey:CityArea];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //             NSLog(@"---%@",placemark.subLocality);
//    [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self saveSn];
    });
    NSLog(@"manager:%@",manager);
    NSLog(@"error:%@",error);
}
//添加push_user
-(void)saveSn
{
    IsLogIn *login = [IsLogIn instance];
    NSString *userIdString = [NSString stringWithFormat:@"%@",login.memberData.idString];
    //    [APService setTags:nil alias:userIdString callbackSelector:@selector(jpushCallBack:) object:nil];
    NSDate *productDate = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:productDate];
    [formatter release];
    NSDictionary *pushDic=[NSDictionary dictionaryWithObjectsAndKeys:userIdString,@"sn",[[NSUserDefaults standardUserDefaults] objectForKey:CityArea],@"location",[[UIDevice currentDevice] localizedModel],@"model",@"1",@"type",dateString,@"fetation",userIdString,@"user_id",nil];
    [HTTPRequest requestForGetWithPramas:pushDic method:@"add_pushuser"];
    
    NSLog(@"push Dic---%@",pushDic);
}
@end
