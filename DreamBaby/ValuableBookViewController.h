//
//  ValuableBookViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoveTipsViewController.h"
//育儿宝典

@interface ValuableBookViewController : UIViewController
{
     UIView * viewBG;//背景视图
    
    //每日知识
    UIButton *dayBtn;
    
    //胎教音乐
    UIButton *taiJiaoBtn;
    
    //育儿故事
    UIButton *yuerBtn;
    
    //评测
    UIButton *pinceBtn;
    
    UIButton *loveBtn;
}

@end
