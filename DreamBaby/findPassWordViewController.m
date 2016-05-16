//
//  findPassWordViewController.m
//  梦想宝贝
//
//  Created by IOS001 on 14-4-22.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "findPassWordViewController.h"
#import "LoginViewController.h"
#import "pickTextField.h"
@interface findPassWordViewController ()
{
    NSString *mobile;
    NSMutableDictionary *dic;
    NSMutableData *Mdata;
}
@property (retain, nonatomic) IBOutlet UIView *textFView;

@property (retain, nonatomic) IBOutlet UITextField *textF1;
@property (retain, nonatomic) IBOutlet UITextField *textF2;
@property (retain, nonatomic) IBOutlet UITextField *textF3;
- (IBAction)pressBtn:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UITextField *userName;

@end

@implementation findPassWordViewController

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
    dic=[[NSMutableDictionary alloc]init];
    [dic setDictionary:[NSMutableDictionary dictionaryWithContentsOfFile:[self dataFilePath:@"dataPath"]]];
    Mdata=[[[NSMutableData alloc]init]retain];
    self.title=@"找回密码";
//    dic=[NSMutableDictionary dictionaryWithDictionary:]
//    dic=[NSMutableDictionary dictionaryWithContentsOfFile:[self dataFilePath:@"dataPath"]];
//    NSLog(@"dic==%@",dic);
    
//    mobile=[dic objectForKey:@"userName"];
    
//    NSLog(@"mobile==%@",mobile);
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss)];
    [self.view addGestureRecognizer:tap];
    self.textF1.delegate=self;
    self.textF2.delegate=self;
    self.textF3.delegate=self;
    self.userName.delegate=self;
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.textF2||textField==self.textF3) {
//        [UIView animateWithDuration:0.3 animations:^{
            self.textFView.frame=CGRectMake(self.textFView.frame.origin.x, self.textFView.frame.origin.y-80, self.textFView.frame.size.width, self.textFView.frame.size.height);
//    }];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==self.textF2||textField==self.textF3) {
//        [UIView animateWithDuration:0.3 animations:^{
            self.textFView.frame=CGRectMake(self.textFView.frame.origin.x, self.textFView.frame.origin.y+80, self.textFView.frame.size.width, self.textFView.frame.size.height);
//        }];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardDismiss{
    [self.textF1 resignFirstResponder];
    [self.textF2 resignFirstResponder];
    [self.textF3 resignFirstResponder];
    [self.userName resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_textF1 release];
    [_textF2 release];
    [_textF3 release];
    [_userName release];
    [_textFView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextF1:nil];
    [self setTextF2:nil];
    [self setTextF3:nil];
    [self setUserName:nil];
    [self setTextFView:nil];
    [super viewDidUnload];
}
- (IBAction)pressBtn:(UIButton *)sender {
    if (sender.tag==1) {
//        SignupViewController *si=[[SignupViewController alloc]init];
//        [si getPhoneCheck:mobile andBtn:sender];
//        [si release];
        [self getCheckCodeAction:sender];
     }
    else if (sender.tag==2){

//        [dic setObject:self.textF1.text forKey:@"password"];
        dic=[NSMutableDictionary dictionaryWithContentsOfFile:[self dataFilePath:@"dataPath"]];
//        SignupViewController *sign=[[SignupViewController alloc]init];
//        [sign requestForSignUpwithPass:self.textF1.text andRight:self.textF2.text];
//        [sign release];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.userName.text,@"user_name",self.textF1.text,@"old_password" ,self.textF2.text,@"new_password",self.textF3.text,@"verified_code",nil];
            NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"find_passowrd"];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
            NSLog(@"%@", dictionary);
//            NSLog(@"mobile111==%@",mobile);
           NSNumber *a=(NSNumber *)[dictionary objectForKey:@"msg"];
            int i=a.intValue;
//            NSString *str=(NSString *)[dictionary objectForKey:@"msgbox"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (1==i) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"修改成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    alert.tag=1;
                    [alert show];
                    [alert release];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"修改失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            });
            
        });

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//获取存储路径
-(NSString *)dataFilePath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:path];
}
- (void)getCheckCodeAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    mobile=self.userName.text;
    void (^changeStatus)(void) = ^(void){
        sender.enabled = NO;
        __block int timerout = 60.f;//60秒后重新获取验证码
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timerSource, dispatch_walltime(NULL, 0), 1.f*NSEC_PER_SEC, 0);//每秒执行
        dispatch_source_set_event_handler(timerSource, ^{
            if (timerout <= 0)
            {//倒计时结束
                dispatch_source_cancel(timerSource);
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                        sender.enabled = YES;
                    });
                });
            } else
            {
                @autoreleasepool {
                    NSString *strTime = [NSString stringWithFormat:@"%d秒后获取", timerout];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [sender setTitle:strTime forState:UIControlStateNormal];
                    });
                }
                --timerout;
            }
        });
        dispatch_source_set_cancel_handler(timerSource, ^{
            dispatch_release(timerSource);
        });
        dispatch_resume(timerSource);
    };
    
    //&&[self isMobileNumber:mobile]
    if (!(mobile != nil &&
          mobile.length > 0 ))
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"手机号码有误!" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    } else
    {
        changeStatus();
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: mobile,@"user_name", nil];
            NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"get_verified_code_by_name"];
            NSDictionary *dictionary = [JsonUtil jsonToDic:request];
            NSLog(@"%@", dictionary);
            NSLog(@"mobile111==%@",mobile);
        });
//        NSURL *url=[NSURL URLWithString:@"http://192.168.0.155:8004/api/GetFetationInfo.ashx"];
//        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
//        [request setHTTPMethod:@"post"];
//        NSString *str=[NSString stringWithFormat:@"%@",mobile];
//        NSData *mydata=[str dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:mydata];
//       [NSURLConnection connectionWithRequest:request delegate:self];
    }
}
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    NSLog(@"管道建立成功");
//    Mdata.length=0;
//}
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    [Mdata appendData:data];
//}
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:Mdata options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"dic==%@",dic);
//}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"管道建立失败");
}
//sendsms
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
@end
