//
//  ModifypwdViewController.m
//  ReporterClient
//
//  Created by easaa on 4/29/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "ModifypwdViewController.h"
#import "LoginViewController.h"

//#import "MemberEntiy.h"
#import "IsLogIn.h"

@interface ModifypwdViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
//     CustomNavigation *myNavigationBar;
     UITextField *oldTextField;
     UITextField *newTextField;
     UITextField *checkTextField;
}
@end

@implementation ModifypwdViewController

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
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"修改密码";
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
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

    
	// Do any additional setup after loading the view.
    
//    [self.view setBackgroundColor:BGCOLOR];
    UIView *mainView = [[UIView alloc]init];
//    mainView.backgroundColor = BGCOLOR;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        mainView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height -20);
    }
    else
    {
        mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
    }
    [self.view addSubview:mainView];
//    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    myNavigationBar.titleLabel.text = @"修改密码";
//    myNavigationBar.leftButton.hidden = NO;
//    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [mainView addSubview:myNavigationBar];
    
    UIImageView *firstLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 70, 280,35)];
    [mainView addSubview:firstLine];
    [firstLine setImage:[UIImage imageNamed:@"huiyuanzhongxing"]];
    
    UIImageView *secondLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 115, 280, 35)];
    [secondLine setImage:[UIImage imageNamed:@"huiyuanzhongxing"]];
    UIImageView *thirdLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 160, 280, 35)];
    [thirdLine setImage:[UIImage imageNamed:@"huiyuanzhongxing"]];
    [mainView addSubview:secondLine];
    [mainView addSubview:thirdLine];
    
    UILabel *oldPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 70, 60, 35)];
    UILabel *newPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 115, 60, 35)];
    UILabel *checkPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 160, 75, 35)];
    
    [oldPasswordLabel setBackgroundColor:[UIColor clearColor]];
    [newPasswordLabel setBackgroundColor:[UIColor clearColor]];
    [checkPasswordLabel setBackgroundColor:[UIColor clearColor]];
    
    [mainView addSubview:oldPasswordLabel];
    [mainView addSubview:newPasswordLabel];
    [mainView addSubview:checkPasswordLabel];
    
    [oldPasswordLabel setText:@"旧密码："];
    [newPasswordLabel setText:@"新密码："];
    [checkPasswordLabel setText:@"确认密码："];
    
    [oldPasswordLabel setFont:[UIFont systemFontOfSize:14]];
    [newPasswordLabel setFont:[UIFont systemFontOfSize:14]];
    [checkPasswordLabel setFont:[UIFont systemFontOfSize:14]];
    
    oldTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 70, 165, 35)];
    newTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 115, 165, 35)];
    checkTextField = [[UITextField alloc]initWithFrame:CGRectMake(130, 160, 165, 35)];
    [mainView addSubview:oldTextField];
    [mainView addSubview:newTextField];
    [mainView addSubview:checkTextField];
    
    oldTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    checkTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    oldTextField.backgroundColor = [UIColor clearColor];
    newTextField.backgroundColor = [UIColor clearColor];
    checkTextField.backgroundColor = [UIColor clearColor];
    
    oldTextField.secureTextEntry = YES;
    newTextField.secureTextEntry = YES;
    checkTextField.secureTextEntry = YES;
    
    oldTextField.delegate = self;
    newTextField.delegate = self;
    checkTextField.delegate = self;
    
    oldTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    checkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    oldTextField.clearsOnBeginEditing = YES;
    newTextField.clearsOnBeginEditing = YES;
    checkTextField.clearsOnBeginEditing = YES;
    
    [oldTextField setFont:[UIFont systemFontOfSize:14]];
    [newTextField setFont:[UIFont systemFontOfSize:14]];
    [checkTextField setFont:[UIFont systemFontOfSize:14]];
    
    oldTextField.placeholder = @"请输入当前密码";
    newTextField.placeholder = @"请输入新密码（6-12位）";
    checkTextField.placeholder = @"请再次输入密码";
    
    
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setFrame:CGRectMake(20, 260, 280, 30)];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"] forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateHighlighted];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitUpdatePassword) forControlEvents:UIControlEventTouchUpInside];
    
    [mainView addSubview:commitButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
}

- (void)commitUpdatePassword
{
    

    MemberEntiy *member = [IsLogIn instance].memberData;

    if(![newTextField.text isEqualToString: checkTextField.text])
    {

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"您两次输入的密码不一致，请重新输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if(newTextField.text.length < 6 || newTextField.text.length > 12)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"请输入6-12位密码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: member.idString,@"user_id",oldTextField.text,@"old_pwd",newTextField.text,@"new_pwd",nil];
            NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"modified_password"];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
            NSLog(@"%@", dictionary);
            //            NSLog(@"mobile111==%@",mobile);
            NSNumber *a=(NSNumber *)[dictionary objectForKey:@"msg"];
            int i=a.intValue;
            //            NSString *str=(NSString *)[dictionary objectForKey:@"msgbox"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (1==i) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:[dictionary objectForKey:@"msgbox"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];

                    [alert setTag:1991];
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:[dictionary objectForKey:@"msgbox"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];


                }
            });
            
        });
        
        
        
    }
    
}

- (void)tapGesture:(id)sender
{
    [self.view endEditing:YES];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == newTextField)
    {
        if(oldTextField.text.length < 6 || oldTextField.text.length > 12)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"请输入6-12位密码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
   else if (textField == checkTextField)
    {
        if(newTextField.text.length < 6 || newTextField.text.length > 12)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"请输入6-12位密码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == checkTextField)
    {
        
    }
    
    
    return YES;
}

#pragma mark alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1991)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
