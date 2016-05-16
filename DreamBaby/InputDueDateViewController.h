//
//  InputDueDateViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InputDueDateViewController : UIViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITabBarControllerDelegate>
{
    UIView * viewBG;//背景视图
//    UIImageView * leftView;//左选项卡视图
//    UIImageView * rightView;//右边选项卡视图
    
    UIButton *timeBtn;  //末次月经时间
    UIButton *timeBtn2; //预产期
    UIButton *menstrualDayBtn; //月经周期
    
    UIButton *nextBtn;//下一步按钮
    
    
    UIDatePicker *datePicker;
    NSDate* putDate;
    NSDate *putDate2;
    UIPickerView *picker;
    NSMutableArray* pickArr;
    int currentIndex;
    
    NSDate * flagDate;//记录末次月经时间，当点击确定后保存到userDefaults里面
    int flagDays;//记录选中的月经周期

    UITabBarController *mainTabBar;
}

@end
