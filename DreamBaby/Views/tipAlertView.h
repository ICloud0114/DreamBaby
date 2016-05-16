//
//  tipAlertView.h
//  EasyOrderCreate
//
//  Created by easaa on 13-12-3.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tipAlertView : UIView<UIGestureRecognizerDelegate>

@property (retain, nonatomic) IBOutlet UIView *popBG;

//发表文字按钮

@property (retain, nonatomic) IBOutlet UIButton *submitPhotoBtn;
@property (retain, nonatomic) IBOutlet UIButton *submitAudioBtn;


@end
