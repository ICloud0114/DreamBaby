//
//  LoginView.m
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "LoginView.h"

#import "InputDueDateViewController.h"

@implementation LoginView
@synthesize dengluBtn,zhuceBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //视图一，两个输入框和两个按钮
        UIView * view01 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        [self addSubview:view01];
        [view01 release];
        
        UIImageView * shuruBG = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 280, 120)];
        shuruBG.userInteractionEnabled = YES;
        shuruBG.image = [UIImage imageNamed:@"denglu_shurukuang_bg"];
        [view01 addSubview:shuruBG];
        [shuruBG release];
        
        
        
        //电邮地址
        UILabel *postAdressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 20)];
        postAdressLabel.text = @"用户名：";
        postAdressLabel.font = [UIFont boldSystemFontOfSize:14];
        postAdressLabel.backgroundColor = [UIColor clearColor];
        postAdressLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        postAdressLabel.textAlignment = NSTextAlignmentLeft;
        [shuruBG  addSubview:postAdressLabel];
        [postAdressLabel release];
        
        
        userNameTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(85, 15, 180, 35)];
        userNameTextField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu_shurukuang"]];
        userNameTextField.delegate = self;
        [userNameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        
        [shuruBG addSubview:userNameTextField];
        
        //密碼
        UILabel *secreatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 100, 20)];
        secreatLabel.text = @"密  碼:";
        secreatLabel.font = [UIFont boldSystemFontOfSize:14];
        secreatLabel.backgroundColor = [UIColor clearColor];
        secreatLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        secreatLabel.textAlignment = NSTextAlignmentLeft;
        [shuruBG addSubview:secreatLabel];
        [secreatLabel release];
        
        secreatTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(85, 73, 180, 35)];
        secreatTextField.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"denglu_shurukuang"]];
        secreatTextField.delegate = self;
        [secreatTextField setSecureTextEntry:YES];
        [secreatTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [shuruBG addSubview:secreatTextField];
        
        
        
        UIButton * checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [view01 addSubview:checkBox];
        checkBox.frame = CGRectMake(50, 155, 25, 25);
        [checkBox addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
        if (1) {
            _isCheck = YES;
            [checkBox setImage:[UIImage imageNamed:@"denglu_gouxuan_h"] forState:UIControlStateNormal];
            
        }else{
            _isCheck = NO;
            [checkBox setImage:[UIImage imageNamed:@"denglu_gouxuan"] forState:UIControlStateNormal];
        }
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(80, 160, 90, 20)];
        lable.font = [UIFont boldSystemFontOfSize:14];
        [view01 addSubview:lable];
        lable.text=@"记住密码";
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [lable release];
        
        UIButton * checkBoxAuto = [UIButton buttonWithType:UIButtonTypeCustom];
        [view01 addSubview:checkBoxAuto];
        checkBoxAuto.frame = CGRectMake(50+127, 155, 25, 25);
        [checkBoxAuto addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
        if (1) {
            _isCheck = YES;
            [checkBoxAuto setImage:[UIImage imageNamed:@"denglu_gouxuan_h"] forState:UIControlStateNormal];
            
        }else{
            _isCheck = NO;
            [checkBoxAuto setImage:[UIImage imageNamed:@"denglu_gouxuan"] forState:UIControlStateNormal];
        }
        UILabel *lableAuto = [[UILabel alloc] initWithFrame:CGRectMake(80+127, 160, 90, 20)];
        lableAuto.font = [UIFont boldSystemFontOfSize:14];
        [view01 addSubview:lableAuto];
        lableAuto.text=@"自动登录";
        lableAuto.backgroundColor = [UIColor clearColor];
        lableAuto.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [lableAuto release];
        
        
        
        
        //视图二，注册和登录按钮
        
        UIView * view02 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 80)];
        [self addSubview:view02];
        [view02 release];
        
        zhuceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        zhuceBtn.frame=CGRectMake(35, 10, 125, 45);
        [zhuceBtn setTitle:@"注  册" forState:UIControlStateNormal];
        zhuceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [zhuceBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [zhuceBtn setBackgroundImage:[UIImage imageNamed:@"zhuce_btn01"] forState:UIControlStateNormal];
        [zhuceBtn setBackgroundImage:[UIImage imageNamed:@"zhuce_btn01_h"] forState:UIControlStateHighlighted];
        //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        //[zhuceBtn addTarget:self action:@selector(zhucheAction) forControlEvents:UIControlEventTouchUpInside];
        [view02 addSubview:zhuceBtn];
        
        dengluBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        dengluBtn.frame=CGRectMake(160, 10, 125, 45);
        [dengluBtn setTitle:@"登  录" forState:UIControlStateNormal];
        dengluBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [dengluBtn setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateNormal];
        [dengluBtn setBackgroundImage:[UIImage imageNamed:@"denglu_btn02"] forState:UIControlStateNormal];
        [dengluBtn setBackgroundImage:[UIImage imageNamed:@"denglu_btn02_h"] forState:UIControlStateHighlighted];
        //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
        //[dengluBtn addTarget:self action:@selector(dengluAction) forControlEvents:UIControlEventTouchUpInside];
        [view02 addSubview:dengluBtn];
        
        
        //NSLog(@"----%f-----",[UIScreen mainScreen].bounds.size.height);
        if ([UIScreen mainScreen].bounds.size.height==568) {
            view01.frame = CGRectMake(0, 0+20, 320, 200);
            view02.frame = CGRectMake(0, 200+60, 320, 80);
        }
        
        
    }
    return self;
}
//- (void)check
//{
//    
//}
//- (void)zhucheAction
//{
//    
//}
//- (void)dengluAction
//{
//
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
