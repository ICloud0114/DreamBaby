//
//  MemberViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberRegController.h"
#import "IsLogIn.h"
#import "MemberEntiy.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "NSString+URLEncoding.h"
#import "FBEncryptorDES.h"
#import "ATMHud.h"
#import "MemberCell.h"
#import "CustomTextField.h"
#import "UIImageView+WebCache.h"
#import "ChangePwdViewController.h"
#import "FeedbackViewController.h"
#import "ModifypwdViewController.h"
@interface MemberViewController ()<FeedbackViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIImageView *photoImage;
    ATMHud *hud;
    
    
    CustomTextField *userField;
    CustomTextField *nickNameField;
    CustomTextField *mobileField;
    CustomTextField *emailField;
//    UITextField *birthField;
    
    UITextField *cityField;
    UITextField *areaField;
//    UITextField *streetField;
    
    UIPickerView *cityPicker;
    
    UIPickerView *areapicker;
    
//    UIPickerView *streetpicker;
    UIButton        *saveBtn;
    
    UIDatePicker *datePicker;
    int s;
//    int streetId;
    NSMutableArray *listArr;
    NSMutableArray *areaArr;
//    NSMutableArray *streetArr;
    
    NSString *cityID;
    NSString *areaID;
//    NSString *streetID;
    
    

}

@property (nonatomic ,retain)NSArray *cityArray;
//@property (nonatomic ,retain) NSArray *streetArray;
@property (nonatomic ,retain) NSArray *areaArray;

@end

@implementation MemberViewController

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
    
    
    RELEASE_SAFE(photoImage);
    
    
    RELEASE_SAFE(userField);
    RELEASE_SAFE(nickNameField);
    RELEASE_SAFE(mobileField);
    RELEASE_SAFE(emailField);
//    RELEASE_SAFE(birthField);
    
    RELEASE_SAFE(cityField);
    RELEASE_SAFE(areaField);
//    RELEASE_SAFE(streetField);
    
    RELEASE_SAFE(cityPicker);
    RELEASE_SAFE(areapicker);
//    RELEASE_SAFE(streetpicker);
    RELEASE_SAFE(_cityArray);
//    RELEASE_SAFE(_streetArray);
    RELEASE_SAFE(_areaArray);
    RELEASE_SAFE(cityID);
    RELEASE_SAFE(areaID);
//    RELEASE_SAFE(streetID);
    RELEASE_SAFE(listArr);
    RELEASE_SAFE(areaArr);
//    RELEASE_SAFE(streetArr);
    RELEASE_SAFE(datePicker);
    RELEASE_SAFE(loginView);
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"会员中心";
    s = 0;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
    {
        s = 8;
    }
//    listArr = [[NSMutableArray alloc]init];
//    [listArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:LISTARRAY]];
    
    areaArr = [[NSMutableArray  alloc]init];
//    [areaArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:AREAARRAY]];
    
//    streetArr = [[NSMutableArray  alloc]init];
//    [streetArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:STREETARRAY]];
    
    userField=[[CustomTextField alloc]init];
    nickNameField=[[CustomTextField alloc]init];
    mobileField=[[CustomTextField alloc]init];
    emailField=[[CustomTextField alloc]init];
//    birthField=[[UITextField alloc]init];
    
    cityField=[[UITextField alloc]init];
    areaField=[[UITextField alloc]init];
//    streetField=[[UITextField alloc]init];
    
    userField.textColor = [UIColor whiteColor];
    nickNameField.textColor = [UIColor whiteColor];
    mobileField.textColor = [UIColor whiteColor];
    emailField.textColor = [UIColor whiteColor];
//    birthField.textColor = [UIColor whiteColor];
    
    cityField.textColor = [UIColor whiteColor];
    areaField.textColor = [UIColor whiteColor];
//    streetField.textColor = [UIColor whiteColor];
    
    userField.font = [UIFont systemFontOfSize:14];
    nickNameField.font = [UIFont systemFontOfSize:14];
    mobileField.font = [UIFont systemFontOfSize:14];
    emailField.font = [UIFont systemFontOfSize:14];
//    birthField.font = [UIFont systemFontOfSize:14];
    cityField.font =  [UIFont systemFontOfSize:14];
    areaField.font = [UIFont systemFontOfSize:14];
//    streetField.font = [UIFont systemFontOfSize:14];
    
    //出生日期选这
