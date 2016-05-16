//
//  SignupViewController.h
//  DreamBaby
//
//  Created by easaa on 14-2-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivacyViewController.h"
@interface SignupViewController : UIViewController
{
    dispatch_source_t timerSource;
}

@property (nonatomic ,retain) NSString *Id;
- (void)requestForSignUpwithPass:(NSString *)pass andRight:(NSString *)right;
@end
