	//
//  SignupViewController.m
//  DreamBaby
//
//  Created by easaa on 14-2-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "SignupViewController.h"
#import "MemberCell.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "ATMHud.h"
#import "ATMHudQueueItem.h"
#import "NSData+Base64.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "ATMHudDelegate.h"
#import "JsonFactory.h"
//#import "SVPullToRefresh.h"
#import "IsLogIn.h"
#import "LoginViewController.h"


@interface SignupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ATMHudDelegate, UIAlertViewDelegate>
{
    
    
    CustomTextField *userNameField;//用户名
    CustomTextField *nickNameField;//昵称
    CustomTextField *passwordField;//密码
    CustomTextField *rightPassWordField;
//    CustomTextField *IdCardField;  //身份证
//    CustomTextField *censusField;  //户籍
    CustomTextField *cityField;    //城市
    CustomTextField *areaField;    //区
//    CustomTextField *streetField;  //街道或具体地址
    
    CustomTextField *mobileField;  //手机号码
    CustomTextField *verifycodeField;  //验证码
    
    CustomTextField *VIPCode;//vip序列号
    
    UIButton    *verifyBtn;    //获取验证码
    
    
    UIImageView *photoImage;
    
    ATMHud *hud;
    
    BOOL opened;
  
    UITableView     *cityTbaleView;
    UITableView     *areaTableView;
//    UITableView     *streetTableView;
    
    NSString        *city;
    NSString        *area;
//    NSString        *street;
    
    UIButton *saveBtn;
    
    NSString *userName;
    NSString *nickName;
    NSString *password;
    NSString *rightPass;
    NSString *idCard;
    NSString *census;
    NSString *mobile;
    NSString *verifyCode;
    NSString *vipCode;
}




@property (nonatomic, retain) NSMutableDictionary *infoDict;

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@property (nonatomic, retain) NSArray *cityArray;
@property (nonatomic, retain) NSArray *areaArray;
//@property (nonatomic, retain) NSArray *streetArray;

@property (nonatomic, retain) UIImage *myImage;

@property(nonatomic, retain)  NSString *cityId;
@property (nonatomic, retain) NSString *areaId;
//@property (nonatomic, retain) NSString *streetId;


@end

@implementation SignupViewController
@synthesize myTableView;


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

    RELEASE_SAFE(userNameField);
    RELEASE_SAFE(nickNameField);
    RELEASE_SAFE(passwordField);
    RELEASE_SAFE(rightPassWordField);
//    RELEASE_SAFE(IdCardField);
    RELEASE_SAFE(cityField);
    RELEASE_SAFE(areaField);
//    RELEASE_SAFE(streetField);
    
    RELEASE_SAFE(mobileField);
    RELEASE_SAFE(verifycodeField);
    RELEASE_SAFE(_infoDict);
    
    RELEASE_SAFE(myTableView);
    RELEASE_SAFE(_avatar);
    RELEASE_SAFE(_selectedIndexPath);
    
    RELEASE_SAFE(_cityArray);
    RELEASE_SAFE(_areaArray);
//    RELEASE_SAFE(_streetArray);
    
    RELEASE_SAFE(_myImage);
    
    RELEASE_SAFE(_cityId);
    RELEASE_SAFE(_areaId);
//    RELEASE_SAFE(_streetId);
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [photoImage release];
    hud.delegate = nil;
    [hud release];
    [verifyBtn release];
    if (timerSource)
    {
        dispatch_source_cancel(timerSource);
    }

    
    [super dealloc];
}


-(void) viewWillAppear:(BOOL)animated
{
    hud = [[ATMHud alloc]initWithDelegate:nil];
    [self.view addSubview:hud.view];
    
    if (![IsLogIn instance].cityArray.count)
    {
        
        [self getArea:YES];
    }else
    {
        self.cityArray = [IsLogIn instance].cityArray;
    }
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (timerSource)
    {
        dispatch_source_cancel(timerSource);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"会员注册";
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:titleLabel];
    int s = 0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue<7.0)
    {
        s = 0;
    
    }
    
    userNameField=[[CustomTextField alloc]initWithFrame:CGRectMake(110, 8 + s, 175, 22)];
    nickNameField=[[CustomTextField alloc]initWithFrame:CGRectMake(110, 8 + s, 175, 22)];
    passwordField =[[CustomTextField alloc]initWithFrame:CGRectMake(110, 8 + s, 175, 22)];
    rightPassWordField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 8 + s, 175, 22)];
//    IdCardField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 8 + s, 175, 22)];
//    censusField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 8 + s, 175, 22)];
    verifycodeField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 8 + s, 175, 22)];
    VIPCode = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 8, 175, 22)];
    if (self.title != nil)
    {
        [titleLabel setText:self.title];
    }
    if (self.navigationItem.title != nil)
    {
        [titleLabel setText:self.navigationItem.title];
    }
//    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveBtn.frame = CGRectMake( 0, 0,60, 35);
//    [saveBtn setBackgroundImage:[UIImage imageNamed:@"top_btn1"] forState:UIControlStateNormal];
//    [saveBtn setBackgroundImage:[UIImage imageNamed:@"top_btn1_h"] forState:UIControlStateHighlighted];
//
//    [saveBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem all oc]initWithCustomView:saveBtn];
//    self.navigationItem.rightBarButtonItem = item;
//    [item release];
    //
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    
    self.infoDict = tempDict;
    
    /**
     *  获取地区
     */
    

    //
