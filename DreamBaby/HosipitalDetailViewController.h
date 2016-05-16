//
//  HosipitalDetailViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HosipitalDetailViewController : UIViewController
{
    UIScrollView * contentScrollerView;
    UILabel *titleLabel;
}
@property (nonatomic ,retain) UIView *bgView;
@property (nonatomic ,copy) NSString *Id;
@end
