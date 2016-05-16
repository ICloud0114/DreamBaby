//
//  LoginViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-3.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "LoginViewController.h"
#import "InputDueDateViewController.h"
#import "SignupViewController.h"


#import "MyNavigationController.h"
#import "HomeViewController.h"
#import "NearByViewController.h"
#import "MemberViewController.h"
#import "MoreViewController.h"
#import "KeychainItemWrapper.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "IsLogIn.h"
#import "MemberEntiy.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"

#import "APService.h"

#import "EAFindPassWordViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITabBarControllerDelegate,ATMHudDelegate>
{
    ATMHud *hud;
    
    NSString* cityName;
    NSString *userID;
    NSString* appsn;
    UITapGestureRecognizer *tapGesture;
}
@end
@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    hud.delegate = nil;
    [hud release];
    RELEASE_SAFE(userNameTextField);
    RELEASE_SAFE(secreatTextField);
    self.strRegisterUserName = nil;
    self.strRegisterUserPwd = nil;
//    mainTabBar.delegate = nil;
//    RELEASE_SAFE(_strRegisterUserName);
//    RELEASE_SAFE(_strRegisterUserPwd);
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerSuccessAutoLogin];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"会员登录";
    
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
    
    
    //视图一，两个输入框和两个按钮
    UIView * view01 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.view addSubview:view01];
    
    [view01 setBackgroundColor:[UIColor clearColor]];
    [view01 release];
    
    UIImageView *userNameBG = [[UIImageView alloc]initWithFrame:CGRectMake(20, 45, 280, 30)];
    userNameBG.userInteractionEnabled = YES;
    userNameBG.image = [UIImage imageNamed:@"biaoti1"];
    [view01 addSubview:userNameBG];
    [userNameBG release];
    
    UIImageView *passwordBG = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, 280, 30)];
    passwordBG.userInteractionEnabled = YES;
    passwordBG.image = [UIImage imageNamed:@"biaoti1"];
    [view01 addSubview:passwordBG];
    [passwordBG release];
    
    
    
    //电邮地址
    UILabel *postAdressLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
    postAdressLabel.text = @"用户名：";
    postAdressLabel.font = [UIFont boldSystemFontOfSize:15];
    postAdressLabel.backgroundColor = [UIColor clearColor];
    postAdressLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    postAdressLabel.textAlignment = NSTextAlignmentLeft;
    [userNameBG  addSubview:postAdressLabel];
    [postAdressLabel release];
    
    
    userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, 200, 30)];
//    userNameTextField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu_shurukuang"]];
    userNameTextField.delegate = self;
    [userNameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [userNameBG addSubview:userNameTextField];
    userNameTextField.placeholder = @"账户名或手机号";
    
    //密碼
    UILabel *secreatLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
    secreatLabel.text = @"密  码:";
    secreatLabel.font = [UIFont boldSystemFontOfSize:15];
    secreatLabel.backgroundColor = [UIColor clearColor];
    secreatLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    secreatLabel.textAlignment = NSTextAlignmentLeft;
    [passwordBG addSubview:secreatLabel];
    [secreatLabel release];
    
    secreatTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, 200, 30)];
//    secreatTextField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu_shurukuang"]];
    secreatTextField.delegate = self;
    [secreatTextField setSecureTextEntry:YES];
    [secreatTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [passwordBG addSubview:secreatTextField];
    
   
    
    
    UIButton * checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
    [view01 addSubview:checkBox];
    checkBox.frame = CGRectMake(20, 115, 25, 25);
    checkBox.tag = 115;
    [checkBox addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [checkBox setImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [checkBox setImage:[UIImage imageNamed:@"anniu_h"] forState:UIControlStateSelected];

    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:UserAuthToken accessGroup:nil];
    NSNumber *flags = [keychainWrapper objectForKey:kSecAttrCreator];
    if ([flags boolValue]) {
        NSString *password = [keychainWrapper objectForKey:kSecValueData];
        NSString *username = [keychainWrapper objectForKey:kSecAttrAccount];
        userNameTextField.text = username;
        [secreatTextField setText:password];
        checkBox.selected = YES;
    }
    [keychainWrapper release];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(50, 115, 90, 20)];
    lable.font = [UIFont boldSystemFontOfSize:10];
    [view01 addSubview:lable];
    lable.text=@"记住密码";
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor colorwithHexString:@"#878787"];
    [lable release];
    UILabel *LXlabel=[[UILabel alloc]initWithFrame:CGRectMake(220,self.view.bounds.size.height - 150, 80, 20)];
    LXlabel.font=[UIFont boldSystemFontOfSize:10];
