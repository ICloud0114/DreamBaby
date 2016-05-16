//
//  SubmitAudioAlert.m
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "SubmitAudioAlert.h"

@implementation SubmitAudioAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd  hh:mm:ss";
    self.dateLabel.text = [formatter stringFromDate:[NSDate date]];
    [formatter release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)dealloc {
    [_dateLabel release];
    [_cancelBtn release];
    [_conformBtn release];
    [_HUDImageView release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}
- (IBAction)ConforBtnPressed:(id)sender {
    [UIView animateWithDuration:0.6 animations:^{
        [self setTransform:(CGAffineTransformMakeScale(0.1,0.1))];
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UPLOADRECORD" object:nil];
    }];

}

- (IBAction)CancelBtnPressed:(id)sender {
    [UIView animateWithDuration:0.6 animations:^{
        [self setTransform:(CGAffineTransformMakeScale(0.1,0.1))];
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
