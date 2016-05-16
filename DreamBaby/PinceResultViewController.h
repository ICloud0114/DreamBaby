//
//  PinceResultViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

//评测结果

#import <UIKit/UIKit.h>


@interface PinceResultViewController : UIViewController

@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger result;
@property (nonatomic ,retain)NSString *standardWeight;
@property (nonatomic ,retain)NSString *fatPoint;
@property (nonatomic ,retain)NSString *BMI;
@property (nonatomic ,retain)NSString *dreamWeight;
@end
