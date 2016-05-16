//
//  MemberRegController.h
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface MemberRegController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    CustomTextField *nichengText;
    CustomTextField *mimaText;
    CustomTextField *sfzText;
    CustomTextField *hujiText;

    UITableView *memberTable;
    UIImageView * iconIV;
    
    UIButton * arrow1Btn;//省
    UIButton * arrow2Btn;//市
    UIButton * arrow3Btn;//县
    
    UIButton * yanZhengBtn;//获取验证码
    
    CustomTextField *phoneText;
    CustomTextField *yanZhengText;
}

@end