//    NSArray *array = [NSArray arrayWithObjects:@"河东区",@"河西区", nil];
//    self.areaArray = array;
//    
//    NSArray *tempStreet = [NSArray array];
//    self.streetArray = tempStreet;
    

    
    //
    UITableView *tempTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 0, 280, [UIScreen mainScreen].bounds.size.height - 20 - 44) style:UITableViewStylePlain];
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0f){
        tempTableView.frame = CGRectMake(20, 0, 280, [UIScreen mainScreen].bounds.size.height - 20 - 44);
    }
    tempTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tempTableView.separatorColor = [UIColor whiteColor];
    
    tempTableView.backgroundColor = [UIColor clearColor];
    tempTableView.backgroundView = nil;
    tempTableView.delegate = self;
    tempTableView.dataSource = self;
    tempTableView.showsHorizontalScrollIndicator=NO;
    tempTableView.showsVerticalScrollIndicator=NO;
//    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    //#d470a8
//    if(version<7.0f){
//        tempTableView.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
////        tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }else{
//        tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }

    [self.view addSubview:tempTableView];
    [self setMyTableView:tempTableView];
    [tempTableView release];
    
//    [tempTableView addPullToRefreshWithActionHandler:^{
//        [self getArea:NO];
//    }position:SVPullToRefreshPositionTop];
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}


- (void)keyboardWillHide:(NSNotification *)n
{
    CGRect rect = self.myTableView.frame;
    rect.origin.y = 0;
    self.myTableView.frame = rect;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.myTableView) {
        return 3;

    }
    else if(tableView == cityTbaleView)
    {
        return 1;
    }
    else if (tableView == areaTableView)
    {
        return 1;
    }
//    else if (tableView == streetTableView)
//    {
//        return 1;
//    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.myTableView)
    {
        if (section == 0)
        {
            return 1;
        }
        else if(section==1)
        {
            return 9;
        }
        else if(section==2)
        {
        return 1;
        }
    }
    
    else if(tableView == cityTbaleView)
    {
        return self.cityArray.count;
    }
    else if (tableView == areaTableView)
    {
        return self.areaArray.count;
    }
//    else if (tableView == streetTableView)
//    {
//        return self.streetArray.count;
//        NSLog(@"streetArrayCount---->%d",self.streetArray.count);
//    }
    
    
    return 0;
}
-(void)gouxuan:(UIButton *)btn
{
    btn.selected=!btn.selected;
    saveBtn.selected=!saveBtn.selected;
    if (saveBtn.selected)
    {
        saveBtn.userInteractionEnabled=NO;
    }
    else if(!saveBtn.selected)
    {
        saveBtn.userInteractionEnabled=YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    NSInteger index = indexPath.row;
    NSInteger section=[indexPath section];
    
    if (tableView == self.myTableView)
    {
        if (section==2&&index==0)
        {
            
            UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *clearV=[[[UIView alloc]init]autorelease];
                cell.backgroundView = clearV;
                cell.backgroundColor = [UIColor clearColor];
                

            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(0, 0, 20, 20);
            [btn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"anniu_h"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(gouxuan:) forControlEvents:UIControlEventTouchUpInside];
            [btn setSelected:YES];
            [cell.contentView addSubview:btn];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x+24, btn.frame.origin.y, 250, 20)];
                label.backgroundColor=[UIColor clearColor];
                label.text=@"我已阅读并同意相关使用条款";
                label.textColor=[UIColor blackColor];
                label.font=[UIFont systemFontOfSize:10];
                [cell.contentView addSubview:label];
                UITapGestureRecognizer *tapLabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
                label.userInteractionEnabled=YES;
                [label addGestureRecognizer:tapLabel];
                [label release];
                saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                saveBtn.frame = CGRectMake( 0, btn.frame.origin.y+30 ,280, 30);
                [saveBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateNormal];
                [saveBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_hh"] forState:UIControlStateSelected];
                saveBtn.selected=NO;
                saveBtn.userInteractionEnabled=YES;
                [saveBtn setTitle:@"注册" forState:UIControlStateNormal];
                [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:saveBtn];
            }
           
            return cell;
        }
        if (section == 0)
        {
            NSString *SimpleTableIdentifier = @"memberCell";
            UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            if (cell == nil) {
                cell =[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = nil;
                cell.backgroundColor = [UIColor clearColor];
                
                cell.backgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huiyuan_kuang01"]] autorelease];


                
                UIImageView * ivBG = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 61, 61)];
                ivBG.userInteractionEnabled = YES;
                ivBG.image = [UIImage imageNamed:@"huiyuan_touxiang_pic_bg"];
                [cell addSubview:ivBG];
                [ivBG release];
                
                photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 56, 56)];
                photoImage.userInteractionEnabled = YES;
                photoImage.image = [UIImage imageNamed:@"icon"];
                [ivBG addSubview:photoImage];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(imageTap:)];
                [photoImage addGestureRecognizer:tap];
                [tap release];
                
                
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 80, 95)];
                label.font = [UIFont systemFontOfSize:14];
                label.backgroundColor = [UIColor clearColor];
                label.text = @"上传头像";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
                [cell addSubview:label];
                [label release];
                [label setTag:814];
                
                
                cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//                UIImageView * iv0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