//    UIDatePicker *timePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
//    timePicker.locale = locale;
//    [locale release];
//    timePicker.datePickerMode = UIDatePickerModeDate;
//    birthField.inputView = timePicker;
//    timePicker.backgroundColor = [UIColor whiteColor];
//    [timePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
//    UIToolbar* inputAccessoryView = [[UIToolbar alloc] init];
//    inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
//    inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [inputAccessoryView sizeToFit];
//    CGRect frame = inputAccessoryView.frame;
//    frame.size.height = 30.0f;
//    inputAccessoryView.frame = frame;
//    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(selectDate)];
//    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
//    [inputAccessoryView setItems:array];
//    [flexibleSpaceLeft release];
//    [doneBtn release];
//    birthField.inputAccessoryView = inputAccessoryView;
//    [inputAccessoryView release];
    
    //户籍选择
    cityField.userInteractionEnabled = YES;
    cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    cityPicker.backgroundColor = [UIColor whiteColor];
    cityPicker.dataSource = self;
    cityPicker.delegate = self;
    cityPicker.tag = 714;
    cityField.inputView = cityPicker;
    UIToolbar* inputAccessoryCity = [[UIToolbar alloc] init];
    inputAccessoryCity.barStyle = UIBarStyleBlackTranslucent;
    inputAccessoryCity.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [inputAccessoryCity sizeToFit];
    CGRect frame0 = inputAccessoryCity.frame;
    frame0.size.height = 30.0f;
    inputAccessoryCity.frame = frame0;
    UIBarButtonItem *doneBtn0 =[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(selectCity)];
    UIBarButtonItem *flexibleSpaceLeft0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array0 = [NSArray arrayWithObjects:flexibleSpaceLeft0, doneBtn0, nil];
    [inputAccessoryCity setItems:array0];
    [flexibleSpaceLeft0 release];
    [doneBtn0 release];
    cityField.inputAccessoryView = inputAccessoryCity;
    [inputAccessoryCity release];
    
    
    //地区选着
    areaField.userInteractionEnabled = YES;
    areapicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    areapicker.backgroundColor = [UIColor whiteColor];
    areapicker.dataSource = self;
    areapicker.delegate = self;
    areapicker.tag = 814;
    areaField.inputView = areapicker;
    
    UIToolbar* inputAccessoryView1 = [[UIToolbar alloc] init];
    inputAccessoryView1.barStyle = UIBarStyleBlackTranslucent;
    inputAccessoryView1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [inputAccessoryView1 sizeToFit];
    CGRect frame1 = inputAccessoryView1.frame;
    frame1.size.height = 30.0f;
    inputAccessoryView1.frame = frame1;
    UIBarButtonItem *doneBtn1 =[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(selectArea)];
    UIBarButtonItem *flexibleSpaceLeft1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array1 = [NSArray arrayWithObjects:flexibleSpaceLeft1, doneBtn1, nil];
    [inputAccessoryView1 setItems:array1];
    [flexibleSpaceLeft1 release];
    [doneBtn1 release];
    areaField.inputAccessoryView = inputAccessoryView1;
    [inputAccessoryView1 release];
    //街道
    
    
//    streetpicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    streetpicker.backgroundColor = [UIColor whiteColor];
//    streetpicker.dataSource = self;
//    streetpicker.delegate = self;
//    streetpicker.tag = 1000;
//    streetField.inputView = streetpicker;
//    UIToolbar* inputAccessoryViewStreet = [[UIToolbar alloc] init];
//    inputAccessoryViewStreet.barStyle = UIBarStyleBlackTranslucent;
//    inputAccessoryViewStreet.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [inputAccessoryViewStreet sizeToFit];
//    CGRect frame2 = inputAccessoryViewStreet.frame;
//    frame2.size.height = 30.0f;
//    inputAccessoryViewStreet.frame = frame2;
//    UIBarButtonItem *doneBtn2 =[[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(selectStreet)];
//    UIBarButtonItem *flexibleSpaceLeft2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *array2 = [NSArray arrayWithObjects:flexibleSpaceLeft2, doneBtn2, nil];
//    [inputAccessoryViewStreet setItems:array2];
//    [flexibleSpaceLeft2 release];
//    [doneBtn2 release];
//    streetField.inputAccessoryView = inputAccessoryViewStreet;
//    
//    [inputAccessoryViewStreet release];
    
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
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake( 0, 0,60, 35);
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"top_btn1"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"top_btn1_h"] forState:UIControlStateHighlighted];

    [saveBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    
    /*
     *
     */
    
//    NSArray *tempArray = [NSArray array];
//    self.streetArray = tempArray;
    
    loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44-49)];
    loginView.backgroundColor = [UIColor clearColor];
    [loginView.zhuceBtn addTarget:self action:@selector(goRegController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginView];
    loginView.hidden = YES;
    [loginView.dengluBtn addTarget:self action:@selector(dengluAction) forControlEvents:UIControlEventTouchUpInside];
//    IsLogIn * islog = [IsLogIn instance];
//    [islog addObserver:self forKeyPath:@"isLogIn" options:NSKeyValueObservingOptionNew context:nil];
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    memberTable = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, 280, self.view.frame.size.height-44-49) style:UITableViewStylePlain];
    if(version>=7.0f)
    {
        memberTable.frame = CGRectMake(20, 0, 280, self.view.frame.size.height-44-49 -20);
    }
    memberTable.showsHorizontalScrollIndicator=NO;
    memberTable.showsVerticalScrollIndicator=NO;
    //memberTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-49) style:UITableViewStyleGrouped];
    memberTable.backgroundView = nil;
    memberTable.backgroundColor = [UIColor clearColor];
    memberTable.delegate = self;
    memberTable.dataSource = self;
    memberTable.hidden=NO;
    [self.view addSubview:memberTable];
    [memberTable release];

    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
    
    if ([IsLogIn instance].memberData.hasValue == NO)
    {
        [self getRequsetInfo];
    }else
    {
       [self getRequsetInfo]; 
    }
    

}


