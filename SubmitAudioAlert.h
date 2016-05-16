//
//  SubmitAudioAlert.h
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubmitAudioAlert : UIView
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *conformBtn;
@property (retain, nonatomic) IBOutlet UIImageView *HUDImageView;
- (IBAction)ConforBtnPressed:(id)sender;
- (IBAction)CancelBtnPressed:(id)sender;

@end


