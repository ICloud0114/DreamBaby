//
//  GovermentAnounceViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//


//政府公告

#import <UIKit/UIKit.h>

@interface GovermentAnounceViewController : UIViewController<UIWebViewDelegate>
{
    UIScrollView * contentScrollerView;
    
    NSString * flageType;
}

@property (nonatomic ,retain) UIView *bgView;
@property (nonatomic ,copy) NSString *Id;

@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@end
