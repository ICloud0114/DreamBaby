//
//  AppDelegate.m
//  DreamBaby
//
//  Created by easaa on 14-1-3.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavigationController.h"
#import "HomeViewController.h"
#import "NearByViewController.h"
#import "MemberViewController.h"
#import "MoreViewController.h"
#import "KeychainItemWrapper.h"
#import "HTTPRequest.h"
#import "FBEncryptorDES.h"
#import "JsonFactory.h"
#import "NSString+URLEncoding.h"
#import "JsonUtil.h"


#import "DailyDetailViewController.h"

#import "IsLogIn.h"
#import "MemberEntiy.h"
#import "APService.h"

#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
#import "WeiboApi.h"
//#import <TencentOpenAPI/QQApi.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "YXApi.h"
//#import <RennSDK/RennSDK.h>

@implementation AppDelegate
@synthesize viewDelegate = _viewDelegate;


- (id)init
{
    if(self = [super init])
    {
        _viewDelegate = [[AGViewDelegate alloc] init];
        JPushDictionary = [[NSMutableDictionary dictionary]retain];
    }
    return self;
}

- (void)initializePlat
{
    
//    [ShareSDK connectSinaWeiboWithAppKey:@"943163965"
//                               appSecret:@"8d9a5cd70c7ef96e82e1cd5d92ea224a"
//                             redirectUri:@"http://baidu.com"];
    [ShareSDK connectSinaWeiboWithAppKey:@"943163965"
                               appSecret:@"8d9a5cd70c7ef96e82e1cd5d92ea224a"
                             redirectUri:@"http://baidu.com"
                             ];
    
    [ShareSDK connectTencentWeiboWithAppKey:@"801530520"
                                  appSecret:@"4024d584df84a27fddffda802441fc4b"
                                redirectUri:@"http://baidu.com"
                                   wbApiCls:[WeiboApi class]];
    

//      [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    
//  
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
//    [ShareSDK connectQQWithAppId:@"" qqApiCls:[QQApi class]];
//
//   
//    
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//
//    [ShareSDK connectRenRenWithAppId:@"226427"
//                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
//                   renrenClientClass:[RennClient class]];
//    
//        ///#end
//    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
//                            appSecret:@"da32179d859c016169f66d90b6db2a23"
//                          redirectUri:@"http://www.sharesdk.cn/"];
//      [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
//                           yixinCls:[YXApi class]];
//       ///#end
//    [ShareSDK connectSohuWeiboWithConsumerKey:@"q70QBQM9T0COxzYpGLj9"
//                               consumerSecret:@"XXYrx%QXbS!uA^m2$8TaD4T1HQoRPUH0gaG2BgBd"
//                                  redirectUri:@"http://www.sharesdk.cn"];
//      ///#end
//    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
//                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
//                            redirectUri:@"http://www.shareSDK.cn"];
//    
//
//    [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
//                            appSecret:@"9f1e7b4f71304f2f"
//                          redirectUri:@"http://www.sharesdk.cn"];
//        ///#end
//    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
//                             appSecret:@"b8eec53707c3976efc91614dd16ef81c"
//                           redirectUri:@"http://sharesdk.cn"];

}

///#begin zh-cn
/**
 *	@brief	托管模式下的初始化平台
 */
///#end
///#begin en
/**
 *	@brief	Hosted mode initialization platform
 */
///#end
- (void)initializePlatForTrusteeship
{
//        [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
//        [ShareSDK importRenRenClass:[RennClient class]];
    
    ///#begin zh-cn
      [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
//      [ShareSDK importWeChatClass:[WXApi class]];
  
//    [ShareSDK importYiXinClass:[YXApi class]];
}


- (void)showGuideView  //引导页
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        guideViewController = [[GuideViewController alloc] init];
        [self.window addSubview:guideViewController.view];
    }
    
}