- (void)saveBtnAction:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"编辑"])
    {
        [button setTitle:@"保存" forState:UIControlStateNormal];
        userField.enabled = NO;
        nickNameField.enabled = YES;
        mobileField.enabled = YES;
        emailField.enabled = YES;
//        birthField.enabled = YES;
        cityField.enabled = YES;
        areaField.enabled = YES;
//        streetField.enabled = YES;

//        userField.textAlignment = NSTextAlignmentLeft;
//        nickNameField.textAlignment = NSTextAlignmentLeft;
//        mobileField.textAlignment = NSTextAlignmentLeft;
//        emailField.textAlignment = NSTextAlignmentLeft;
//        birthField.textAlignment = NSTextAlignmentLeft;
//        areaField.textAlignment = NSTextAlignmentLeft;
//        streetField.textAlignment = NSTextAlignmentLeft;
        
    }
    else
    {
        MemberEntiy *member = [IsLogIn instance].memberData;
        if ([userField.text isEqualToString:member.user_name] &&
            [nickNameField.text isEqualToString:member.nick_name] &&
            [mobileField.text isEqualToString:member.mobileNum] &&
            [emailField.text isEqualToString:member.email] &&
//            [birthField.text isEqualToString:member.birthday] &&
             [cityField.text isEqualToString:member.city] &&
            [areaField.text isEqualToString:member.area]
//            &&
//            [streetField.text isEqualToString:member.rows]
            )
        {
            [saveBtn setTitle:@"编辑" forState:UIControlStateNormal];
            userField.enabled = NO;
            nickNameField.enabled = NO;
            mobileField.enabled = NO;
            emailField.enabled = NO;
//            birthField.enabled = NO;
            cityField.enabled = NO;
            areaField.enabled = NO;
//            streetField.enabled = NO;
            
//            userField.textAlignment = NSTextAlignmentRight;
//            nickNameField.textAlignment = NSTextAlignmentRight;
//            mobileField.textAlignment = NSTextAlignmentRight;
//            emailField.textAlignment = NSTextAlignmentRight;
//            birthField.textAlignment = NSTextAlignmentRight;
//            areaField.textAlignment = NSTextAlignmentRight;
//            streetField.textAlignment = NSTextAlignmentRight;
            
            
            
            [hud show];
            [hud setCaption:@"保存成功"];
            [hud update];
            [hud setActivity:NO];

            [hud hideAfter:1.0f];
            return;
        }
        
        if (userField.text.length == 0 || nickNameField.text.length == 0 || cityField.text.length == 0|| areaField.text.length == 0 ) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
        if (![emailField.text isEqualToString:@""])
        {
            if (![self validateEmail:emailField.text])
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                return;
            }
            
        }
        if (![self isMobileNumber:mobileField.text]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
        
        [self updateUserInfo];
    }
}

