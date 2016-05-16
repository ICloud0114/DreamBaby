//
//  tipAlertView.m
//  EasyOrderCreate
//
//  Created by easaa on 13-12-3.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import "tipAlertView.h"
#import "UIColor+ColorUtil.h" 


@interface tipAlertView ()<UIGestureRecognizerDelegate>

@end
@implementation tipAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)hide
{
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.hidden = YES;
    
    [UIView commitAnimations];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.popBG.layer.cornerRadius=3;
    self.popBG.layer.borderWidth = 1.0;
    self.popBG.layer.borderColor = [[UIColor colorwithHexString:@"#737373"] CGColor];
    //self.popBG.layer.shadowColor=[UIColor colorwithHexString:@"#FFFFFF"].CGColor;
    self.popBG.layer.shadowOffset=CGSizeMake(2, 2);
    self.popBG.layer.shadowOpacity=0.5;
    self.popBG.layer.shadowRadius=3;
    
    self.popBG.backgroundColor=[UIColor colorwithHexString:@"#d1cdcd"];
    
//    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"gray_h"] forState:UIControlStateHighlighted];
//    [_submitBtn setTitleColor:[UIColor colorwithHexString:@"6B9E35"] forState:UIControlStateNormal];


}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [_popBG release];
   
    [_submitPhotoBtn release];
    [_submitAudioBtn release];
    [super dealloc];
}
//- (IBAction)submitAction:(id)sender {
//    [self removeFromSuperview];
//}

@end