-(void)checkVersionUpdate
{
    NSDictionary *sendDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type",nil];
    NSString *request = [HTTPRequest requestForGetWithPramas:sendDictionary method:@"get_version"];
    NSDictionary *json = [JsonUtil jsonToDic:request];
    NSLog(@"json :%@",[json description]);
    NSString *dataString = [json objectForKey:@"data"];
    dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
    dataString = [dataString URLDecodedString];
    NSLog(@"dataString :%@",dataString);
    
//    NSDictionary  *dictionary = [JsonUtil jsonToDictionary:dataString];
//    NSArray *tempArray = [JsonUtil jsonToArray:dataString];
    NSDictionary *dic = [dataString objectFromJSONString];
    
    [self performSelectorOnMainThread:@selector(showUpdate:) withObject:dic waitUntilDone:YES];
    
}
-(void)showUpdate:(NSDictionary *)receiveDictionary
{
    if ([receiveDictionary isKindOfClass:[NSDictionary class]])
    {
        if ([[receiveDictionary objectForKey:@"v_no"] isKindOfClass:[NSString class]])
        {
            if ([[receiveDictionary objectForKey:@"v_no"]integerValue] > [[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]integerValue])
            {
                
                versionURLString = [[receiveDictionary objectForKey:@"v_url"]retain];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"版本更新 %@",[receiveDictionary objectForKey:@"remark"] ]message:[receiveDictionary objectForKey:@"remark"] delegate:self cancelButtonTitle:@"稍后更新" otherButtonTitles:@"确定",nil];
                    [alertView setTag:814];
                    [alertView show];
                
            }
        }
    }
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //检查版本更新
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self checkVersionUpdate];
    });
    return  YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    IsLogIn *login = [IsLogIn instance];
    NSLog(@"begin================");
    NSLog(@"%d", login.isLogIn);
    NSLog(@"end==================");
    
//icon badge number
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [ShareSDK registerApp:@"iosv1101"];
    [self initializePlat];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
//    // Required
//    [APService
//     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                         UIRemoteNotificationTypeSound |
//                                         UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
    NSDictionary *launchDictionary  = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([launchDictionary isKindOfClass:[NSDictionary class]])
    {
        [JPushDictionary setDictionary:launchDictionary];
        
    }
    
    KeychainItemWrapper *keychainWrapper = [[[KeychainItemWrapper alloc] initWithIdentifier:UserAuthToken accessGroup:nil] autorelease];
    
    NSString *account = [keychainWrapper objectForKey:kSecAttrAccount];
    NSString *password = [keychainWrapper objectForKey:kSecValueData];
    NSLog(@"account==%@",account);
    NSLog(@"password==%@",password);
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.window addSubview:hud.view];

    if([[NSUserDefaults standardUserDefaults]objectForKey:UserAuthToken])
    {  //auto login
        [self requestForLogin:account :password];
    }
    else
    {
        //
        LoginViewController * loginVC=[[[LoginViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        MyNavigationController *loginNAV=[[[MyNavigationController alloc]initWithRootViewController:loginVC] autorelease];
//        [loginVC release];
        self.window.rootViewController=loginNAV;
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:Isfertility]) {
        NSDate *parentDate=[[NSUserDefaults standardUserDefaults] objectForKey:ParentDate];
        NSDateComponents* showCom = [self timerChuFaWithNSDateComponents:parentDate];
        ChangeDate *change=[ChangeDate instance];
        if (showCom.month==0&&showCom.year==0) {
            change.type_id=[NSString stringWithFormat:@"2"];
        }else if(showCom.month>0)
        {
            change.type_id=[NSString stringWithFormat:@"%d",showCom.year+2];
        }
    }
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [self showGuideView];
    }
    
//    [self timer];
    return YES;
}


void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (void)upload
{
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"user_id",@"3",@"type" ,nil];
    NSString *paramsJson = [JsonFactory dictoryToJsonStr:requestParams];

    //    NSLog(@"requestParamstr %@",paramsJson);
    //加密
	paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                keyString:@"SDFL#)@F"] uppercaseString];
    NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"add_note",paramsJson];
    signs = [[FBEncryptorDES md5:signs] uppercaseString];
    //    http://113.105.159.107:84
    //    icbcapp.intsun.com
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.100:8021/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
    
    NSString *fileUrl = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"aac"];
    
    NSData* postData = [[[NSData alloc]initWithContentsOfFile:fileUrl]autorelease];

    NSString *TWITTERFON_FORM_BOUNDARY = @"AABBCC";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY] autorelease];
    //结束符 AaB03x--
    NSString *endMPboundary=[[[NSString alloc]initWithFormat:@"%@--",MPboundary] autorelease];
    //http body的字符串
    NSMutableString *body=[[[NSMutableString alloc]init] autorelease];
    
    ////添加分界线，换行---文件要先声明
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"files\"; filename=\"abc.aac\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: media/AAC\r\n\r\n"];
    //声明结束符：--AaB03x--
    NSString *end=[[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary] autorelease];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:postData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY] autorelease];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    //建立连接，设置代理
    //    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //设置接受response的data
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection
                       sendSynchronousRequest:request
                       returningResponse: &response
                       error: &error];
    
    
    NSString *json = [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"json %@",json);
    json = [FBEncryptorDES decrypt:json keyString:@"SDFL#)@F"];
    json = [json URLDecodedString];
    NSLog(@"json :%@",json);
    
}


