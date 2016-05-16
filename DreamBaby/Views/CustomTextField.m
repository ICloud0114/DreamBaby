//
//  CustomTextField.m
//  GoodMom
//
//  Created by easaa on 13-7-26.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import "CustomTextField.h"


@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

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
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

//控制清除按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + bounds.size.width - 50, bounds.origin.y + bounds.size.height -20, 16, 16);
}

//控制placeHolder的位置，左右缩20
//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    
//    //return CGRectInset(bounds, 20, 0);
//    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);//更好理解些
//    return inset;
//}
//控制显示文本的位置
//-(CGRect)textRectForBounds:(CGRect)bounds
//{
//    //return CGRectInset(bounds, 50, 0);
//    CGRect inset = CGRectMake(bounds.origin.x+2, bounds.origin.y, bounds.size.width , bounds.size.height);//更好理解些
//    
//    return inset;
//}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x+2, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}
//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width-250, bounds.size.height);
    return inset;
    //return CGRectInset(bounds,50,0);
}

//控制placeHolder的颜色、字体
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    //CGContextRef context = UIGraphicsGetCurrentContext();
//    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    [[UIColor colorwithHexString:@"#B2AEB1"] setFill];
//    
//    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:14]];
//}

@end