//    [view01 addSubview:LXlabel];
    LXlabel.text=@"忘记密码?";
    LXlabel.backgroundColor=[UIColor clearColor];
    LXlabel.textColor=[UIColor colorwithHexString:@"#878787"];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taponce:)];
    tap1.numberOfTapsRequired=1;
    LXlabel.userInteractionEnabled=YES;
    
    [LXlabel addGestureRecognizer:tap1];
    [tap1 release];
    
    checkBoxAuto = [UIButton buttonWithType:UIButtonTypeCustom];
    [view01 addSubview:checkBoxAuto];
    checkBoxAuto.frame = CGRectMake(210, 115, 25, 25);
    checkBoxAuto.tag  = 116;
    [checkBoxAuto addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [checkBoxAuto setImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [checkBoxAuto setImage:[UIImage imageNamed:@"anniu_h"] forState:UIControlStateSelected];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:UserAuthToken])
    {
        checkBoxAuto.selected = YES;
    }
    
    UILabel *lableAuto = [[UILabel alloc] initWithFrame:CGRectMake(240, 115, 90, 20)];
    lableAuto.font = [UIFont boldSystemFontOfSize:10];
    [view01 addSubview:lableAuto];
    [lableAuto release];
    lableAuto.text=@"自动登录";
    lableAuto.backgroundColor = [UIColor clearColor];
    lableAuto.textColor = [UIColor colorwithHexString:@"#878787"];

    
    //视图二，注册和登录按钮
    
    UIView * view02 = [[UIView alloc]initWithFrame:CGRectMake(0, 270, 320, 80)];
    [self.view addSubview:view02];
    [view02 release];
    
    UIButton *zhuceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    zhuceBtn.frame=CGRectMake(20, 0, 139, 35);
    [zhuceBtn setTitle:@"注  册" forState:UIControlStateNormal];
    zhuceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [zhuceBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [zhuceBtn setBackgroundImage:[UIImage imageNamed:@"zhuce"] forState:UIControlStateNormal];
    [zhuceBtn setBackgroundImage:[UIImage imageNamed:@"zhuce_h"] forState:UIControlStateHighlighted];
    //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [zhuceBtn addTarget:self action:@selector(zhucheAction) forControlEvents:UIControlEventTouchUpInside];
    [view02 addSubview:zhuceBtn];
//    [zhuceBtn release];
    
    
    UIButton *dengluBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isRegisterSuccess)
    {
        dengluBtn.userInteractionEnabled = NO;
    }
    else
    {
         dengluBtn.userInteractionEnabled = YES;
    }
    dengluBtn.frame=CGRectMake(161, 0, 139, 35);
    [dengluBtn setTitle:@"登  录" forState:UIControlStateNormal];
    dengluBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [dengluBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [dengluBtn setBackgroundImage:[UIImage imageNamed:@"zhuce"] forState:UIControlStateNormal];
    [dengluBtn setBackgroundImage:[UIImage imageNamed:@"zhuce_h"] forState:UIControlStateHighlighted];
    //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [dengluBtn addTarget:self action:@selector(dengluAction) forControlEvents:UIControlEventTouchUpInside];
    [view02 addSubview:dengluBtn];
//    [dengluBtn release];
    
    //NSLog(@"----%f-----",[UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height==568) {
        view01.frame = CGRectMake(0, 0+20, 320, 200);
        view02.frame = CGRectMake(0, 200+60, 320, 80);
    }
    
    
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    [self.view addSubview:LXlabel];
    [LXlabel release];
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard:)];
    self.isRegisterSuccess = NO;

}

