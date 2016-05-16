//
//  MoreViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreControllerCell.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "FeedbackViewController.h"
#import "GovernmentViewController.h"

#import "LoginViewController.h"

#import "MyNavigationController.h"

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "ShareViewController.h"
#import "GuanYuWoMen.h"
#import "ModifyDueDateViewController.h"
#import "EANewsListViewController.h"

#import "AGAuthViewController.h"


#import "IsLogIn.h"
#import "MemberEntiy.h"

@interface MoreViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    ATMHud *hud;
    NSUInteger statusString;
    UILabel  *statusLabel;
    
    NSString *seviceNum;
}
@end

@implementation MoreViewController

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
    [inviteString release];
     hud.delegate = nil;
    [hud release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getPushState];
    
    [super viewWillAppear:animated];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    isUp = NO;
    self.navigationItem.title = @"更多";
//    statusString  =0;
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
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    moreTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, 300, self.view.frame.size.height-44 - 49 - 20 - 25) style:UITableViewStylePlain];
    if(version >= 7.0f)
    {
        moreTable.frame = CGRectMake(10, 0, 300, self.view.frame.size.height-44-49 - 20 - 25);
    }
    moreTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    moreTable.backgroundView = nil;
    moreTable.backgroundColor = [UIColor clearColor];
    moreTable.delegate = self;
    moreTable.dataSource = self;
    moreTable.bounces = NO;
    moreTable.showsVerticalScrollIndicator=NO;
    moreTable.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:moreTable];
    [moreTable release];
    
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];

    
    [self getServiceNumber];
    [self getInvite];
    

}
#pragma mark---TableVeiw methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 0;
    if (section==0)
    {
        num= 7;
    }
    else if(section==1)
    {
        num= 1;
    }
    
    return num;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