//                cell.editingAccessoryView = iv0;
//                [iv0 release];
            }
            
                if (self.myImage) {
                    photoImage.image = self.myImage;
            }
            
            return cell;
            
        }
        else
        {
            NSString *SimpleTableIdentifier = @"memberInfoCell";
            MemberCell  *cell = nil;//[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
            if (!cell) {
                cell = [[[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier]autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
//                UIView *cellBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
//                [cellBG setBackgroundColor:[UIColor whiteColor]];
                cell.backgroundColor = [UIColor clearColor];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
                [imageView setImage:[UIImage imageNamed:@"huiyuanzhongxing"]];
//                [imageView setImage:[UIImage imageNamed:@"yingzhengma"]];
//                cell.backgroundView = imageView;
                [cell insertSubview:imageView atIndex:0];
                [imageView release];
                
                if (index == 4)
                {
//                    cell.contentField.userInteractionEnabled = NO;
//                    cell.contentField.hidden = YES;
//                    
//                    cell.title = @"* 户籍所在地";
//                    //                    censusField = [[CustomTextField alloc]initWithFrame:CGRectMake(120, 12, 190, 45)];
//                    censusField.font=[UIFont systemFontOfSize:12];
//                    censusField.delegate = self;
//                    censusField.returnKeyType = UIReturnKeyNext;
//                    //censusField.text = [self.infoDict objectForKey:@"census"];
//                    censusField.text = @"天津市";
//                    census = @"天津市";
//                    [self.infoDict setObject:census forKey:@"census"];
//                    [cell addSubview:censusField];

                    cell.contentField.userInteractionEnabled = NO;
                    cell.contentField.hidden = YES;
                    
                    cell.title = @"* 所 在 城  市";
                    
                    
                    cityField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 4, 155, 22)];
                    cityField.enabled = NO;
                    cityField.backgroundColor = [UIColor clearColor];
                    cityField.textAlignment = UITextAlignmentLeft;
                    [cityField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                    //                    areaField.placeholder = @"请选择";
                    cityField.font = [UIFont systemFontOfSize:12];
                    [cell.contentView addSubview:cityField];
                    
                    
                    cityTbaleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 280, self.cityArray.count * 30)];
                    if([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0f)
                    {
                        cityTbaleView.frame = CGRectMake(0, 30, 280, self.cityArray.count * 30);
                    }
                    cityTbaleView.backgroundView = nil;
                    cityTbaleView.backgroundColor = [UIColor colorWithRed:253/255.0 green:241/255.0 blue:248.0/255 alpha:1];
                    cityTbaleView.separatorColor = [UIColor colorWithRed:243/255.0 green:211/255.0 blue:228.0/255 alpha:1];
                    cityTbaleView.delegate = self;
                    cityTbaleView.dataSource = self;
                    cityTbaleView.hidden = YES;
                    //                    [self.view bringSubviewToFront:areaTableView];
                    [cell.contentView addSubview:cityTbaleView];
                    [cityTbaleView release];
                    
                }
                else if (index == 5)
                {
                    
                    cell.contentField.userInteractionEnabled = NO;
                    cell.contentField.hidden = YES;
                    
                    cell.title = @"* 区    /     县";

                    
                    areaField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 4, 155, 22)];
                    areaField.enabled = NO;
                    areaField.backgroundColor = [UIColor clearColor];
                    areaField.textAlignment = UITextAlignmentLeft;
                    [areaField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//                    areaField.placeholder = @"请选择";
                    areaField.font = [UIFont systemFontOfSize:12];
                    [cell.contentView addSubview:areaField];
                    
                    
//                    UIView *arrowView = [[UIView alloc]initWithFrame:CGRectMake(275, 27/2.0, 18, 18)];
////                    arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03"]];
//                    arrowView.tag = 115;
//                    [cell.contentView addSubview:arrowView];
//                    [arrowView release];
                    
                    
                    areaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 280, self.areaArray.count * 30)];
                    if([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0f)
                    {
                        areaTableView.frame = CGRectMake(0, 30, 280, self.areaArray.count * 30);
                    }
                    areaTableView.backgroundView = nil;
                    areaTableView.backgroundColor = [UIColor colorWithRed:253/255.0 green:241/255.0 blue:248.0/255 alpha:1];
                    areaTableView.separatorColor = [UIColor colorWithRed:243/255.0 green:211/255.0 blue:228.0/255 alpha:1];
                    areaTableView.delegate = self;
                    areaTableView.dataSource = self;
                    areaTableView.hidden = YES;
//                    [self.view bringSubviewToFront:areaTableView];
                    [cell.contentView addSubview:areaTableView];
                    [areaTableView release];
                }
//                else if (index == 7)
//                {
//                    //
//                    cell.contentField.userInteractionEnabled = NO;
//                    cell.contentField.hidden = YES;
//
//                    streetField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 4, 155, 22)];
//                    streetField.enabled = NO;
//                    streetField.backgroundColor = [UIColor clearColor];
//                    streetField.textAlignment = UITextAlignmentLeft;
//                    [streetField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
////                    streetField.placeholder = @"请选择";
//                    streetField.font = [UIFont systemFontOfSize:12];
//                    [cell.contentView addSubview:streetField];
//                    
//                    
//                    cell.title = @"  街           道";
////                    UIView *arrowView = [[UIView alloc]initWithFrame:CGRectMake(275,27/2.0, 18, 18)];
//////                    arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03"]];
////                    arrowView.tag = 115;
////                    [cell.contentView addSubview:arrowView];
////                    [arrowView release];
//                    
//                    streetTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, 280, self.streetArray.count * 30)];
//                    if([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0f){
//                        streetTableView.frame = CGRectMake(0, 30, 280, self.areaArray.count * 30);
//                    }
//                    streetTableView.backgroundView = nil;
//                    streetTableView.backgroundColor = [UIColor colorWithRed:253/255.0 green:241/255.0 blue:248.0/255 alpha:1];
//                    streetTableView.separatorColor = [UIColor colorWithRed:243/255.0 green:211/255.0 blue:228.0/255 alpha:1];
//                    streetTableView.delegate = self;
//                    streetTableView.dataSource = self;
//                    streetTableView.hidden = YES;
//
//                    [cell.contentView addSubview:streetTableView];
//                }
                else if (index == 6)
                {
                    [cell.backgroundView removeFromSuperview];
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 29)];
                    [imageView setImage:[UIImage imageNamed:@"yingzhengma"]];
                    [cell insertSubview:imageView atIndex:1];
                    [imageView release];
//                    cell.backgroundView = imageView;
                    mobileField = [[CustomTextField alloc]initWithFrame:CGRectMake(103, 4, 85, 22)];