- (void)hideKeyBoard:(id)sender
{
    [self.view endEditing:YES];
}

-(void)taponce:(UITapGestureRecognizer *)tap{
//    findPassWordViewController *find=[[findPassWordViewController alloc]init];
//    [self.navigationController pushViewController:find animated:YES];
//    [find release];
    EAFindPassWordViewController *findPassword = [[[EAFindPassWordViewController alloc]initWithNibName:@"EAFindPassWordViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:findPassword animated:YES];

}


//如果注册成功则进行自动登录
- (void)registerSuccessAutoLogin
{
    if (self.isRegisterSuccess)
    {
//        NSMutableDictionary *datadic=[NSMutableDictionary dictionaryWithContentsOfFile:[self dataFilePath:@"dataPath"]];
//        userNameTextField.text=[datadic objectForKey:@"userName"];
//        secreatTextField.text=[datadic objectForKey:@"password"];
        
        userNameTextField.text = self.strRegisterUserName;
        secreatTextField.text = self.strRegisterUserPwd;
        checkBoxAuto.selected = YES;
        [self dengluAction];
    }
}
//获取存储路径
-(NSString *)dataFilePath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:path];
}
- (void)zhucheAction
{
    SignupViewController *controller = [[[SignupViewController alloc]init]autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)dengluAction
{
    if (userNameTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请填写用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    else if (secreatTextField.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请填写密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    [self requestForLogin];
}
- (void)check:(UIButton *)button
{
    if (button.tag == 115)
    {
    //记住密码
        button.selected = !button.selected;
        KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:UserAuthToken accessGroup:nil];
        if (button.selected)
        {
            [keychainWrapper setObject:[NSNumber numberWithBool:YES] forKey:kSecAttrCreator];
        }
        else
        {
            [keychainWrapper setObject:[NSNumber numberWithBool:NO] forKey:kSecAttrCreator];
        }
        [keychainWrapper release];
    }
    else if (button.tag == 116)
    {
        //自动登录
        button.selected = !button.selected;
        if (button.selected) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:UserAuthToken];
        }else
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:UserAuthToken];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];

    }
}


//获取存储路径

- (void)requestForLogin
{
    [hud setCaption:@"请稍候.."];
    [hud setActivity:YES];
    [hud show];
    
    
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("login", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: userNameTextField.text,@"user_name",secreatTextField.text,@"password", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"user_login"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
       
        NSLog(@"dic==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                NSString *data =  [dictionary objectForKey:@"data"];
                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                data = [data URLDecodedString];
                NSDictionary *dict = [[JsonUtil jsonToArray:data]lastObject];

                NSLog(@"begin================");
                NSLog(@"%@", dict);
                NSLog(@"end==================");
                
                IsLogIn *login = [IsLogIn instance];
                MemberEntiy *member;
                if (login.memberData)
                {
                    member = login.memberData;
                }
                else
                    member = [[[MemberEntiy alloc]init]autorelease];
                member.idString = [dict objectForKey:@"id"];
                
                login.isLogIn = YES;
                
                KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:UserAuthToken accessGroup:nil];
                [keychainWrapper setObject:userNameTextField.text forKey:kSecAttrAccount];
                [keychainWrapper setObject:secreatTextField.text forKey:kSecValueData];

                [keychainWrapper release];
                
                [self performSelector:@selector(updateHud) withObject:nil afterDelay:1.0];
                
            
                //[self requestUserInfo:member.idString];
                member.hasValue = YES;
                member.city = [dict objectForKey:@"census_register"];
                member.address = [dict objectForKey:@"address"];
                member.area = [dict objectForKey:@"area"];
                if ([[dict objectForKey:@"avatar"] isEqualToString:@"http://183.61.84.207:1234"])
                {
                    member.avatar = @"";
                }
                else
                {
                    member.avatar = [dict objectForKey:@"avatar"];
                }
                
                if ([[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate] != nil)
                {
                    if ([[dict objectForKey:@"fetation"] isKindOfClass:[NSString class]])
                    {
                        NSString *timeString =[dict objectForKey:@"fetation"];
                        timeString = [timeString stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
                        timeString = [timeString stringByReplacingOccurrencesOfString:@")" withString:@""];
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]/1000];
                        
                        NSLog(@"conf  %@",date);
                        
                        [[NSUserDefaults standardUserDefaults]setObject:date forKey:ProductionDate];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                member.isvip = [[dict objectForKey:@"IsVip"]intValue];
                
                member.cityId =[[dict objectForKey:@"census_id"]intValue];
                member.areaId = [[dict objectForKey:@"area_id"]intValue];
                member.rowId = [[dict objectForKey:@"row_id"]intValue];
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
                NSLog(@"member==%@",login.memberData.idString);
                
                [APService
                 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeSound |
                                                     UIRemoteNotificationTypeAlert)];
                // Required
//                [APService setupWithOption:launchOptions];
//                [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
                
            }else
            {
                sleep(1);
                
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                    [hud hideAfter:1.0];
                }else
                {
                    [hud setCaption:@"登录失败"];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                    [hud hideAfter:1.0];
                }
                
            }
        });
    });
    
}


