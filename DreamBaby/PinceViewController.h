//
//  PinceViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"


@interface PinceViewController : UIViewController<UITextFieldDelegate>
{
    UIImageView *viewBG;//背景视图
    UIView *leftView;//左选项卡视图
    UIView *rightView;//右边选项卡视图
    
    //左边选项卡按钮
    UIButton *leftBtn;
    
    //左边选项卡按钮
    UIButton *rightBtn;
    
    CustomTextField *shenGaoText;
    CustomTextField *tizhongText;
    CustomTextField *daysText;
    CustomTextField *tizhong2Text;
    CustomTextField *broadText;
    
    UIButton * conformBtn;
    UIButton * historyBtn;

}

@end