//                    mobileField.borderStyle = UITextBorderStyleRoundedRect;
//                    mobileField.backgroundColor = [UIColor colorWithRed:197.0/255 green:182.0/255 blue:188.0/255 alpha:1];
                    mobileField.delegate = self;
                    mobileField.returnKeyType = UIReturnKeyNext;
                    [cell.contentView addSubview:mobileField];
                    
                    if (verifyBtn == nil)
                    {
                        int s=0;
                        if ([UIDevice currentDevice].systemVersion.floatValue>=7.0) {
                            s=0;
                        }
                       
                        verifyBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
                        verifyBtn.frame =  CGRectMake(180-s, 4, 92, 22);
                        [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                        [verifyBtn setBackgroundImage:[UIImage imageNamed:@"zhuce_yanzhengma_btn"] forState:UIControlStateNormal];
//                        [verifyBtn setBackgroundImage:[UIImage imageNamed:@"zhuce_yanzhengma_btn_h"] forState:UIControlStateHighlighted];
                        [verifyBtn addTarget:self action:@selector(getCheckCodeAction:) forControlEvents:UIControlEventTouchUpInside];
                        [verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                    }
                    [cell addSubview:verifyBtn];
                }
            }
            
            switch (index) {
                case 0:
                {
                    //昵称
                    cell.title = @"* 用    户    名";
//                    userNameField=[[CustomTextField alloc]initWithFrame:CGRectMake(110, 12, 190, 45)];
                    
//                    userNameField = cell.contentField;
                    userNameField.font=[UIFont systemFontOfSize:12];
                    
                    userNameField.placeholder = @"请填写用户名";
                    userNameField.delegate = self;
                    userNameField.returnKeyType = UIReturnKeyNext;
                    userNameField.text = [self.infoDict objectForKey:@"userName"];
                    [cell addSubview:userNameField];
                }
                    break;
                case 1:
                {
                    //昵称
                    cell.title = @"* 昵           称";
                    //                    userNameField=[[CustomTextField alloc]initWithFrame:CGRectMake(110, 12, 190, 45)];
                    
                    //                    userNameField = cell.contentField;
                    nickNameField.font=[UIFont systemFontOfSize:12];
                    
                    nickNameField.placeholder = @"请输入昵称";
                    nickNameField.delegate = self;
                    nickNameField.returnKeyType = UIReturnKeyNext;
                    nickNameField.text = [self.infoDict objectForKey:@"nick_name"];
                    [cell addSubview:nickNameField];
                }
                    break;
                case 2:
                {
                    //密码
                    cell.title = @"* 密           码";
//                    passwordField =[[CustomTextField alloc]initWithFrame:CGRectMake(110, 12, 190, 45)];
                    passwordField.font=[UIFont systemFontOfSize:12];
                    passwordField.placeholder = @"请输入6-12位密码";
                    passwordField.delegate = self;
                    passwordField.secureTextEntry = YES;
                    passwordField.returnKeyType =  UIReturnKeyNext;
                    passwordField.text = [self.infoDict objectForKey:@"password"];
                    [cell addSubview:passwordField];
                }
                    break;
                case 3:
                {
                    cell.title = @"* 确 认 密  码";
                    rightPassWordField.font=[UIFont systemFontOfSize:12];
                    rightPassWordField.placeholder = @"请输入6-12位密码";
                    rightPassWordField.delegate = self;
                    rightPassWordField.secureTextEntry = YES;
                    rightPassWordField.returnKeyType =  UIReturnKeyNext;
                    rightPassWordField.text = [self.infoDict objectForKey:@"rightpassword"];
                    [cell addSubview:rightPassWordField];
                }break;
//                case 4:
//                {
//                    //身份证前六位
//                    cell.title = @"*身份证前6位";
//                    IdCardField.font=[UIFont systemFontOfSize:12];
//                    IdCardField.delegate = self;
//                    IdCardField.keyboardType = UIKeyboardTypeNumberPad;
//                    IdCardField.returnKeyType = UIReturnKeyNext;
//                    IdCardField.text = [self.infoDict objectForKey:@"idCard"];
//                    [cell addSubview:IdCardField];
//                }
//                    break;
                case 4:
                {
                    //户籍
                    
                    
                    if ([self.selectedIndexPath isEqual:indexPath] && opened)
                    {
                        //                        arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03_h"]];
                        cityTbaleView.hidden = NO;
                        
                    }
                    else
                    {
                        //                        arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03"]];
                        cityTbaleView.hidden = YES;
                        
                    }
                    
                    cityField.text = city;
                }
                    break;
//                case 4:
//                {
//                    //现住址
//                    cell.title = @"现住址:";
//                    cityField = cell.contentField;
//                    cityField.enabled = NO;
//                    cityField.text = @"天津市";
//                }
//                    break;
                case  5:
                {
                    
//                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
//                    [imageView setImage:[UIImage imageNamed:@"huiyuanzhongxing"]];
//                    //                [imageView setImage:[UIImage imageNamed:@"yingzhengma"]];
//                    cell.backgroundView = imageView;
//                    UIView *arrowView = [cell.contentView viewWithTag:115];
                    if ([self.selectedIndexPath isEqual:indexPath] && opened)
                    {
//                        arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03_h"]];
                        areaTableView.hidden = NO;
                        
                    }
                    else
                    {
//                        arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03"]];
                        areaTableView.hidden = YES;

                    }
                    
                    areaField.text = area;
                    
                }
                    break;
//                case 7:
//                {
////                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
////                    [imageView setImage:[UIImage imageNamed:@"huiyuanzhongxing"]];
////                    //                [imageView setImage:[UIImage imageNamed:@"yingzhengma"]];
////                    cell.backgroundView = imageView;
//                    // cell.backgroundView.hidden = YES;
////                    UIView *arrowView = [cell.contentView viewWithTag:115];
//                    if ([self.selectedIndexPath isEqual:indexPath] && opened)
//                    {
////                        arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03_h"]];
//                        streetTableView.hidden = NO;
//                        
//                    }
//                    else
//                    {
////                        arrowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tongyong_arrow03"]];
//                        streetTableView.hidden = YES;
//                        
//
//                        
//                        
//                    }
                    
//                    streetField.text = street;
//                }
//                    break;
                case 6:
                {
                    //手机
                    cell.title = @"* 手           机";
                    cell.contentField.enabled = NO;
                    mobileField.font = [UIFont systemFontOfSize:12];
                    mobileField.delegate = self;
                    mobileField.keyboardType = UIKeyboardTypeNumberPad;
                    mobileField.text = [self.infoDict objectForKey:@"mobile"];
                }
                    break;
                case 7:
                {
                    //验证码
                    cell.title = @"  验    证    码";
//                    verifycodeField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 12, 190, 45)];
                    verifycodeField.font=[UIFont systemFontOfSize:12];
                    verifycodeField.delegate = self;
                    verifycodeField.placeholder=@"60秒内请不要重新获取验证码";
                    verifycodeField.keyboardType = UIKeyboardTypeNumberPad;
                    verifycodeField.returnKeyType = UIReturnKeyDone;
                    
//                    verifycodeField.text = [self.infoDict objectForKey:@"verifyCode"];
                    [cell addSubview:verifycodeField];
                }
                    break;
                    case 8:
                {
                    cell.title = @"  序    列    号";
                    //                    verifycodeField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 12, 190, 45)];
                    VIPCode.font=[UIFont systemFontOfSize:12];
                    VIPCode.delegate = self;
                    VIPCode.keyboardType = UIKeyboardTypeNumberPad;
                    VIPCode.returnKeyType = UIReturnKeyDone;
                    [cell addSubview:VIPCode];
                }
                    break;
                default:
                    break;
            }
            return cell;
        }
    }
    else if (tableView == cityTbaleView)
    {
        static NSString *identifier = @"city";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
            //            cell.selectionStyle =
        }
        cell.textLabel.text = [[self.cityArray objectAtIndex:index]objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    }
    else if (tableView == areaTableView)
    {
        static NSString *identifier = @"area";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
//            cell.selectionStyle = 
        }
        cell.textLabel.text = [[self.areaArray objectAtIndex:index]objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    }