- (void)requestUserInfo:(NSString *)userId
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("user_info", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: userId,@"user_id", nil];
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
            member.city = [dict objectForKey:@"census_register"];
            member.area = [dict objectForKey:@"area"];
            member.avatar = [dict objectForKey:@"avatar"];
            member.isvip = [[dict objectForKey:@"IsVip"]intValue];
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


- (void)updateHud {
	[hud setCaption:@"登录成功"];
	[hud setActivity:NO];
	[hud setImage:[UIImage imageNamed:@"19-check"]];
    hud.delegate = self;
	[hud update];
	[hud hideAfter:1.0];
}

- (void)hudWillDisappear:(ATMHud *)_hud
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ProductionDate]!=NULL||[[NSUserDefaults standardUserDefaults] objectForKey:LastMenstruation]!=NULL||[[NSUserDefaults standardUserDefaults] objectForKey:ParentDate]!=NULL) {
        /**
         *  跳过日期选择
         */
        mainTabBar = [[UITabBarController alloc] init];
//        mainTabBar.delegate = self;
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
//        [[UIApplication sharedApplication].delegate window].rootViewController = mainTabBar;
        [[[UIApplication sharedApplication] keyWindow]setRootViewController:mainTabBar];
        
        mainTabBar.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        RELEASE_SAFE(mainTabBar);
        [mainTabBar release];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }else
    {
        InputDueDateViewController * inputVC = [[InputDueDateViewController alloc]init];
        [self.navigationController pushViewController:inputVC animated:YES];
        [inputVC release];
    }
}

#pragma mark - UITabBarControllerDelegate
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
            
            NSLog(@"class = %@",[nowNav.viewControllers[0] class]);
            int classId=100;
            if ([nowNav.viewControllers[0] isKindOfClass:[HomeViewController class]]) {
                classId = 0;
            }else if ([nowNav.viewControllers[0] isKindOfClass:[NearByViewController class]]){
                classId = 1;
            }else if ([nowNav.viewControllers[0] isKindOfClass:[MemberViewController class]]){
                classId = 2;
            }else if ([nowNav.viewControllers[0] isKindOfClass:[MoreViewController class]]){
                classId = 3;
            }
            NSLog(@"classId = %d", classId);
            int nowSelect = tabBarController.selectedIndex;
            if (classId == nowSelect) {
                return NO;
            }
        }
        
    }

    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    int selectIndex = tabBarController.selectedIndex;
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bottom_btn0%d",selectIndex+1]]];
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

#pragma mark keyboardNotification
-(void)keyboardShow:(NSNotification *)senderNotification
{
    [self.view addGestureRecognizer:tapGesture];
}

-(void)keyboardHide:(NSNotification *)senderNotification
{
    [self.view removeGestureRecognizer:tapGesture];
}

-(void)keyboardChange:(NSNotification *)senderNotification
{
    
}


@end