- (void)requestForLogin:(NSString *)username :(NSString *)password
{
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("login", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:username,@"user_name",password,@"password", nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"user_login"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"dict==%@",dictionary);
        //turn to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dictionary objectForKey:@"msg"]integerValue] == 1)
            {
                NSString *data =  [dictionary objectForKey:@"data"];
                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                data = [data URLDecodedString];
//                NSLog(@"class==%@",[[JsonUtil jsonToDic:data] class]);
                NSDictionary *dict;
                
                 if ([[JsonUtil jsonToDic:data] isKindOfClass:[NSArray class]]) {
                     NSArray *arr=[JsonUtil jsonToArray:data];
                    dict=arr[0];
                 }else{
                 dict = [JsonUtil jsonToDic:data];
                 }
                
                IsLogIn *login = [IsLogIn instance];
                MemberEntiy *member ;//= [[MemberEntiy alloc]init];
                NSLog(@"ID==%@",login.memberData.id_card);
                if (login.memberData)
                {
                    member = login.memberData;
                }else
                    member = [[[MemberEntiy alloc]init]autorelease];
//                NSLog(@"dict==%@",dict);
                NSLog(@"dict==%@",[dict class]);
                NSLog(@"dict.id==%@",[dict objectForKey:@"id"]);
                NSLog(@"id.class==%@",[[dict objectForKey:@"id"] class]);
                member.idString = [dict objectForKey:@"id"];
                
                login.memberData = member;
                
                login.isLogIn = YES;
                //

                [self getArea];
                
                [self requestUserInfo:login.memberData.idString];
                
                // Required
                [APService
                 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeSound |
                                                     UIRemoteNotificationTypeAlert)];
                
                
                UITabBarController *mainTabBar = [[UITabBarController alloc] init];
                mainTabBar.delegate = self;
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
//                [[UIApplication sharedApplication].delegate window].rootViewController = mainTabBar;
                
                [[[UIApplication sharedApplication]keyWindow]setRootViewController:mainTabBar];
                
                RELEASE_SAFE(mainTabBar);
                
                [self showCareDetail:JPushDictionary];
                
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    [hud setCaption:[dictionary objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                    [hud hideAfter:1.0];
                }else
                {
                    [hud setCaption:@"登录失败,请检查网络."];
                    [hud setActivity:NO];
                    [hud update];
                    hud.delegate = nil;
                    [hud hideAfter:1.0];
                }
                LoginViewController * loginVC=[[[LoginViewController alloc]initWithNibName:nil bundle:nil]autorelease];
                MyNavigationController *loginNAV=[[[MyNavigationController alloc]initWithRootViewController:loginVC]autorelease];
               
                self.window.rootViewController=loginNAV;
                
            }
        });
    });
    
}


- (void)getArea
{
   
    dispatch_queue_t network;
    network = dispatch_queue_create("getarea", nil);
    dispatch_async(network, ^{
        //do the request here
        NSString *request = [HTTPRequest requestForGetWithPramas:nil method:@"getarea"];
        NSDictionary *json = [JsonUtil jsonToDic:request];
        NSLog(@"json :%@",[json description]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[json objectForKey:@"msg"]intValue] > 0) {
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSLog(@"dataString :%@",dataString);
                
                NSArray *tempArray = [JsonUtil jsonToArray:dataString];
                
                [IsLogIn instance].cityArray = tempArray;
            }else
            {
                if ([json objectForKey:@"msgbox"] != NULL) {
                    NSString *alertString = [[json objectForKey:@"msgbox"] stringByAppendingString: @"下拉刷新试试"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"网络出问题了,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }
            }
            
        });
        dispatch_release(network);
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
            NSDictionary *dict = [[JsonUtil jsonToArray:data] firstObject];
            
            
            NSLog(@"dict :%@",[dict description]);
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate] != NULL)
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
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:ProductionDate];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            
            IsLogIn *login = [IsLogIn instance];
            MemberEntiy *member = login.memberData;
            member.hasValue = YES;
            member.address = [dict objectForKey:@"address"];
            member.city = [dict objectForKey:@"census_register"];
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
            member.isvip = [[dict objectForKey:@"IsVip"]intValue];
            
            member.cityId =[[dict objectForKey:@"census_id"]intValue];
            member.areaId = [[dict objectForKey:@"area_id"]intValue];
            member.rowId = [[dict objectForKey:@"row_id"]intValue];
            
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