//    else if (tableView == streetTableView)
//    {
//        static NSString *identifier = @"street";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
//            //            cell.selectionStyle =
//        }
//        cell.textLabel.text = [[self.streetArray objectAtIndex:indexPath.row]objectForKey:@"title"];
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.textLabel.textAlignment = NSTextAlignmentLeft;
//        return cell;
//    }

   return nil;
    
}
-(void)getPhoneCheck:(NSString *)phone andBtn:(UIButton *)btn{
    mobile=phone;
    [self getCheckCodeAction:btn];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.myTableView)
    {
        if (indexPath.section == 1)
        {
            
            if (indexPath.row == 4 )
            {
                if (self.selectedIndexPath != nil)
                {
                    if (self.selectedIndexPath.row == indexPath.row )
                    {
                        opened = !opened;
                        
                    }
                    else
                    {
                        self.selectedIndexPath = indexPath;
                        self.selectedIndexPath =  [NSIndexPath indexPathForRow:4 inSection:1];
                        opened = YES;
                        
                    }
                }
                else
                {
                    self.selectedIndexPath =  [NSIndexPath indexPathForRow:4 inSection:1];
                    opened = YES;
                    
                }
                
                [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1],[NSIndexPath indexPathForRow:5 inSection:1], [NSIndexPath indexPathForRow:8 inSection:1],[NSIndexPath indexPathForRow:6 inSection:1],[NSIndexPath indexPathForRow:7 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else if (indexPath.row == 5 )
            {
                if (self.selectedIndexPath != nil)
                {
                    if (self.selectedIndexPath.row == indexPath.row )
                    {
                        if (!self.cityId)
                        {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择所在城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            [alertView release];
                            return;
                        }
                        opened = !opened;
                        
                    }
                    else
                    {
                        if (!self.cityId)
                        {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择所在城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            [alertView release];
                            return;
                        }
                        
                        self.selectedIndexPath = indexPath;
                        self.selectedIndexPath =  [NSIndexPath indexPathForRow:5 inSection:1];
                        opened = YES;
                        
                    }
                }
                else
                {
                    if (!self.cityId)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择所在城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        [alertView release];
                        return;
                    }
                    self.selectedIndexPath =  [NSIndexPath indexPathForRow:5 inSection:1];
                    opened = YES;
                    
                    
                }
                
                [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1],[NSIndexPath indexPathForRow:6 inSection:1],[NSIndexPath indexPathForRow:7 inSection:1],[NSIndexPath indexPathForRow:8 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }
//            else if (indexPath.row == 7)
//            {
//                if (self.selectedIndexPath != nil)
//                {
//                    if (self.selectedIndexPath.row == indexPath.row )
//                    {
//                        if (!self.areaId) {
//                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择区域" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alertView show];
//                            [alertView release];
//                            return;
//                        }
//                        opened = !opened;
//
//                    }else
//                    {
//                        if (!self.areaId)
//                        {
//                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择区域" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alertView show];
//                            [alertView release];
//                            return;
//                        }
//                        
//                        self.selectedIndexPath = indexPath;
//                        self.selectedIndexPath =  [NSIndexPath indexPathForRow:7 inSection:1];
//                        opened = YES;
//
//                    }
//                }
//                else
//                {
//                    if (!self.areaId)
//                    {
//                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择区域" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alertView show];
//                        [alertView release];
//                        return;
//                    }
//                    self.selectedIndexPath =  [NSIndexPath indexPathForRow:7 inSection:1];
//                    opened = YES;
//
//                    
//                }
//                
//                [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1],[NSIndexPath indexPathForRow:6 inSection:1],[NSIndexPath indexPathForRow:7 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
//            }
//            else
//            {
//                opened = NO;
//                [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1],[NSIndexPath indexPathForRow:6 inSection:1],[NSIndexPath indexPathForRow:7 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
//                self.selectedIndexPath = indexPath;
//            }
        }
    }
    else if (tableView == cityTbaleView)
    {
        city = [[self.cityArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        opened = NO;
        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1],[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *string = [[self.cityArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        cityField.text = string;
        
        
        
        self.cityId = [[self.cityArray objectAtIndex:indexPath.row]objectForKey:@"id"];
        NSLog(@"begin================");
        NSLog(@"%@",self.cityId );
        NSLog(@"end==================");
        self.areaArray = [[self.cityArray objectAtIndex:indexPath.row]objectForKey:@"list"];
        
        self.areaId = nil;
        area = @"";
        areaField.text = @"";
        
//        self.streetId = nil;
//        street = @"";
//        streetField.text = @"";
        
    }
    
    else if (tableView == areaTableView)
    {
        area = [[self.areaArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        opened = NO;
        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *string = [[self.areaArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        areaField.text = string;
        
        

        self.areaId = [[self.areaArray objectAtIndex:indexPath.row]objectForKey:@"id"];
        NSLog(@"begin================");
        NSLog(@"%@",self.areaId );
        NSLog(@"end==================");
//        self.streetArray = [[self.areaArray objectAtIndex:indexPath.row]objectForKey:@"list"];
//        
//        self.streetId = nil;
//        street = @"";
//        streetField.text = @"";
        
    }
//    else if (tableView == streetTableView)
//    {
//        street = [[self.streetArray objectAtIndex:indexPath.row]objectForKey:@"title"];
//        opened = NO;
//        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:1],[NSIndexPath indexPathForRow:7 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
//        
//        
//
//        
//        NSString *string = [[self.streetArray objectAtIndex:indexPath.row]objectForKey:@"title"];
//        streetField.text = string;
//        self.streetId = [[self.streetArray objectAtIndex:indexPath.row]objectForKey:@"id"];
//        
//        
//        NSLog(@"begin================");
//        NSLog(@"%@",self.streetId );
//        NSLog(@"end==================");
//    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.myTableView) {
        if (indexPath.section==2&&indexPath.row==0) {
            return 70;
        }
        if (indexPath.section ==0 && indexPath.row ==0) {
            return 78;
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 4 ||indexPath.row == 5)
            {
                
                if ([self.selectedIndexPath isEqual:indexPath] && opened)
                {
                    if(indexPath.row == 4)
                    {
                        return 30 + self.cityArray.count * 30;
                        
                    }
                    else if(indexPath.row == 5)
                    {
                        return 30 + self.areaArray.count * 30;
                        
                    }
//                    else
//                    {
//                        return 30 + self.streetArray.count * 30;
//                        NSLog(@"street------>%d",self.streetArray.count);
//                    }
                }
                else
                {
                    return 31;
                }
            }else
            {
                return 31;
            }
           
    }
    else if(tableView == cityTbaleView)
    {
        return 31;
    }
    else if (tableView == areaTableView)
    {
        return 31;
    }
//    else if (tableView == streetTableView)
//    {
//        return 31;
//    }
    
    }
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.myTableView)
    {
        return 20;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 20)];
    myView.backgroundColor = [UIColor clearColor];
    return [myView autorelease];
}
-(void)tapLabel:(UITapGestureRecognizer *)tap
{
    PrivacyViewController *privacy=[[PrivacyViewController alloc]init];
    [self.navigationController pushViewController:privacy animated:YES];
    [privacy release];
}

- (void)imageTap:(UITapGestureRecognizer *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
    [sheet showInView:self.view];
    [sheet release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //相机
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        imagePicker.showsCameraControls = YES;
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

#pragma mark -- image的翻转
-(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [self rotateImage:[info objectForKey:UIImagePickerControllerEditedImage]];
//    UIImage *pickImage = [self scaleImage:image];
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

    [photoImage setImage:creatImage];

//    self.myImage = creatImage;
//    self.myImage = image;
    self.myImage = creatImage;
    [self uploadImage:creatImage];
//    [self uploadImage:image];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userNameField)
    {
        [nickNameField becomeFirstResponder];
    }
    else if(textField == nickNameField)
    {
        [passwordField becomeFirstResponder];
    }
    else if (textField == passwordField)
    {
//        [IdCardField becomeFirstResponder];
//    }
//    else if (textField == IdCardField)
//    {
        [cityField becomeFirstResponder];
    }
    else if (textField == cityField)
    {
        [areaField becomeFirstResponder];
    }
    else if (textField == areaField)
    {
//        [streetField becomeFirstResponder];
//    }
//    else if (textField == streetField)
//    {
        [mobileField becomeFirstResponder];
    }
    else if (textField == mobileField)
    {
        [verifycodeField becomeFirstResponder];
    }
    else if (textField == verifycodeField)
    {
        [verifycodeField resignFirstResponder];
        [self requestForSignUpwithPass:nil andRight:nil];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == userNameField) {
        userName = textField.text;
        [self.infoDict setObject:userName forKey:@"userName"];
    }
    else if (textField == nickNameField)
    {
        nickName = textField.text;
        [self.infoDict setObject:nickName forKey:@"nick_name"];
    }
    else if (textField == passwordField)
    {
        password = textField.text;
        [self.infoDict setObject:password forKey:@"password"];
    }
    else if (textField==rightPassWordField)
    {
        rightPass=rightPassWordField.text;
        [self.infoDict setObject:rightPass forKey:@"rightpassword"];
    }
//    else if (textField == IdCardField)
//    {
//        idCard = textField.text;
//        [self.infoDict setObject:idCard forKey:@"idCard"];
//
//    }
    else if (textField == cityField)
    {
        census = textField.text;
        [self.infoDict setObject:census forKey:@"census"];

    }
    else if (textField == mobileField)
    {
        mobile = textField.text;
        [self.infoDict setObject:mobile forKey:@"mobile"];

    }
    else if(textField == VIPCode)
    {
        vipCode = textField.text;
        [self.infoDict setObject:vipCode forKey:@"vipCode"];
    }
//        else if (textField == verifycodeField)
//    {
//        verifyCode = textField.text;
//        [self.infoDict setObject:verifyCode forKey:@"verifyCode"];
//
//    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == userNameField || textField ==  passwordField) {
        CGRect rect = self.myTableView.frame;
        rect.origin.y = 0;
        self.myTableView.frame = rect;

    }
    
//    if (textField == IdCardField) {
//        CGRect rect = self.myTableView.frame;
//        rect.origin.y = -100;
//        self.myTableView.frame = rect;
//    }
//        else if (textField == cityField)
//    {
//        CGRect rect = self.myTableView.frame;
//        rect.origin.y = -100;
//        self.myTableView.frame = rect;
//    }
    else if (textField == cityField || textField == areaField )
    {
        CGRect rect = self.myTableView.frame;
        rect.origin.y = -100;
        self.myTableView.frame = rect;
        
    }
    else if (textField == mobileField)
    {
        CGRect rect = self.myTableView.frame;
        rect.origin.y = -150;
        self.myTableView.frame = rect;
        
    }else if (textField == verifycodeField)
    {
        CGRect rect = self.myTableView.frame;
        rect.origin.y = -200;
        self.myTableView.frame = rect;
    }
    else if (textField == VIPCode)
    {
        CGRect rect = self.myTableView.frame;
        rect.origin.y = -240;
        self.myTableView.frame = rect;
    }
    return YES;
}

- (void)saveBtnAction:(UIButton *)button
{
    [self requestForSignUpwithPass:nil andRight:nil ];
}

- (void)requestForSignUpwithPass:(NSString *)pass andRight:(NSString *)right
 {
     userName =  [self.infoDict objectForKey:@"userName"];
     nickName = [self.infoDict objectForKey:@"nick_name"];
     password =  [self.infoDict objectForKey:@"password"] ;
     rightPass=[self.infoDict objectForKey:@"rightpassword"];
//     idCard =  [self.infoDict objectForKey:@"idCard"];
     mobile =  [self.infoDict objectForKey:@"mobile"];
    
    
     if (pass&&right)
     {
         password=pass;
         rightPass=right;
     }
   
    
     if (userName.length == 0 ||nickName.length == 0|| password.length == 0  || mobile.length == 0 || city.length == 0||area.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
     if (![rightPass isEqualToString:password]) {
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
         [alert show];
         [alert release];
         return;
     }
//    if (!self.myImage) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请上传头像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        [alertView release];
//        return;
//    }
    
//    if (idCard.length != 6) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入身份证前六位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        [alertView release];
//        return;
//    }
    
    if (![self isMobileNumber:mobile]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if (!(verifycodeField.text != nil && verifycodeField.text.length > 0))
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    hud.delegate = nil;
    [hud show];
    
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("register", nil);
    dispatch_async(network_queue, ^{
        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:userNameField.text,@"user_name",
                                 nickNameField.text,@"nick_name",
                                    passwordField.text,@"password",
                                    self.cityId,@"census_register",
                                    self.areaId ,@"area",
                                    @"0",@"rows",
                                    @"141474",@"id_card",
                                    mobileField.text,@"mobile",
                                   verifycodeField.text, @"validatenum",
                                    VIPCode.text,@"serial_no",
                                    nil];
        NSData *data = UIImageJPEGRepresentation(self.myImage , 0.1);
        NSString *tem = [data base64Encoding];
        tem = [NSString stringWithFormat:@"%@",tem];
        tem =[tem stringByReplacingOccurrencesOfString:@"+" withString:@"|JH|"];
        tem=[tem stringByReplacingOccurrencesOfString:@" " withString:@"|KG|"];
        NSString *lTmp = [NSString stringWithFormat:@"%c",'\n'];
        NSString *lTmp2 = [NSString stringWithFormat:@"%c",'\r'];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp withString:@"|HC|"];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp2 withString:@"|HC|"];
        
        NSString *paramsJson = [JsonFactory dictoryToJsonStr:postDic];
        
        //    NSLog(@"requestParamstr %@",paramsJson);
        //加密
        paramsJson = [[FBEncryptorDES encrypt:paramsJson
                                    keyString:@"SDFL#)@F"] uppercaseString];
        NSString *signs= [NSString stringWithFormat:@"SDFL#)@FMethod%@Params%@SDFL#)@F",@"user_register",paramsJson];
        signs = [[FBEncryptorDES md5:signs] uppercaseString];
        
        NSString *urlStr = [NSString stringWithFormat:BABYAPI,@"user_register",paramsJson,signs];
        //            NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.23:16327/api/GetFetationInfo.ashx?Method=%@&Params=%@&Sign=%@",@"add_note",paramsJson,signs];
        NSString *postString = [NSString stringWithFormat:@"avatar=%@",tem];
        //            NSData *postData = [self htmlImageString:tem textViewString:postString];
        NSString *request = [HTTPRequest requestForPost:urlStr :postString];
        //            NSString *request = [HTTPRequest requestForHtmlPost:urlStr :postData];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
        });
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([[dictionary objectForKey:@"msg"]intValue] == 1)
            {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:ProductionDate];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:LastMenstruation];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:ParentDate];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                LoginViewController *loginVc = [self.navigationController.viewControllers
                                                objectAtIndex:[self.navigationController.viewControllers indexOfObject:self] - 1];
                loginVc.isRegisterSuccess = YES;
                loginVc.strRegisterUserName = userNameField.text;
                loginVc.strRegisterUserPwd = passwordField.text;
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != nil) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[dictionary objectForKey:@"msgbox"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                    
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"网络不给力,请检查" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                    
                }
            }
        });
        
    });