#pragma mark - request for info
- (void)getRequsetInfo
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    dispatch_queue_t network ;
    network = dispatch_queue_create("user_info", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:[IsLogIn instance].memberData.idString,@"user_id", nil] method:@"user_info"];
        NSLog(@"userID==%@",[IsLogIn instance].memberData.idString);
        NSDictionary *json = [JsonUtil jsonToDic:request];
        NSString *arearequest = [HTTPRequest requestForGetWithPramas:nil method:@"getarea"];
        NSDictionary *areajson = [JsonUtil jsonToDic:arearequest];
        NSLog(@"json :%@",[areajson description]);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //加载地区
            if ([[areajson objectForKey:@"msg"]intValue] > 0)
            {
                NSString *areadataString = [areajson objectForKey:@"data"];
                areadataString = [FBEncryptorDES decrypt:areadataString keyString:@"SDFL#)@F"];
                areadataString = [areadataString URLDecodedString];
                NSLog(@"dataString :%@",areadataString);
                
                NSArray *tempArray = [JsonUtil jsonToArray:areadataString];
//                self.cityArray = tempArray;
            
                [IsLogIn instance].cityArray = tempArray;
                NSLog(@"cityArray = %@",[IsLogIn instance].cityArray);
                if (!areaArr.count)
                {
                    for (NSDictionary * lisDic in [IsLogIn instance].cityArray)
                    {
                        if ([cityField.text isEqualToString:[lisDic objectForKey:@"title"]])
                        {
//                            areaArr = [lisDic objectForKey:@"list"];
                            [areaArr setArray:[lisDic objectForKey:@"list"]];
                        }
                    }
                }
                
            }
            
            if ([[json objectForKey:@"msg"]integerValue] == 1) {
                
                NSString *data =  [json objectForKey:@"data"];
                data = [FBEncryptorDES decrypt:data keyString:@"SDFL#)@F"];
                data = [data URLDecodedString];
//                NSArray *arr = [JsonUtil jsonToArray:data];
//                NSDictionary *dict = [arr objectAtIndex:0];
                NSDictionary *dict = [JsonUtil jsonToDic:data];
                NSLog(@"dic = %@",dict);
                
                IsLogIn *login = [IsLogIn instance];
                MemberEntiy *member = login.memberData;
                member.hasValue = YES;
                if (![dict objectForKey:@"address"])
                {
                    member.address = [dict objectForKey:@"address"];
                }
                
                member.area = [dict objectForKey:@"area"];
                member.avatar = [dict objectForKey:@"avatar"];
//                NSString *time = [dict objectForKey:@"birthday"];
//                time = [time stringByReplacingOccurrencesOfString:@"/" withString:@""];
//                time = [time stringByReplacingOccurrencesOfString:@"Date" withString:@""];
//                time = [time stringByReplacingOccurrencesOfString:@"(" withString:@""];
//                time = [time stringByReplacingOccurrencesOfString:@")" withString:@""];
//                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
//                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                [formatter  setDateFormat:@"yyyy-MM-dd"];
//                [time release];
//                time = [formatter stringFromDate:date];
                
//                member.birthday = [formatter stringFromDate:date];
                member.census = [dict objectForKey:@"census_register"];
//                if (![[dict objectForKey:@"email"] isEqualToString:@""])
//                {
//                   member.email = [dict objectForKey:@"email"];
//                }
                
//                member.id_card = [dict objectForKey:@"id_card"];
                member.mobileNum = [dict objectForKey:@"mobile"];
                member.nick_name = [dict objectForKey:@"nick_name"];
                member.rows = [dict objectForKey:@"rows"];
                if (![[dict objectForKey:@"signature"] isEqualToString:@""])
                {
                    member.signature = [dict objectForKey:@"signature"];
                }
                
                member.user_name = [dict objectForKey:@"user_name"];
                member.isvip = [[dict objectForKey:@"IsVip"]intValue];

                cityID = [[NSString stringWithFormat:@"%d",member.cityId]retain];
                areaID  = [[NSString stringWithFormat:@"%d",member.areaId]retain];
//                streetID = [[NSString stringWithFormat:@"%d",member.rowId]retain];
                
                NSLog(@"begin================");
                NSLog(@"%@====%@====",cityID, areaID);
                NSLog(@"end==================");
                
                login.memberData = member;

                [memberTable reloadData];
                [hud hideAfter:1.0f];
            }else
            {
                if ([json objectForKey:@"msgbox"] != NULL) {
                    [hud setCaption:[json objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    [hud hideAfter:1.0f];
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                    [hud hideAfter:1.0f];
                }
            }
            
        });
    });
    
}