//计算孩子出生多久
- (NSDateComponents *)timerChuFaWithNSDateComponents:(NSDate *)components
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    //    NSDate *todate = [cal dateFromComponents:components];//把目标时间装载入date
    NSDate *today = [NSDate date];//得到当前时间
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:components toDate:today options:0];
    NSString * str = [NSString stringWithFormat:@"%d年%d月%d日%d时%d分%d秒",[d year],[d month], [d day], [d hour], [d minute], [d second]];
    NSLog(@"%@",str);
    return [[d retain]autorelease];
}

- (void)dealloc
{
    [_viewDelegate release];
     hud.delegate = nil;
    [hud release];
    [lm stopUpdatingLocation];
    lm.delegate = nil;
    [lm release];
    [super dealloc];
}
#pragma mark UITabBarControllerDelegate

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
            
            if ([nowNav.viewControllers[0] isKindOfClass:[HomeViewController class]])
            {
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
            if (classId == nowSelect)
            {
                return NO;
            }
        }
        
    }

////点击首页时返回首页的rootViewController
//    if ([nowNav.viewControllers[0] isKindOfClass:[HomeViewController class]])
//    {
//        if (nowNav.viewControllers.count > 1)
//        {
//            [nowNav popToRootViewControllerAnimated:NO];
//        }
//
//    }

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
    
    selectIndex = tabBarController.selectedIndex;

    NSLog(@"select = %d",selectIndex);
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bottom_btn0%d",selectIndex+1]]];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    isActivity = NO;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    isActivity = NO;
    //icon badge number
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    isActivity = NO;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    isActivity = YES;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    IsLogIn *login = [IsLogIn instance];
    
    login.isLogIn = NO;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)saveSn
{
    IsLogIn *login = [IsLogIn instance];
    NSString *userIdString = [NSString stringWithFormat:@"%@",login.memberData.idString];
    
    [APService setTags:nil alias:userIdString callbackSelector:@selector(jpushCallBack:) object:nil];


    NSDate *productDate = [[NSUserDefaults standardUserDefaults]objectForKey:ProductionDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:productDate];
    [formatter release];
    NSDictionary *pushDic=[NSDictionary dictionaryWithObjectsAndKeys:userIdString,@"sn",[[NSUserDefaults standardUserDefaults] objectForKey:CityArea],@"location",[[UIDevice currentDevice] localizedModel],@"model",@"1",@"type",dateString,@"fetation",userIdString,@"user_id",nil];

    [HTTPRequest requestForGetWithPramas:pushDic method:@"add_pushuser"];
    //    NSLog(@"---%@",request);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken
{
    //      [APService registerDeviceToken:pToken];
    //    //    [IMFBase setNotificationToken:pToken];
    ////    NSLog(@"%@",pToken);
    //    NSString *sn = [NSString stringWithFormat:@"%@",pToken];
    //    sn = [sn stringByReplacingOccurrencesOfString:@"<" withString:@""];
    //    sn = [sn stringByReplacingOccurrencesOfString:@">" withString:@""];
    //    sn = [sn stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    appsn = [sn copy];
    //    lm = [[CLLocationManager alloc] init];
    //    if ([CLLocationManager locationServicesEnabled]) {
    //        lm.delegate = self;
    //        lm.desiredAccuracy = kCLLocationAccuracyBest;
    //        lm.distanceFilter = 1000.0f;
    //        [lm startUpdatingLocation];
    //    }
    //
    //    [[NSUserDefaults standardUserDefaults]setObject:appsn forKey:snToken ];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    [APService registerDeviceToken:pToken];
    
    NSLog(@"_______&&&&%@",pToken);
    NSString *sn = [NSString stringWithFormat:@"%@",pToken];
    sn = [sn stringByReplacingOccurrencesOfString:@"<" withString:@""];
    sn = [sn stringByReplacingOccurrencesOfString:@">" withString:@""];
    sn = [sn stringByReplacingOccurrencesOfString:@" " withString:@""];
    appsn = [sn copy];
    
    NSString * quBieMing = [[NSUserDefaults standardUserDefaults] objectForKey:bieMing];
    NSLog(@"*****bieMing==%@",quBieMing);
    
    if (!quBieMing) {
        NSString * subSn = [sn substringToIndex:30];
        NSLog(@"subSn==%@",subSn);
        int k = arc4random()%1000000;
        NSString * quBieMing = [NSString stringWithFormat:@"%@_%d",subSn,k];
        NSLog(@"bieMing==%@",quBieMing);

        [[NSUserDefaults standardUserDefaults]setObject:quBieMing forKey:bieMing ];
    }
    
   
    lm = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = 1000.0f;
        [lm startUpdatingLocation];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:appsn forKey:snToken ];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 处理推送消息
    //    [PFPush handlePush:userInfo];
    [APService handleRemoteNotification:userInfo];
    [JPushDictionary setDictionary:userInfo];
    
    if (!isActivity)
    {
        [self showCareDetail:JPushDictionary];
    }
    else
    {
        //a = 0 普通通知
        if(![[userInfo objectForKey:@"a"]intValue])
        {
            NSString *tilte = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"关爱提醒" message:tilte delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert setTag:111];
            [alert show];
            [alert release];

        }
        else
        {
            NSString *tilte = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"关爱提醒" message:tilte delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"详情", nil];
            [alert setTag:505];
            [alert show];
            [alert release];
        }
        
    }

    NSLog(@"JPush info------>%@", userInfo);
}