//    NSString *path=[self dataFilePath:@"dataPath"];
//    [self.infoDict writeToFile:path atomically:YES];
}




#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 获取区域接口
- (void)getArea:(BOOL)isFirst
{
//    if (isFirst) {
//        [hud setCaption:@"加载中"];
//        [hud setActivity:YES];
//        [hud show];
//    }
    [hud setCaption:@"加载中"];
    [hud setActivity:YES];
    [hud show];
    dispatch_queue_t network;
    network = dispatch_queue_create("getarea", nil);
    dispatch_async(network, ^{
        
        //do the request here
        NSString *request = [HTTPRequest requestForGetWithPramas:nil method:@"getarea"];
        NSDictionary *json = [JsonUtil jsonToDic:request];
//        NSLog(@"json :%@",[json description]);

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isFirst)
            {
                hud.delegate = nil;
            }
            
//            [self.myTableView.pullToRefreshView stopAnimating];
            
            if ([[json objectForKey:@"msg"]intValue] > 0)
            {
                hud.delegate = nil;
                [hud hideAfter:0.5f];
                NSString *dataString = [json objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSLog(@"dataString :%@",dataString);
                
                NSArray *tempArray = [JsonUtil jsonToArray:dataString];
                
                self.cityArray = [tempArray retain];
                
                NSLog(@"city Array --->%@",self.cityArray);
                
                
                [IsLogIn instance].cityArray = tempArray;
                [tempArray release];
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
    dispatch_queue_t network_queue;
    network_queue = dispatch_queue_create("upLoadImage", nil);
    dispatch_async(network_queue, ^{
        
        NSData *data = UIImageJPEGRepresentation(image , 0.1);
        NSString *tem = [data base64Encoding];
        tem =[tem stringByReplacingOccurrencesOfString:@"+" withString:@"|JH|"];
        tem=[tem stringByReplacingOccurrencesOfString:@" " withString:@"|KG|"];
        NSString *lTmp = [NSString stringWithFormat:@"%c",'\n'];
        NSString *lTmp2 = [NSString stringWithFormat:@"%c",'\r'];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp withString:@"|HC|"];
        tem= [tem stringByReplacingOccurrencesOfString:lTmp2 withString:@"|HC|"];
        
        NSString *request = [HTTPRequest requestForPostWithPramas:nil method:@"upload_avatar" img:tem];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 显示图片到界面
            if ([[dictionary objectForKey:@"msg"]floatValue] == 1) {
                NSString *dataString = [dictionary objectForKey:@"data"];
                dataString = [FBEncryptorDES decrypt:dataString keyString:@"SDFL#)@F"];
                dataString = [dataString URLDecodedString];
                NSDictionary *dict = [JsonUtil jsonToDic:dataString];
                self.avatar = [dict objectForKey:@"server_path"];
                [photoImage setImage:image];
                
                self.myImage = image;
                
            }else
            {
                if ([dictionary objectForKey:@"msgbox"] != NULL) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                                       message:@"图片上次不成功"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                    
                }else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                                       message:@"图片上次不成功"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [alertView release];
                    
                }
            }
        });
    } );
    
}

