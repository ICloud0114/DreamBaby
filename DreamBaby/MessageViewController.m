//
//  MessageViewController.m
//  梦想宝贝
//
//  Created by IOS001 on 14-4-23.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MessageViewController.h"
#import "pickTextField.h"
#import "messageTextView.h"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    pickTextField *nameField;
    pickTextField *cellFidld;
//    UITextView *detailVeiw;
    messageTextView *detailVeiw;
}
@property (retain, nonatomic) IBOutlet UITableView *message;

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        self.message.frame=CGRectMake(self.message.frame.origin.x, self.message.frame.origin.y-120, self.message.frame.size.width, self.message.frame.size.height);
    }];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.2 animations:^{
        self.message.frame=CGRectMake(self.message.frame.origin.x, self.message.frame.origin.y+120, self.message.frame.size.width, self.message.frame.size.height);
    }];
    return YES;
}
//-(void)keyboardWillShow:(NSNotification *)notification{
//
//}
//-(void)keyboardWillHide:(NSNotification *)notification{
//
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isUp = NO;
    nameField.delegate=self;
    cellFidld.delegate=self;
    detailVeiw.delegate=self;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    self.title=@"留言";
    
//    self.tabBarController.tabBar.hidden=YES;
    self.message.backgroundColor=[UIColor clearColor];
    self.message.backgroundView=Nil;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    //#d470a8
    if(version<7.0f){
        self.message.separatorColor = [UIColor colorwithHexString:@"#d470a8"];
        //        tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.message.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}
-(void)tap{
    [nameField resignFirstResponder];
    [cellFidld resignFirstResponder];
    [detailVeiw resignFirstResponder];
    
}
-(void)textViewDidChange:(UITextView *)textView{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 45;
    }else if (indexPath.section==1){
        return 45;
    }else if (indexPath.section==2){
        return 150;
    }else{
        return 45;
    }
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"1"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"] autorelease];
            cell.backgroundColor=[UIColor whiteColor];
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 35)];
            nameLabel.textColor=[UIColor colorwithHexString:@"#d470a8"];
            
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.text=@"  姓名：";
            
            nameField=[[pickTextField alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+65, 6, 250, 35)];
            nameField.delegate=self;
            nameField.placeholder=@"填写真实姓名";
            
            [cell addSubview:nameField];
            [cell addSubview:nameLabel];
            [nameLabel release];
            [nameField release];
        }
        return cell;
    }
    else if(indexPath.section==1){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"2"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2"] autorelease];
            cell.backgroundColor=[UIColor whiteColor];
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 110, 35)];
            nameLabel.backgroundColor=[UIColor clearColor];
            nameLabel.textColor=[UIColor colorwithHexString:@"#d470a8"];
            nameLabel.text=@"  联系方式：";
        
            cellFidld=[[pickTextField alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+95, 6, 250, 35)];
            
            cellFidld.delegate=self;
            cellFidld.keyboardType=UIKeyboardTypeNumberPad;
            cellFidld.placeholder=@"输入手机号码";
            [cell addSubview:cellFidld];
            [cell addSubview:nameLabel];
            [nameLabel release];
            [cellFidld release];
        }
        return cell;
    }
    else if(indexPath.section==2){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"3"];
        if (!cell) {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"3"] autorelease];
            cell.backgroundColor=[UIColor whiteColor];
//            detailVeiw=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width-10, 140)];
            detailVeiw=[[messageTextView alloc]initWithFrame:CGRectMake(5, 5, cell.frame.size.width-10, 140)];
            detailVeiw.backgroundColor=[UIColor clearColor];
//            detailVeiw.text=@"咨询内容....";
            detailVeiw.font=[UIFont boldSystemFontOfSize:15];
            
            detailVeiw.delegate=self;
            detailVeiw.showsHorizontalScrollIndicator=NO;
            detailVeiw.showsVerticalScrollIndicator=NO;
            [cell addSubview:detailVeiw];
            [detailVeiw release];
            
        }
        return cell;
    }
    else if (indexPath.section==3){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"4"];
        if (!cell)
        {
            UIView *bV=[[[UIView alloc]init]autorelease];
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"4"]autorelease];
            cell.backgroundView=bV;
            cell.backgroundColor=[UIColor clearColor];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(30, 10, 260, 35);
            [btn setBackgroundImage:[UIImage imageNamed:@"tongyong_btn_h"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"tongyong_btn_h"] forState:UIControlStateSelected];
            [btn setTitle:@"提交" forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            
        }
        return cell;
    }
    return Nil;
}
-(void)update:(UIButton *)btn{
    if (nameField.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请输入姓名" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (cellFidld.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请输入联系方式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (detailVeiw.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"请输入内容" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (isUp == NO) {
        isUp = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.ID,@"expert_id",nameField.text,@"messager",cellFidld.text,@"phone",detailVeiw.text,@"mesage_content",nil];
        NSString *request = [HTTPRequest requestForGetWithPramas:dict method:@"leave_message"];
        NSDictionary *dictionary = [JsonUtil jsonToDic:request];
        NSLog(@"dic==%@",dictionary);
        NSNumber *a=(NSNumber *)[dictionary objectForKey:@"msg"];
        int i=a.intValue;
        //            NSString *str=(NSString *)[dictionary objectForKey:@"msgbox"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (1==i) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"留言成功" delegate:self cancelButtonTitle:Nil otherButtonTitles:@"确认", nil];
                alert.tag=1;
                [alert show];
                [alert release];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Nil message:@"留言失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                isUp = NO;
            }
        });

    });
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_message release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMessage:nil];
    [super viewDidUnload];
}
@end