#pragma mark - update user info
- (void)updateUserInfo
{
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    
    MemberEntiy *member = [IsLogIn instance].memberData;
    
    dispatch_queue_t network ;
    network = dispatch_queue_create("update_user_infos", nil);
    dispatch_async(network, ^{
        NSString *user_id = member.idString;
        NSString *nick_name = nickNameField.text;
        NSString *user_name = [IsLogIn instance].memberData.user_name;
        NSString *mobile = mobileField.text;
        NSString *email = emailField.text;
        NSString *city = cityField.text;
        NSString *area = areaField.text;

        NSString *address = member.address;
        NSString *idCard = member.id_card;
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",user_name,@"user_name",nick_name,@"nick_name",mobile,@"mobile",email,@"email",@"1991-01-01",@"birthday",cityID,@"census_register",areaID,@"area",@"0",@"rows",address,@"address",idCard,@"id_card",nil];
        
        NSLog(@"begin================");
        NSLog(@"%@",param );
        NSLog(@"end==================");
        
        NSString *request = [HTTPRequest requestForGetWithPramas:param method:@"update_user_infos"];
        NSDictionary *json = [JsonUtil jsonToDic:request];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [saveBtn setTitle:@"编辑" forState:UIControlStateNormal];
            userField.enabled = NO;
            nickNameField.enabled = NO;
            mobileField.enabled = NO;
            emailField.enabled = NO;
            cityField.enabled = NO;
            areaField.enabled = NO;
            
//            userField.textAlignment = NSTextAlignmentRight;
//            nickNameField.textAlignment = NSTextAlignmentRight;
//            mobileField.textAlignment = NSTextAlignmentRight;
//            emailField.textAlignment = NSTextAlignmentRight;
//            birthField.textAlignment = NSTextAlignmentRight;
//            areaField.textAlignment = NSTextAlignmentRight;
//            streetField.textAlignment = NSTextAlignmentRight;
            
            userField.textAlignment = NSTextAlignmentLeft;
            nickNameField.textAlignment = NSTextAlignmentLeft;
            mobileField.textAlignment = NSTextAlignmentLeft;
            emailField.textAlignment = NSTextAlignmentLeft;
            cityField.textAlignment = NSTextAlignmentLeft;
            areaField.textAlignment = NSTextAlignmentLeft;
            
            if ([[json objectForKey:@"msg"]integerValue] == 1) {
                [hud setCaption:@"会员信息修改成功"];
                [hud setActivity:NO];
                [hud update];
                [hud hideAfter:1.0f];
                
                IsLogIn *login = [IsLogIn instance];
                //member.user_name = user_name;
                member.nick_name = nick_name;
                member.mobileNum = mobile;
//                member.email = email;
//                member.birthday = birth;
                member.city = city;
                member.area = area;
//                member.rows = rows;
                login.memberData = member;
                member.cityId = [cityID integerValue];
                member.areaId = [areaID integerValue];
//                member.rowId = [streetID integerValue];
                [hud hideAfter:1.0f];

            }else
            {
                userField.text = member.user_name;
                nickNameField.text = member.nick_name;
                mobileField.text = member.mobileNum;
                emailField.text = member.email;
                cityField.text = member.city;
                areaField.text = member.area;
                
                if ([json objectForKey:@"msgbox"] != NULL) {
                    [hud setCaption:[json objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    [hud update];
                    [hud hideAfter:1.0f];
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    [hud update];
                    [hud hideAfter:1.0f];
                }
            }
        });
    });
}


- (void)goRegController
{
    MemberRegController * memberRegVC = [[MemberRegController alloc]init];
    [self.navigationController pushViewController:memberRegVC animated:YES];
    [memberRegVC release];
}
- (void)dengluAction
{
    loginView.hidden = YES;
    memberTable.hidden = NO;
}


#pragma mark
#pragma ProductTable methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 0;
    if (section==0) {
        num= 1;
    }
    else if(section==1)
    {
        num= 7;
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
    MemberEntiy *member = [IsLogIn instance].memberData;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor whiteColor];
    if(version<7.0f)
    {
        
    }
    else
    {
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    //tableView.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
    NSInteger index = indexPath.row;
    NSInteger section=[indexPath section];
    
    if (section == 0) {
        static NSString *identifier = @"idenfifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {

            cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huiyuan_kuang01"]] autorelease];
            UIImageView * ivBG = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 62, 62)];
            ivBG.userInteractionEnabled = YES;
            ivBG.image = [UIImage imageNamed:@"huiyuan_touxiang_pic_bg"];
            [cell addSubview:ivBG];
            [ivBG release];
            
            photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 58, 58)];
            photoImage.userInteractionEnabled = YES;