- (void)showCareDetail:(NSDictionary *)dictionary
{
 
    if ([[dictionary objectForKey:@"a"] integerValue] > 0)
    {
        IsLogIn *login = [IsLogIn instance];
        
        if(login.isLogIn == YES)
        {
            DailyDetailViewController *dailyDetailVC=[[DailyDetailViewController alloc]initWithDetail:[dictionary objectForKey:@"a"]];
            
            int week = [[dictionary objectForKey:@"w"]integerValue];
            
            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",week] forKey:@"pushWeek"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            dailyDetailVC.section = week;
            
            int day = [[dictionary objectForKey:@"d"]integerValue] - 1;
            
            if (week == 0)
            {
                if (day >= 20)
                {
                    day = 20;
                }
            }
            else
            {
                if (day >= 6)
                {
                    day = 6;
                }
            }
            dailyDetailVC.row = day;
            
            UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
            [self.window.rootViewController.childViewControllers[tbc.selectedIndex] pushViewController:dailyDetailVC animated:YES];
            
            [dailyDetailVC release];
            
            [JPushDictionary removeAllObjects];
        }
    }
    
    
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Regist fail%@",error);
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
    [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
  
    
    NSLog(@"manager:%@",manager);
    NSLog(@"error:%@",error);
}


//- (void) locationManager: (CLLocationManager *) manager
//     didUpdateToLocation: (CLLocation *) newLocation
//            fromLocation: (CLLocation *) oldLocation{
//    [lm stopUpdatingLocation];
//    CLGeocoder* geocoder = [[[CLGeocoder alloc] init] autorelease];
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:
//     ^(NSArray* placemarks, NSError* error){
//         if (placemarks.count > 0) {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             cityName =  placemark.subLocality;
//             //             NSLog(@"---%@",placemark.subLocality);
//             [NSThread detachNewThreadSelector:@selector(saveSn) toTarget:self withObject:nil];
//             [[NSUserDefaults standardUserDefaults]setObject:placemark.subLocality forKey:CityArea];
//             [[NSUserDefaults standardUserDefaults] synchronize];
//         }
//     }];
//}


- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
        case ShareType163Weibo:
            platName = NSLocalizedString(@"TEXT_NETEASE_WEIBO", @"网易微博");
            break;
        case ShareTypeDouBan:
            platName = NSLocalizedString(@"TEXT_DOUBAN", @"豆瓣");
            break;
        case ShareTypeFacebook:
            platName = @"Facebook";
            break;
        case ShareTypeKaixin:
            platName = NSLocalizedString(@"TEXT_KAIXIN", @"开心网");
            break;
        case ShareTypeQQSpace:
            platName = NSLocalizedString(@"TEXT_QZONE", @"QQ空间");
            break;
        case ShareTypeRenren:
            platName = NSLocalizedString(@"TEXT_RENREN", @"人人网");
            break;
        case ShareTypeSohuWeibo:
            platName = NSLocalizedString(@"TEXT_SOHO_WEIBO", @"搜狐微博");
            break;
        case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        case ShareTypeTwitter:
            platName = @"Twitter";
            break;
        case ShareTypeInstapaper:
            platName = @"Instapaper";
            break;
        case ShareTypeYouDaoNote:
            platName = NSLocalizedString(@"TEXT_YOUDAO_NOTE", @"有道云笔记");
            break;
        case ShareTypeGooglePlus:
            platName = @"Google+";
            break;
        case ShareTypeLinkedIn:
            platName = @"LinkedIn";
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

- (void)jpushCallBack:(NSDictionary *)sendDictionary
{
    NSLog(@"%@", sendDictionary);
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag)
    {
        case 814:
        {
            if (buttonIndex == 0)
            {
            }
            else
            {
                NSLog(@"%@",versionURLString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionURLString]];
            }
            
        }
            break;
         case 505:
        {
            if (buttonIndex == 0)
            {
            
            }
            else
            {
                [self showCareDetail:JPushDictionary];
            }
        }
            break;
        default:
            break;
    }
    
}
@end
