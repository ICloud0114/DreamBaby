//
//  ActivityPlageView.h
//  梦想宝贝
//
//  Created by IOS001 on 14-5-24.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityPlageView : UIView
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *playActivity;
@property (retain, nonatomic) IBOutlet UIView *contentView;
-(void)waitingTime:(NSTimeInterval)waitTime;
@end