//            [photoImage setImage:[UIImage imageNamed:@"icon"]];
            if ([member.avatar isEqualToString:@"http://183.61.84.207:1234"])
            {
                [photoImage setImage:[UIImage imageNamed:@"icon"]];
            }
            else
            {
                [photoImage setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
            }
            
            
            [ivBG addSubview:photoImage];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(imageTap:)];
            [photoImage addGestureRecognizer:tap];
            [tap release];

            UIImageView *vipImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip"]];
            
            if (member.isvip == 1)
            {
                [vipImage setImage:[UIImage imageNamed:@"vip_h"]];
            }
            
            [vipImage setFrame:CGRectMake(-5, -5, 48, 46)];
            [ivBG addSubview:vipImage];
            [vipImage release];
            
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 150, 95)];
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"上传头像";
            label.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
            [cell addSubview:label];
            [label release];
            [label setTag:814];
            
            
            cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            UIImageView * iv0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
            cell.editingAccessoryView = iv0;
            [iv0 release];
        }
        
        UILabel *label = (UILabel *)[cell viewWithTag:814];
        if ([IsLogIn instance].memberData.signature && ![[IsLogIn instance].memberData.signature isEqualToString:@""]) {
            label.text = [IsLogIn instance].memberData.signature;
        }else
        {
            label.text = @"编辑个性签名";
        }
        
        return cell;
    }else if (section == 1)
    {
        
        
        static NSString *idenfier = @"info";
        MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
        if (!cell) {
            cell = [[[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfier]autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_b"]]autorelease];
            

        }
        switch (index) {
            case 0:
            {
                cell.title = @"用 户 名";
                
                userField.frame=CGRectMake(80, s, 200, 35);

                userField.delegate = self;
                NSString *title = [saveBtn titleForState:UIControlStateNormal];
                if ([title isEqualToString:@"编辑"]) {
                    userField.text = member.user_name;
                }
                [cell addSubview:userField];
//                userField.textAlignment = NSTextAlignmentRight;
            }
                break;
            case 1:
            {
                cell.title = @"昵      称";
                nickNameField.frame=CGRectMake(80, s, 200, 35);
                nickNameField.delegate = self;
//                nickNameField.textAlignment = NSTextAlignmentRight;
                nickNameField.text = member.nick_name;
                [cell addSubview:nickNameField];
            }
                break;
            case 2:
            {
                cell.title = @"手      机";
                mobileField.frame=CGRectMake(80, s, 200, 35);
                mobileField.delegate = self;
                mobileField.text = member.mobileNum;
                mobileField.delegate = self;
//                mobileField.textAlignment = NSTextAlignmentRight;
                [cell addSubview:mobileField];

            }
                break;
            case 3:
            {
                cell.title = @"邮      箱";
                emailField.frame=CGRectMake(80, s, 200, 35);
                emailField.delegate = self;
                emailField.text = member.email;
//                emailField.textAlignment = NSTextAlignmentRight;
                [cell addSubview:emailField];

            }
                break;
            case 4:
            {
//                cell.title = @"出生年月";
//                birthField.frame=CGRectMake(80, s, 200, 35);
//                birthField.delegate = self;
//                birthField.text = member.birthday;
////                birthField.textAlignment = NSTextAlignmentRight;
//             [cell addSubview:birthField];
//            }
//                break;
//            case 5:
//            {
                cell.title = @"所在城市";
                cityField.frame=CGRectMake(80, s, 200, 35);
                cityField.delegate = self;
                cityField.text = member.city;
                
                //                areaField.textAlignment = NSTextAlignmentRight;
                [cell addSubview:cityField];
            }
                break;
            case 5:
            {
                cell.title = @"区      县";
                areaField.frame=CGRectMake(80, s, 200, 35);
                areaField.delegate = self;
                areaField.text = member.area;

//                areaField.textAlignment = NSTextAlignmentRight;
           [cell addSubview:areaField];
            }
                break;
            case 6:
            {
//                cell.title = @"街      道";
//                
//                streetField.frame=CGRectMake(80, s, 200, 35);
//                streetField.delegate = self;
//                streetField.text = member.rows;
////                streetField.textAlignment = NSTextAlignmentRight;
//              [cell addSubview:streetField];
//            }
//                break;
//                
//            case 8:
//            {
    
                static NSString *identifier = @"changepwd";
                MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
                    cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_b"]]autorelease];
                    UIImageView *accessory = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_arrow"]];
                    [accessory setFrame:CGRectMake(262, 10, 8, 12)];
                    [cell addSubview:accessory];
                    [accessory release];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.contentField.enabled = NO;
                    cell.contentField.hidden = YES;
                }
                cell.title = @"修改密码";
                
                return cell;
            }
                break;
            default:
                break;
        }
        NSString *title = [saveBtn titleForState:UIControlStateNormal];
        if ([title isEqualToString:@"编辑"]) {
//            if (cell.contentField != userField)
//            {
//                cell.contentField.enabled = YES;
//                
//                cell.contentField.textAlignment = NSTextAlignmentRight;
//            }
            userField.enabled = NO;
            nickNameField.enabled = NO;
            mobileField.enabled = NO;
            emailField.enabled = NO;
            cityField.enabled = NO;
            areaField.enabled = NO;
        }
        else
        {
//            if (cell.contentField != userField)
//            {
//                cell.contentField.enabled = NO;
//                
//                cell.contentField.textAlignment = NSTextAlignmentLeft;
//            }
            nickNameField.enabled = YES;
            mobileField.enabled = YES;
            emailField.enabled = YES;
            cityField.enabled = YES;
            areaField.enabled = YES;
        }
        
        return cell;
    }
    
    
    return nil;
    
}
- (NSString *)changToDate:(NSString *)longStr
{
    
    NSRange left = [longStr rangeOfString:@"("];
    NSRange right = [longStr rangeOfString:@")"];
    NSRange range  = {left.location+1,right.location - left.location-1};
    NSString *temp = [longStr substringWithRange:range];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[temp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd"];
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
//    [timeZone release];
    NSString * dateStr= [[NSString alloc]initWithString:[formatter stringFromDate:date]] ;
    [formatter release];
    return [dateStr autorelease];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc]init];
    myView.backgroundColor = [UIColor clearColor];
    if (section == 1)
    {
        [myView setFrame:CGRectMake(0, 0, 280, 20)];
        
    }
    else
    {
        [myView setFrame:CGRectMake(0, 0, 280, 10)];
    }
    return [myView autorelease];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row ==0) {
        return 86;
    }
    return 35;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //    if (cell.editingAccessoryView) {
    //        cell.editingAccessoryView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_h"]] autorelease];
    //    }
    int index = indexPath.row;
    int section=[indexPath section];
    switch (section) {
        case 0:
            switch (index)
        {
                case 0:
                {
                    FeedbackViewController *controller = [[FeedbackViewController alloc]init];
                    controller.isSign = YES;
                    controller.delegate = self;
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                }
                    break;
            }
            break;
        case 1:
            switch (index) {
                case 0:
                    break;
                case 1:
                    break;
                case 2:
                    
                    break;
                case 3:
                    
                    break;
                    
                case 4:
                
                    break;
                case 5:
                    
                    break;
                case 6:
                {
                    ModifypwdViewController *modifyPWD = [[ModifypwdViewController alloc]init];
                    [self.navigationController pushViewController:modifyPWD animated:YES];
                    [modifyPWD release];
                    
                }
                    
                 default:
                    break;
            
            }
            break;
        
            
        default:
            break;
    }
    
}




