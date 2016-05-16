//
//  LoginView.h
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface LoginView : UIView<UITextFieldDelegate>
{
    CustomTextField * userNameTextField;
    CustomTextField * secreatTextField;
    BOOL _isCheck;
}
@property (retain, nonatomic) UIButton *dengluBtn;
@property (retain, nonatomic) UIButton *zhuceBtn;
@end
