//
//  ChangePwdViewController.m
//  DreamBaby
//
//  Created by easaa on 14-2-18.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "ATMHud.h"
#include "MemberCell.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "IsLogIn.h"
#import "ATMHudDelegate.h"
@interface ChangePwdViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ATMHudDelegate>
{
    CustomTextField *newField;
    ATMHud *hud;
    UIButton *saveBtn;
}
@end

@implementation ChangePwdViewController

- (void)dealloc
{
     hud.delegate = nil;
    [hud release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"修改密码";
    newField = [[CustomTextField alloc]init];
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
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320,[UIScreen mainScreen].bounds.size.height - 20 - 44 - 49 - 40) style:UITableViewStyleGrouped];
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version>=7.0f){
        tableView.frame = CGRectMake(10, 40, 300, self.view.frame.size.height-44-49-40);
    }

    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView release];
    
    hud = [[ATMHud alloc]initWithDelegate:self];
    [self.view addSubview:hud.view];
}


- (void)updatePassWord{
    if (newField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    [newField resignFirstResponder];
    
    NSString *newPwd = [newField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    dispatch_queue_t network;
    network = dispatch_queue_create("update_user_pwd", nil);
    dispatch_async(network, ^{
        NSString *request = [HTTPRequest requestForGetWithPramas:[NSDictionary dictionaryWithObjectsAndKeys:[IsLogIn instance].memberData.idString,@"user_id",newPwd,@"new_pwd", nil] method:@"update_user_pwd"];
        NSDictionary *json = [JsonUtil jsonToDic:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[json objectForKey:@"msg"]integerValue] == 1) {
                [hud setCaption:@"密码修改成功"];
                [hud setActivity:NO];
                hud.delegate = self;
                [hud show];
                [hud hideAfter:1.0f];
            }else
            {
                if ([json objectForKey:@"msgbox"] != NULL) {
                    [hud setCaption:[json objectForKey:@"msgbox"]];
                    [hud setActivity:NO];
                    hud.delegate = nil;
                    [hud show];
                    [hud hideAfter:1.0f];
                }else
                {
                    [hud setCaption:@"网络出问题了"];
                    [hud setActivity:NO];
                    hud.delegate = nil;
                    [hud show];
                    [hud hideAfter:1.0f];
                }
            }
        });
    });
}


- (void)hudWillDisappear:(ATMHud *)_hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[MemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhishi_kuang_bg"]];

    }
    
    if (indexPath.row == 0) {
        cell.title = @"新密码:";
//        newField = cell.contentField;
        newField.delegate = self;
        newField.frame = CGRectMake(110, 0, 190, 45);
        [cell addSubview:newField];
        newField.returnKeyType = UIReturnKeyDone;
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == newField) {
        [self updatePassWord];
    }
    return YES;
}


- (void)saveBtnAction:(UIButton *)button
{
    [self updatePassWord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