- (void)imageTap:(UITapGestureRecognizer *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    [sheet release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //相机
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        imagePicker.showsCameraControls = YES;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
        [imagePicker release];
    }else if (buttonIndex == 1)
    {
        //相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:imagePicker animated:YES completion:NULL];
        [imagePicker release];
    }else if (buttonIndex == 2)
    {
        
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

   //截取imageview
    CGRect imageRect;
    //计算截取范围
    if (image.size.width>=image.size.height) {
        imageRect=CGRectMake((image.size.width-image.size.height)/2, 0, image.size.height, image.size.height);
    }else{
    imageRect=CGRectMake(0, (image.size.height-image.size.width)/2, image.size.width, image.size.width);
    }
    //生成图片
    CGImageRef cgimage=CGImageCreateWithImageInRect(image.CGImage, imageRect);
    UIImage *creatImage=[[UIImage alloc]initWithCGImage:cgimage];
    //这里主要要释放cgImage
    CGImageRelease(cgimage);

    [self uploadImage:creatImage];
//    [self uploadImage:image];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


- (UIImage *)scaleImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(100,100));
    [image drawInRect:CGRectMake(0, 0, 100,100)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)uploadImage:(UIImage *)image
{
    NSString *userId = [IsLogIn instance].memberData.idString;
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("change_user_img", nil);
    dispatch_async(network_queue, ^{
        
        NSData *data = UIImageJPEGRepresentation(image , 0.1);
        NSString *tem = [data base64Encoding];
        tem =[tem stringByReplacingOccurrencesOfString:@"+" withString:@"|JH|"];
        tem=[tem stringByReplacingOccurrencesOfString:@" " withString:@"|KG|"];
        NSString *lTmp = [NSString stringWithFormat:@"%c",'\n'];
        NSString *lTmp2 = [NSString stringWithFormat:@"%c",'\r'];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp withString:@"|HC|"];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp2 withString:@"|HC|"];
        
        NSString *request = [HTTPRequest requestForPostWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id", nil] method:@"change_user_img" img:tem];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 显示图片到界面
            if ([[dictionary objectForKey:@"msg"]floatValue] == 1) {
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSDictionary *dict = [JsonUtil jsonToDic:dataString];
                MemberEntiy *member = [IsLogIn instance].memberData;
                member.avatar =  [dict objectForKey:@"avatar"];
                [IsLogIn instance].memberData = member;
                
                [photoImage setImage:image];
                
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[dictionary objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"网络出问题了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                }
                
            }
        });
    } );
    
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //        memberTable.frame = CGRectMake(10, 0, 300, self.view.frame.size.height-44-49);

    
    if (textField == cityField)
    {
        if ([[IsLogIn instance] cityArray].count > 0)
        {
            //            CGRect rect = memberTable.frame;
            //            rect.origin.y = -50;
            //            memberTable.frame = rect;
            
            //            UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 216, 320, 216)];
            //            picker.backgroundColor = [UIColor whiteColor];
            //            picker.dataSource = self;
            //            picker.delegate = self;
            //            picker.tag = 814;
            //            [self.view addSubview:picker];
            //            [picker release];
        } else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"暂无区域!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        
        return YES;
    }
    else if (textField == areaField)
    {
        
        if (areaArr.count > 0)
        {
//            CGRect rect = memberTable.frame;
//            rect.origin.y = -50;
//            memberTable.frame = rect;
            
//            UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 216, 320, 216)];
//            picker.backgroundColor = [UIColor whiteColor];
//            picker.dataSource = self;
//            picker.delegate = self;
//            picker.tag = 814;
//            [self.view addSubview:picker];
//            [picker release];
        } else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"暂无区域!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
        
        return YES;
        
    }
