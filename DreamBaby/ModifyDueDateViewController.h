//
//  ModifyDueDateViewController.h
//  GoodMom
//
//  Created by easaa on 13-7-26.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

//修改预产期

#import <UIKit/UIKit.h>


@interface ModifyDueDateViewController : UIViewController<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *headView;
//    UIImageView *rightView;      //右边选项卡视图
//    UIImageView *leftView;       //左选项卡视图
    UIView *bgView;         //背景视图
    
    //视图背景
    UIView*  viewBG;
    UIButton *timeBtn;  //末次月经时间
    UIButton *timeBtn2; //预产期
    UIButton *menstrualDayBtn; //月经周期
    UIDatePicker *datePicker;
    NSDate* putDate;
    NSDate *putDate2;
    UIPickerView *picker;
    NSMutableArray* pickArr;
    int currentIndex;
    
    NSMutableString * flagProductionDate;
    NSDate * flagDate;//记录末次月经时间，当点击确定后保存到userDefaults里面
    int flagDays;//记录选中的月经周期
    NSDate *flagYesterDay;  //记录
}
@end
