//
//  ModifyDueDateViewController.m
//  GoodMom
//
//  Created by easaa on 13-7-26.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import "ModifyDueDateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ColorUtil.h"
#import "IsLogIn.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "JsonUtil.h"
#import "UIActionSheet+PrivateAction.h"

@interface ModifyDueDateViewController ()
{
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIView *leftView;
    UIView *rightView;
    
}
@end

@implementation ModifyDueDateViewController

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
//    RELEASE_SAFE(bgView);
//    RELEASE_SAFE(headView);
    RELEASE_SAFE(pickArr);
    RELEASE_SAFE(putDate);
    RELEASE_SAFE(putDate2);
    RELEASE_SAFE(flagProductionDate);
    RELEASE_SAFE(flagYesterDay);
    RELEASE_SAFE(leftView);
    RELEASE_SAFE(rightView);
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"预产期修改";
    
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
    
    putDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    pickArr=[[NSMutableArray alloc]init];
    putDate2 = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    
    UIButton *rightTopbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightTopbtn.frame=CGRectMake( 0, 0,60, 35);
    [rightTopbtn setTitle:@"完成" forState:UIControlStateNormal];
    rightTopbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightTopbtn setBackgroundImage:[UIImage imageNamed:@"top_btn1"] forState:UIControlStateNormal];
    [rightTopbtn setBackgroundImage:[UIImage imageNamed:@"top_btn1_h"] forState:UIControlStateHighlighted];

    [rightTopbtn addTarget:self action:@selector(conformBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *tightItem = [[UIBarButtonItem alloc] initWithCustomView:rightTopbtn];
    self.navigationItem.rightBarButtonItem = tightItem;
    [tightItem release];
    
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
    NSDate * putDate01 = [[NSUserDefaults standardUserDefaults]objectForKey:LastMenstruation];
    if (putDate01!=NULL)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        //        NSString *nowStr = [[NSString alloc]init];
        NSString *nowStr = [dateFormatter stringFromDate:putDate01];
        [timeBtn setTitle:nowStr forState:UIControlStateNormal];
        putDate=[putDate01 copy];
        
        [dateFormatter release];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *nowStr = [dateFormatter stringFromDate:[NSDate date]];
        [timeBtn setTitle:nowStr forState:UIControlStateNormal];
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
    for (int index=0; index<21; index++)
    {
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
    NSDate * putDate00 = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    if (putDate00!=NULL)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        //        NSString *nowStr = [[NSString alloc]init];
        NSString * nowStr = [dateFormatter stringFromDate:putDate00];
        [timeBtn2 setTitle:nowStr forState:UIControlStateNormal];
        putDate2=[putDate00 copy];
        //        [nowStr release];
        [dateFormatter release];
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        //        NSString *nowStr = [[NSString alloc]init];
        NSString * nowStr = [dateFormatter stringFromDate:[NSDate date]];
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
    
    
    for (int index=0; index<21; index++)
    {
        NSString *str=[NSString stringWithFormat:@"%d",index+25];
        [pickArr addObject:str];
    }
    /*右侧选项卡视图
     *
     *
     *
     */
    
    flagProductionDate = [[NSMutableString alloc]init];
    flagYesterDay=[[NSDate alloc]init];
}
- (NSDate *)changToDate:(NSString *)longStr
{
    
    NSRange left = [longStr rangeOfString:@"("];
    NSRange right = [longStr rangeOfString:@")"];
    NSRange range  = {left.location+1,right.location - left.location-1};
    NSString *temp = [longStr substringWithRange:range];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[temp longLongValue]/1000];
    return date;
}
- (void)conformBtnPressed:(UIButton *)sender
{
    NSLog(@"确定了");
    
    IsLogIn * isLog = [IsLogIn instance];
    if (isLog.isLogIn) {
        //左侧选项卡点击保存
        if (!leftView.hidden) {
            if (timeBtn.titleLabel.text!=NULL&&menstrualDayBtn.titleLabel.text!=NULL){
                NSTimeInterval secondsPerDay1 = 24*60*60*280+([menstrualDayBtn.titleLabel.text intValue]-28)*60*60*24;
                //NSLog(@"%d",[[pickArr objectAtIndex:currentIndex] intValue]);
                NSDate *yesterDay = [putDate dateByAddingTimeInterval:secondsPerDay1];
                NSLog(@"yesterDay=======%@",yesterDay);
                flagYesterDay=[yesterDay copy];
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy-MM-dd"];
                [flagProductionDate setString:[formater stringFromDate:yesterDay]];
                [formater release];
                
                [[NSUserDefaults standardUserDefaults]setObject:putDate forKey:LastMenstruation];
                [[NSUserDefaults standardUserDefaults]setInteger:[menstrualDayBtn.titleLabel.text intValue] forKey:MenstruationCycle];
                //            NSLog(@"----%@",flagYesterDay);
                [[NSUserDefaults standardUserDefaults]setObject:yesterDay forKey:ProductionDate];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSDateFormatter *formater2 = [[NSDateFormatter alloc]init];
                [formater2 setDateFormat:@"yyyy年MM月dd日"];
                NSString *dateString = [formater2 stringFromDate:yesterDay];
                [formater2 release];
                NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"expected_date",isLog.memberData.idString,@"user_id",nil];
                
                [self updateProductDateByDictionary:dataDic];
                
                NSLog(@"flagProductionDate=======%@",flagProductionDate);
                
            }else
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，您还没有填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);
                return;
            }
        }else
        {
            if (timeBtn2.titleLabel.text!=NULL){
                [flagProductionDate setString:timeBtn2.titleLabel.text];
                
                [[NSUserDefaults standardUserDefaults]setObject:putDate2 forKey:ProductionDate];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                NSDateFormatter *formater2 = [[NSDateFormatter alloc]init];
                [formater2 setDateFormat:@"yyyy年MM月dd日"];
                NSString *dateString = [formater2 stringFromDate:putDate2];
                [formater2 release];
                NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"expected_date",isLog.memberData.idString,@"user_id",nil];

                [self updateProductDateByDictionary:dataDic];
            
            }else
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，您还没有填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);
                return;
            }
            
        }
        
    }else               //本地用户保存
    {
        if (!leftView.hidden) {
            if (timeBtn.titleLabel.text!= NULL && menstrualDayBtn.titleLabel.text != NULL) {
                NSTimeInterval secondsPerDay1 = 24*60*60*280+([menstrualDayBtn.titleLabel.text intValue]-28)*60*60*24;
                //NSLog(@"%d",[[pickArr objectAtIndex:currentIndex] intValue]);
                NSDate *yesterDay = [putDate dateByAddingTimeInterval:secondsPerDay1];
                //                NSLog(@"yesterDay=======%@",yesterDay);
                flagYesterDay=[yesterDay copy];
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy-MM-dd"];
                [flagProductionDate setString:[formater stringFromDate:yesterDay]];
                [formater release];
                //                NSLog(@"flagProductionDate=======%@",flagProductionDate);
                //                NSLog(@"1,%@",flagDate);
                //                NSLog(@"2,%@",menstrualDayBtn.titleLabel.text);
                [[NSUserDefaults standardUserDefaults]setObject:putDate forKey:LastMenstruation];
                [[NSUserDefaults standardUserDefaults]setInteger:[menstrualDayBtn.titleLabel.text intValue] forKey:MenstruationCycle];
                //            NSLog(@"----%@",flagYesterDay);
                [[NSUserDefaults standardUserDefaults]setObject:yesterDay forKey:ProductionDate];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
              
                RELEASE_SAFE(av);
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，您还没有填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);
                return;
            }
        }else
        {
            if (timeBtn2.titleLabel.text!=NULL) {
                //            NSLog(@"----%@",putDate);
                [[NSUserDefaults standardUserDefaults]setObject:putDate2 forKey:ProductionDate];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，您还没有填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);
                return;
            }
        }
        //本地左侧保存
        
    }
}
#pragma mark 上传预产期
- (void)updateProductDateByDictionary:(NSDictionary *)DataDictionary
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("update_user_fetation", nil);
    dispatch_async(network_queue, ^{
        
        NSString *request = [HTTPRequest requestForGetWithPramas:DataDictionary method:@"update_user_fetation"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[dictionary objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [av show];
                RELEASE_SAFE(av);

                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateProductDate" object:Nil];
                [self.navigationController popViewControllerAnimated:YES];
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

-(void)changeChooseView:(UIButton*)sender
{
    if (sender.tag== 112) {
        //        leftView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg01"];
        //        leftView.frame = CGRectMake(7, 15, 305, 170);
        leftView.hidden = YES;
        rightView.hidden = NO;
        rightBtn.selected = YES;
        leftBtn.selected = NO;
    }else{
        //        leftView.image = [UIImage imageNamed:@"yunqi_shurukuang_bg02"];
        //        leftView.frame = CGRectMake(7, 15, 305, 237);
        leftView.hidden = NO;
        rightView.hidden = YES;
        
        rightBtn.selected = NO;
        leftBtn.selected = YES;
    }
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
            if (sender.tag==1)
            {//选择末次月经时间
                putDate = [datePicker.date copy];
                flagDate = [datePicker.date copy];
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy年MM月dd日"];
                NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
                //            flagLastTime = [NSString stringWithFormat:@"%@",putDate];
                //            flagLastTime = [flagLastTime stringByReplacingOccurrencesOfString:@"+" withString:@""];
                //            NSLog(@"flagLastTime=====%@",flagLastTime);
                [formater setLocale:usLocale];
                NSString * curTime = [formater stringFromDate:putDate];
                [formater release];
                [timeBtn setTitle:curTime forState:UIControlStateNormal];
            }else if (sender.tag==2)//输入预产期
            {
                putDate2 = [datePicker.date copy];
                NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy年MM月dd日"];
                NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
                [formater setLocale:usLocale];
                NSString * curTime = [formater stringFromDate:putDate2];
                [formater release];
                [timeBtn2 setTitle:curTime forState:UIControlStateNormal];
                NSDateFormatter *formater2 = [[ NSDateFormatter alloc] init];
                [formater2 setDateFormat:@"yyyy-MM-dd"];
                [flagProductionDate setString:[formater2 stringFromDate:putDate2]];
                [formater2 release];
                NSLog(@"flagProductionDate=======%@",flagProductionDate);
                
                return;
            }
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (actionSheet.tag==1)
        {//选择末次月经时间
            putDate = [datePicker.date copy];
            flagDate = [datePicker.date copy];
            NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy年MM月dd日"];
            NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
            //            flagLastTime = [NSString stringWithFormat:@"%@",putDate];
            //            flagLastTime = [flagLastTime stringByReplacingOccurrencesOfString:@"+" withString:@""];
            //            NSLog(@"flagLastTime=====%@",flagLastTime);
            [formater setLocale:usLocale];
            NSString * curTime = [formater stringFromDate:putDate];
            [formater release];
            [timeBtn setTitle:curTime forState:UIControlStateNormal];
        }else if (actionSheet.tag==2)//输入预产期
        {
            putDate2 = [datePicker.date copy];
            NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy年MM月dd日"];
            NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
            [formater setLocale:usLocale];
            NSString * curTime = [formater stringFromDate:putDate2];
            [formater release];
            [timeBtn2 setTitle:curTime forState:UIControlStateNormal];
            NSDateFormatter *formater2 = [[ NSDateFormatter alloc] init];
            [formater2 setDateFormat:@"yyyy-MM-dd"];
            [flagProductionDate setString:[formater2 stringFromDate:putDate2]];
            [formater2 release];
            NSLog(@"flagProductionDate=======%@",flagProductionDate);
            
            return;
        }
        else//输入月经周期
        {
            currentIndex = [picker selectedRowInComponent:0];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect leftRect = viewBG.frame;
                viewBG.frame = CGRectMake(leftRect.origin.x, leftRect.origin.y + 100, leftRect.size.width, leftRect.size.height);
            }];
            [menstrualDayBtn setTitle:[NSString stringWithFormat:@"%@天",[pickArr objectAtIndex:currentIndex]] forState:UIControlStateNormal];
            flagDays = [[pickArr objectAtIndex:currentIndex]integerValue];
            [self jiSuan];
            return;
        }
        
    }
    if (actionSheet.tag == 3) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect leftRect = viewBG.frame;
            viewBG.frame = CGRectMake(leftRect.origin.x, leftRect.origin.y + 100, leftRect.size.width, leftRect.size.height);
        }];
    }
    [self jiSuan];
}
- (void)jiSuan
{
    
    NSLog(@"menstrualDayBtn.titleLabel.text=======%@",menstrualDayBtn.titleLabel.text);
    if (timeBtn.titleLabel.text!=NULL&&menstrualDayBtn.titleLabel.text!=NULL){
        NSTimeInterval secondsPerDay1 = 24*60*60*280+([menstrualDayBtn.titleLabel.text intValue]-28)*60*60*24;
        //NSLog(@"%d",[[pickArr objectAtIndex:currentIndex] intValue]);
        NSDate *yesterDay = [putDate dateByAddingTimeInterval:secondsPerDay1];
        NSLog(@"yesterDay=======%@",yesterDay);
        flagYesterDay=[yesterDay copy];
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        [flagProductionDate setString:[formater stringFromDate:yesterDay]];
        [formater release];
        NSLog(@"flagProductionDate=======%@",flagProductionDate);
    }
}
-(void)chooseMenstrualCycle:(UIButton*)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect leftRect = viewBG.frame;
        viewBG.frame = CGRectMake(leftRect.origin.x, leftRect.origin.y - 100, leftRect.size.width, leftRect.size.height);
    }];
    
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
                CGRect leftRect = viewBG.frame;
                viewBG.frame = CGRectMake(leftRect.origin.x, leftRect.origin.y + 100, leftRect.size.width, leftRect.size.height);
                [menstrualDayBtn setTitle:[NSString stringWithFormat:@"%@天",[pickArr objectAtIndex:currentIndex]] forState:UIControlStateNormal];
                flagDays = [[pickArr objectAtIndex:currentIndex]integerValue];
                [self jiSuan];
                return;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - update Member Data