//    else if (textField == streetField)
//        {
//        CGRect rect = memberTable.frame;
//        rect.origin.y = -110;
//        memberTable.frame = rect;
//
//    }
//    else if (textField == birthField)
//    {
////        UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"\n\n\n\\n\n\n\\n\n\n\n\n\n\n"
////                                                                  delegate:self
////                                                         cancelButtonTitle:nil
////                                                    destructiveButtonTitle:nil
////                                                         otherButtonTitles:nil] autorelease];
////        actionSheet.userInteractionEnabled = YES;
////        datePicker = [[[UIDatePicker alloc] init] autorelease];
////        datePicker.datePickerMode = UIDatePickerModeDate;
////        [actionSheet addSubview:datePicker];
////        [actionSheet showInView:self.view];
//        return YES;
//    }
    else
    {
        CGRect rect = memberTable.frame;
        rect.origin.y = 0;
        memberTable.frame = rect;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == cityField || textField == areaField)
    {
        CGRect rect = memberTable.frame;
        rect.origin.y = 0;
        memberTable.frame = rect;
    }
}

#pragma mark -  FeedbackViewController delegate
- (void)FeedbackViewController:(FeedbackViewController *)controller didFinishUpdateSignature:(NSString *)signature
{
    
    MemberEntiy *member = [IsLogIn instance].memberData;

    member.signature = signature;
    [IsLogIn instance].memberData = member;
    
    [memberTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPicker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 714)
    {
        return 1;
    }
    else if (pickerView.tag == 814)
    {
        
//        for (NSDictionary * lisDic in [IsLogIn instance].cityArray)
//        {
//            if ([cityField.text isEqualToString:[lisDic objectForKey:@"title"]])
//            {
//                areaArr = [[lisDic objectForKey:@"list"]retain];
//            }
//        }
        return 1;
    }
    
    else if (pickerView.tag == 1000)
    {

//        for (NSDictionary * lisDic in areaArr)
//        {
//            if ([areaField.text isEqualToString:[lisDic objectForKey:@"title"]]) {
//                streetArr = [[lisDic objectForKey:@"list"] retain];
//            }
//        }

        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 714)
    {
        
        return [IsLogIn instance].cityArray.count;
    }
    else if (pickerView.tag == 814)
    {
        return areaArr.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 180;
}


// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 714)
    {
       
    }
    
   else if (pickerView.tag == 814)
   {
       
       
       

    }
   else if (pickerView.tag == 1000)
   {
//        streetField.text = [streetArr[row] objectForKey:@"title"];
    }
    
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 714)
    {
        return [[[IsLogIn instance].cityArray objectAtIndex:row]objectForKey:@"title"];
    }
    else if (pickerView.tag == 814)
    {
        
        NSLog(@"area---->%d",row);
        return [[areaArr objectAtIndex:row]objectForKey:@"title"];
    }
   
    return @"";
}
//UIDatePicker选着出生时间
//-(void)selectDate
//{
//    [birthField resignFirstResponder];
//}

//-(void)dateChange:(UIDatePicker *)picker
//{
//    NSDate *date = picker.date;
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    birthField.text = [dateFormatter stringFromDate:date];
//    [dateFormatter release];
//}


- (void)selectCity
{
    int row = [cityPicker selectedRowInComponent:0];
    
    
    NSLog(@"row = %d",row);
    NSString *city=[[IsLogIn instance].cityArray[row] objectForKey:@"title"];
    
    if (![city isEqualToString:cityField.text])
    {
        cityField.text = city;
        if (areaArr.count)
        {
            [areaArr removeAllObjects];
        }
        areaField.text = @"";
        [areaArr addObjectsFromArray:[[IsLogIn instance].cityArray[row] objectForKey:@"list"]];
        [areapicker reloadAllComponents];

        cityField.text = [[IsLogIn instance].cityArray[row] objectForKey:@"title"];
        cityID = [[[IsLogIn instance].cityArray[row]objectForKey:@"id"] retain];
       
    }

     [cityField resignFirstResponder];
}

-(void)selectArea
{
    int row = [areapicker selectedRowInComponent:0];
    if ([[areaArr[row] objectForKey:@"title"] isKindOfClass:[NSString class]])
    {
        if (![[areaArr [row] objectForKey:@"title"]isEqualToString:areaField.text])
        {
            areaField.text = [areaArr[row] objectForKey:@"title"];
            areaID = [[areaArr[row]objectForKey:@"id"] retain];
            
        }
    }
    [areaField resignFirstResponder];
}

@end