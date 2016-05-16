//
//  pickTextField.m
//  梦想宝贝
//
//  Created by IOS001 on 14-4-24.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "pickTextField.h"

@implementation pickTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)drawPlaceholderInRect:(CGRect)rect{
    [[UIColor colorwithHexString:@"#d470a8"] setFill];
    [self.placeholder drawInRect:rect withFont:[UIFont systemFontOfSize:17]];
}
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y+5, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
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