//    tableView.separatorColor = [UIColor colorwithHexString:@"#FFFFFF"];
    if(version<7.0f)
    {
        
    }else
    {
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    NSInteger index = indexPath.row;
    NSInteger section=[indexPath section];
//    static NSString *SimpleTableIdentifier = @"MoreControllerCell";
    MoreControllerCell *cell ;//= [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
//    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"MoreControllerCell" owner:self options:nil]lastObject];
    
        cell.backgroundColor = [UIColor clearColor];
    
        cell.cellBG.image = [UIImage imageNamed:@"more_b"];


        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;

    
        if (section == 0) {
            if (index == 1) {
//                cell.moreStateLabel.text = @"";
//                statusLabel = cell.moreStateLabel;
            }
        }
//    }
    switch (section)
    {
        case 0:
            
            switch (index)
        {
                case 0:
   
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinxi_list_shang_bg"]]autorelease];
                    cell.moreArticalLabel.text = @"预产期修改";
                cell.cellBG.image = [UIImage imageNamed:@"more_a"];
                   // NSDate * putDate00 = [[NSUserDefaults standardUserDefaults] objectForKey:ProductionDate];
                    NSDate * putDate00 =[NSDate date];
                    if (putDate00!=NULL){
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//                        NSString *nowStr = [[NSString alloc]init];
//                      NSString *nowStr = [dateFormatter stringFromDate:putDate00];
//                        cell.moreStateLabel.text = nowStr;
//                        cell.moreStateLabel.font=[UIFont systemFontOfSize:13];
//                        cell.moreStateLabel.hidden = YES;
                        [dateFormatter release];
                    }
                    break;
                case 1:
                
                
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.moreArticalLabel.text = @"关爱提醒通知";
                    cell.moreAccessView.hidden = YES;

//                    cell.moreStateLabel.textAlignment=NSTextAlignmentCenter;
                
                    if (![[NSUserDefaults standardUserDefaults] objectForKey:PUSHSTATE])
                    {
                        NSNumber *number = [NSNumber numberWithInteger:0];
                        [[NSUserDefaults standardUserDefaults]setObject:number forKey:PUSHSTATE];
                    }
                    NSNumber *statusNumber = [[NSUserDefaults standardUserDefaults]objectForKey:PUSHSTATE];
                
                UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell addSubview:switchBtn];
                
                [switchBtn setFrame:CGRectMake(250, 5, 41, 24)];
                [switchBtn setBackgroundImage:[UIImage imageNamed:@"more_on"] forState:UIControlStateNormal];
                [switchBtn setBackgroundImage:[UIImage imageNamed:@"more_off"] forState:UIControlStateSelected];
                [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
                
//                    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(230, 5, 10, 10)];
//                
//                    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//                    [cell addSubview:switchButton];
                    if (statusNumber.integerValue  == 1)
                    {
//                        cell.moreStateLabel.text = @"关闭";
                        switchBtn.selected = NO;
                    }else
                    {
                        switchBtn.selected = YES;
//                        cell.moreStateLabel.text = @"打开";
                    }
                    break;
                case 2:
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.moreArticalLabel.text = @"分享设置";

                    break;
//                case 3:
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
//                    cell.moreArticalLabel.text = @"发送邮件";
//                    cell.moreStateLabel.text = @"";
//                    break;
                case 3:
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.moreArticalLabel.text = @"热线电话";

                    break;
                case 4:
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.moreArticalLabel.text = @"邀请好友";

                    break;
                    
                    //                case 4:
                    //                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    //                    cell.moreArticalLabel.text = @"社区";
                    //                    cell.moreStateLabel.text = @"";
                    //                    break;
                case 5:
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg02"]]autorelease];
                    cell.moreArticalLabel.text = @"在线反馈";

                    break;
                    
                case 6:
//                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xinxi_list_xia_bg"]]autorelease];
                
                cell.cellBG.image = [UIImage imageNamed:@"more_c"];
                    cell.moreArticalLabel.text = @"公告";

                    break;
                }
                break;
            case 1:
                switch (index)
                {
                    
                    case 0:
//                        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongyong_list_bg03"]]autorelease];
                        cell.moreArticalLabel.text = @"退出登录";
                        cell.moreArticalLabel.textAlignment = UITextAlignmentCenter;
                        cell.moreAccessView.hidden = YES;

                        break;
                }
                break;
        default:
            break;
    }
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 20)];
    myView.backgroundColor = [UIColor clearColor];
    return [myView autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
                
            case 0:
            {
                ModifyDueDateViewController *controller = [[ModifyDueDateViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
                break;
            case 1:
            {
                [self setPushState];
            }
                break;
            case 2:
            {
                //微博分享
                ShareViewController *controller = [[ShareViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
//                AGAuthViewController *auth = [[[AGAuthViewController alloc] init] autorelease];
//                [self.navigationController pushViewController:auth animated:YES];
                
            }
                break;
//            case 3:
//            {
//                //发送邮件
//                [self sendEmail:inviteString];
//            }
//                break;
            case 3:
            {
                //热线电话
                //                if (!seviceNum) {
                //                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"因网络问题为获取到热线电话" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                //                    [alert show];
                //                    [alert release];
                //                    break;
                //                }
                seviceNum=@"4006010079";
                [self makeACall:seviceNum];
            }
                break;
            case 4:
            {
                //邀请好友
                [self sendMessages:inviteString];
                NSLog(@"invte = %@",inviteString);
            }
                break;
                //            case 4:
                //            {
                //                //社区
                //                GuanYuWoMen *urlVC=[[[GuanYuWoMen alloc]init]autorelease];
                //                [self.navigationController pushViewController:urlVC animated:YES];
                //            }
                //                break;
            case 5:
            {
                //在线反馈
                FeedbackViewController *controller = [[[FeedbackViewController alloc]init]autorelease];
                controller.isFeedback = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case 6:
            {
                //公告
//                GovernmentViewController *controller = [[[GovernmentViewController alloc]init]autorelease];
//                [self.navigationController pushViewController:controller animated:YES];
                
                EANewsListViewController *government = [[[EANewsListViewController alloc]initWithNibName:@"EANewsListViewController" bundle:nil]autorelease];
                government.item = @"公告";
                government.type = @"2";
                [self.navigationController pushViewController:government animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserAuthToken];
    
        LoginViewController * loginVC=[[[LoginViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        MyNavigationController * loginNAV = [[[MyNavigationController alloc]initWithRootViewController:loginVC]autorelease];
        [[[UIApplication sharedApplication]keyWindow] setRootViewController:loginNAV];
        
//        [[UIApplication sharedApplication].delegate window].rootViewController = loginNAV;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)switchAction:(id)sender
{
    [self setPushState];
}

#pragma mark - 发送邮件
- (void)sendEmail:(NSString *)string
{
    MFMailComposeViewController*
    controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[@""]];
    [controller setSubject:@"软件分享"];
    [controller setMessageBody:string isHTML:NO];
    if ([MFMailComposeViewController canSendMail]) {
        [self presentModalViewController:controller animated:YES];
    }
    [controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送mail");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送邮件");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - 发送短信


- (void)sendMessages:(NSString *)string
{
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        
//        controller.recipients = [NSArray arrayWithObject:@"10010"];
        controller.body = string;
        controller.messageComposeDelegate = self;
        
        [self presentModalViewController:controller animated:YES];
        
        [controller release];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Nil message:@"该设备没有短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissModalViewControllerAnimated:NO];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            
            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        default:
            break;
    }
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

#pragma mark - 打电话
-(void)makeACall:(NSString *)phoneNum
{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
 
}


#pragma mark - get_push_state
- (void)getPushState
{
    dispatch_queue_t network;
    network = dispatch_queue_create("get_push_state", nil);
    dispatch_async(network, ^{
        
        IsLogIn *login = [IsLogIn instance];
        NSString *userIdString = [NSString stringWithFormat:@"%@",login.memberData.idString];

//        NSString *appsn=[[NSUserDefaults standardUserDefaults]objectForKey:bieMing];
        
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:userIdString,@"sn", nil] method:@"get_push_state"];
        NSDictionary *json=[JsonUtil jsonToDic:request] ;
        if ([[json objectForKey:@"msg"] intValue] == 1) {
            NSString *listJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
            listJson = [listJson URLDecodedString];
            statusString = [[NSString stringWithFormat:@"%@",listJson]intValue];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:statusString] forKey:PUSHSTATE];
            NSLog(@"staustring=%d",statusString);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (statusString  == 0)
                {
                    [moreTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }else
                {
                    [moreTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

                }
            });
        }
    });
}

#pragma mark - set_push_state
- (void)setPushState
{
    if (isUp == NO) {
        isUp = YES;
    
    dispatch_queue_t network;
    network = dispatch_queue_create("set_push_state", nil);
    dispatch_async(network, ^{
        NSLog(@"statuString==%d",statusString);
        
//        statusString = 0;
    
        NSString *statu = @"1";
        NSNumber *number = [[NSUserDefaults standardUserDefaults]objectForKey:PUSHSTATE];
        statusString = number.integerValue;
        NSLog(@"staussting = %d",statusString);
        if (0 == statusString)
        {
            statu = @"1";
        }else
        {
            statu = @"0";
        }

        IsLogIn *login = [IsLogIn instance];
        NSString *userIdString = [NSString stringWithFormat:@"%@",login.memberData.idString];
//        NSString *appsn=[[NSUserDefaults standardUserDefaults]objectForKey:bieMing];
//        NSLog(@"appsn==%@",appsn);
        NSLog(@"statu==%@",statu);
        NSString *request = [HTTPRequest requestForGetWithPramas:
                             [NSDictionary dictionaryWithObjectsAndKeys:userIdString,@"sn",statu,@"state", nil]
                                                          method:@"set_push_state" ];

        NSDictionary *json=[JsonUtil jsonToDic:request];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"] intValue] == 1) {
                if (statusString == 0)
                {
                    statusString = 1;
                    NSNumber *number = [NSNumber numberWithInteger:statusString];
                    [[NSUserDefaults standardUserDefaults]setObject:number forKey:PUSHSTATE];
                    [moreTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    NSLog(@"staussting = %d",statusString);
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"推送已关闭" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }else
                {
                    statusString = 0;
                    NSNumber *number = [NSNumber numberWithInteger:statusString];
                    [[NSUserDefaults standardUserDefaults]setObject:number forKey:PUSHSTATE];
                    
                    [moreTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    
                    NSLog(@"staussting = %d",statusString);
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"推送已开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }
                
                
            }else
            {
                if ([json objectForKey:@"msgbox"] != NULL) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[json objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"修改提醒通知失败,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }
               
            }
            isUp = NO;
        });
        
        dispatch_release(network);
    });
    }
}

#pragma mark - get Service number

- (void)getServiceNumber
{
    dispatch_queue_t network;
    network = dispatch_queue_create("get_connect", nil);
    dispatch_async(network, ^{
        
        //获取电话号码
        NSString *request = [HTTPRequest requestForGetWithPramas:nil method:@"get_connect"];
        NSDictionary *json=[JsonUtil jsonToDic:request] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"] boolValue]) {
                NSString *listJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
                listJson = [listJson URLDecodedString];
                NSLog(@"----%@",listJson);
                seviceNum=[[[listJson objectFromJSONString] objectForKey:@"telephone"] retain];
            }
            else
            {
                
            }
        });
    });
}
- (void)getInvite
{
    dispatch_queue_t network;
    network = dispatch_queue_create("get_invite", nil);
    dispatch_async(network, ^{
        
        //获取电话号码
        NSString *request = [HTTPRequest requestForGetWithPramas:nil method:@"get_invite"];
        NSDictionary *json=[JsonUtil jsonToDic:request] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"] boolValue]) {
                NSString *listJson = [FBEncryptorDES decrypt:[json objectForKey:@"data"]  keyString:@"SDFL#)@F"];
                listJson = [listJson URLDecodedString];
                
                inviteString = [[NSString alloc]initWithString:listJson];;
                NSLog(@"----%@",inviteString);
//                seviceNum=[[[listJson objectFromJSONString] objectForKey:@"telephone"] retain];
            }
            else
            {
                
            }
        });
    });
}

- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}




@end