- (void)hudDidDisappear:(ATMHud *)_hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 验证手机号码

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
    NSString * CT = @"^1(([0-9])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
//    NSString *strRex = @"^((13[0-9])|(15[^4,//D])|(18[0,5-9]))//d{8}$";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRex];
//    if ([predicate evaluateWithObject:mobileNum])
//    {
//        return YES;
//    }
//    return NO;
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

#pragma mark - 获取验证码

- (void)getCheckCodeAction:(UIButton *)sender{
    [self.view endEditing:YES];
//    NSLog(@"model1=====%@",mobile);
    void (^changeStatus)(void) = ^(void){
        sender.enabled = NO;
        __block int timerout = 60.f;//60秒后重新获取验证码
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timerSource, dispatch_walltime(NULL, 0), 1.f*NSEC_PER_SEC, 0);//每秒执行
        dispatch_source_set_event_handler(timerSource, ^{
            if (timerout <= 0)
            {//倒计时结束
                dispatch_source_cancel(timerSource);
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender setTitle:@"获取验证码" forState:UIControlStateDisabled];
                        sender.enabled = YES;
                    });
                });
            } else
            {
                @autoreleasepool
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *strTime = [NSString stringWithFormat:@"%d秒后获取", timerout];
                        NSLog(@"%@", strTime);
                        [verifyBtn setTitle:strTime forState:UIControlStateDisabled];
//                        [verifyBtn setNeedsDisplay];
                    });
                }
                --timerout;
            }
        });
        dispatch_source_set_cancel_handler(timerSource, ^{
            dispatch_release(timerSource);
            timerSource = nil;
        });
        dispatch_resume(timerSource);
    };
    
    if (!(mobile != nil &&
          mobile.length > 0 &&
          [self isMobileNumber:mobile]))
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"手机号码有误!" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else
    {
        changeStatus();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: mobile,@"mobile", nil];
            NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"sendsms"];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
            NSLog(@"%@", dictionary);
        });
        
    }
}
//获取存储路径
-(NSString *)dataFilePath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:path];
}
@end
