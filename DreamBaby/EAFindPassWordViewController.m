//
//  EAFindPassWordViewController.m
//  梦想宝贝
//
//  Created by easaa on 7/4/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAFindPassWordViewController.h"

@interface EAFindPassWordViewController ()<UIAlertViewDelegate>
{
    UIView *submitName;
}
@property (retain, nonatomic) IBOutlet UITextField *username;

- (IBAction)submitAction:(id)sender;

- (IBAction)receiveByPhone:(id)sender;
- (IBAction)receiveByEmail:(id)sender;

@end

@implementation EAFindPassWordViewController

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
//    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"忘记密码";
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
    
    submitName = [[NSBundle mainBundle]loadNibNamed:@"EASubmitUsername" owner:self options:nil][0];


    [self.view addSubview:submitName];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}


- (void)hideKeyBoard:(id)sender
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {


    [_username release];
    [super dealloc];
}
- (void)viewDidUnload {


    [self setUsername:nil];
    [super viewDidUnload];
}


- (IBAction)submitAction:(id)sender
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.username.text,@"user_name",nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"authenticate_username"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"%@", dictionary);
        //            NSLog(@"mobile111==%@",mobile);
        NSNumber *a=(NSNumber *)[dictionary objectForKey:@"msg"];
        int i=a.intValue;
        //            NSString *str=(NSString *)[dictionary objectForKey:@"msgbox"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (1==i) {
                [submitName setHidden:YES];
                UIView *selectView = [[NSBundle mainBundle]loadNibNamed:@"EASelectReceiveTypeView" owner:self options:nil][0];
                
                [self.view addSubview:selectView];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"用户名不正确，请重新输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        });
        
    });
    

}

- (IBAction)receiveByPhone:(id)sender
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.username.text,@"user_name",[NSNumber numberWithInt:0],@"type",nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"find_password"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"%@", dictionary);
        //            NSLog(@"mobile111==%@",mobile);
        NSNumber *a=(NSNumber *)[dictionary objectForKey:@"msg"];
        int i=a.intValue;
        //            NSString *str=(NSString *)[dictionary objectForKey:@"msgbox"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (1==i) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"您的密码已经发到您的手机，请注意查收" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert setTag:1991];
                [alert show];
                [alert release];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"服务器繁忙，请稍后重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        });
        
    });

    
}

- (IBAction)receiveByEmail:(id)sender
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.username.text,@"user_name",[NSNumber numberWithInt:1],@"type",nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"find_password"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"%@", dictionary);
        //            NSLog(@"mobile111==%@",mobile);
        NSNumber *a=(NSNumber *)[dictionary objectForKey:@"msg"];
        int i=a.intValue;
        //            NSString *str=(NSString *)[dictionary objectForKey:@"msgbox"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (1==i) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"您的密码已经发送到您的注册邮箱，请注意查收" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                [alert setTag:1991];
                            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"服务器繁忙，请稍后重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        });
        
    });

}

#pragma mark alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1991)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

@end