- (void)updateMemberData
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("user_info", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[IsLogIn instance].memberData.idString,@"user_id", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"user_info"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
        {
            NSString *data =  [dictionary objectForKey:@"data"];
            data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
            data = [data URLDecodedString];
            NSDictionary *dict = [JsonUtil jsonToDic:data];
            NSLog(@"dict :%@",[dict description]);
            IsLogIn *login = [IsLogIn instance];
            MemberEntiy *member = login.memberData;
            member.hasValue = YES;
            member.address = [dict objectForKey:@"address"];
            member.area = [dict objectForKey:@"area"];
            member.avatar = [dict objectForKey:@"avatar"];
            NSString *time = [dict objectForKey:@"birthday"];
            time = [time stringByReplacingOccurrencesOfString:@"/" withString:@""];
            time = [time stringByReplacingOccurrencesOfString:@"Date" withString:@""];
            time = [time stringByReplacingOccurrencesOfString:@"(" withString:@""];
            time = [time stringByReplacingOccurrencesOfString:@")" withString:@""];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter  setDateFormat:@"yyyy-MM-dd"];
            time = [formatter stringFromDate:date];
            [formatter release];
            member.birthday = time;
            
            member.census = [dict objectForKey:@"census_register"];
            member.email = [dict objectForKey:@"email"];
            member.id_card = [dict objectForKey:@"id_card"];
            member.mobileNum = [dict objectForKey:@"mobile"];
            member.nick_name = [dict objectForKey:@"nick_name"];
            member.rows = [dict objectForKey:@"rows"];
            member.signature = [dict objectForKey:@"signature"];
            member.user_name = [dict objectForKey:@"user_name"];
            login.memberData = member;
            
            
        }
    });
}
@end
