//
//  customTextView.m
//  梦想宝贝
//
//  Created by IOS001 on 14-5-23.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "customTextView.h"

@implementation customTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//keybroad添加取消钮
-(UIView*)inputAccessoryView
{
    UIToolbar* inputAccessoryView = [[UIToolbar alloc] init];
    inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
    inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [inputAccessoryView sizeToFit];
    CGRect frame = inputAccessoryView.frame;
    frame.size.height = 30.0f;
    inputAccessoryView.frame = frame;
    UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
    [inputAccessoryView setItems:array];
    [flexibleSpaceLeft release];
    [doneBtn release];
    return [inputAccessoryView autorelease];
}
-(void)done:(id)sender
{
    [self resignFirstResponder];
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subview;
            [btn setEnabled:YES];
        }
    }
}

@end
