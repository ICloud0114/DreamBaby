//
//  LoginViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-3.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "findPassWordViewController.h"

#import <CoreLocation/CoreLocation.h>
@interface LoginViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    UITextField * userNameTextField;
    UITextField * secreatTextField;
    BOOL _isCheck;
    UIButton * checkBoxAuto;
    UITabBarController *mainTabBar;
}

@property (nonatomic, assign) BOOL isRegisterSuccess;  //表明是否注册成功
@property (nonatomic, copy) NSString *strRegisterUserName;
@property (nonatomic, copy) NSString *strRegisterUserPwd;

@end
