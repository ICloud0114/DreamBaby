//
//  ZZReplyView.m
//  ZZDaheNewspaperIPhone
//
//  Created by wangshaosheng on 13-5-29.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import "ZZReplyView.h"
#import "UIColor+ColorUtil.h"

@implementation ZZReplyView

-(void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, 49)];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
        [_bgView setBackgroundColor:[UIColor colorwithHexString:@"#DD2E94"]];
        [self addSubview:_bgView];
        [_bgView release];
        
        
//        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
//        [self addSubview:_backgroundImageView];
//        [_backgroundImageView release];
//        [_backgroundImageView setImage:[UIImage imageNamed:@"mama_jiaoliukuang"]];
//        
////        _replyTextFieldBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 5, 212, 31)];
////        [_replyTextFieldBackgroundImageView setImage:[UIImage imageNamed:@"jiaoliu_shurukuang"]];
//        [self addSubview:_replyTextFieldBackgroundImageView];
//        [_replyTextFieldBackgroundImageView release];
//        
       
//        _replyTextField = [[UITextField  alloc]initWithFrame:CGRectMake(50, 15, 185, 30)];
//        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//        {
//            _replyTextField = [[UITextField  alloc]initWithFrame:CGRectMake(50, 10, 185, 30)];
//        }
//        [self addSubview:_replyTextField];
//        [_replyTextField release];
////        [_replyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//        [_replyTextField setFont:[UIFont systemFontOfSize:12]];
//        [_replyTextField setPlaceholder:@"请输入您想说的话"];
//        [_replyTextField setReturnKeyType:UIReturnKeySend];
        
        _replyTextView = [[UITextView  alloc]initWithFrame:CGRectMake(50, 12, 185, 23)];
        _replyTextView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        {
            [_replyTextView setFrame:CGRectMake(50, 10, 185, 31)];
            _replyTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }

        _replyTextView.backgroundColor = [UIColor whiteColor];
//        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
//        {
//            _replyTextView = [[UITextView  alloc]initWithFrame:CGRectMake(50, 10, 185, 23)];
//        }
        
        
        _replyTextView.text = @"请输入您想说的话";
        [self addSubview:_replyTextView];
        [_replyTextView release];
        //        [_replyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_replyTextView setFont:[UIFont systemFontOfSize:12]];

        [_replyTextView setReturnKeyType:UIReturnKeySend];
        
//        //底下的竖线
//        UIImageView * bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(260, 0, 2, 40)];
//        bottomLine.image = [UIImage imageNamed:@"pinglun_bottom_line"];
//        [self addSubview:bottomLine];
//        [bottomLine release];
//        _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(230, 5, 30, 30)];
//        [self addSubview:_shareButton];
//        [_shareButton release];
        //[_shareButton setBackgroundImage:[UIImage imageNamed:@"more_zhuce@.png"] forState:UIControlStateNormal];
        //[_shareButton setBackgroundImage:[UIImage imageNamed:@"more_zhuce_h@.png"] forState:UIControlStateHighlighted];
        
        _leftIcon = [[UIImageView alloc]initWithFrame:CGRectMake(14, 10, 22, 22)];
        _leftIcon.center = CGPointMake(_leftIcon.center.x, _replyTextView.center.y);
        _leftIcon.image = [UIImage imageNamed:@"mama_xietie"];
        [self addSubview:_leftIcon];
        [_leftIcon release];
        
        _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(242, 14, 24, 18)];
        _imageButton.center = CGPointMake(_imageButton.center.x, _replyTextView.center.y);
        [self addSubview:_imageButton];
        [_imageButton release];
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"mama_xiangji01"] forState:UIControlStateNormal];
//        [_imageButton setBackgroundImage:[UIImage imageNamed:@"mama_xiangji01"] forState:UIControlStateHighlighted];
        [_imageButton addTarget:self action:@selector(showAddPhotoView:) forControlEvents:UIControlEventTouchUpInside];
        
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(280, 10, 25, 24)];
        _sendButton.center = CGPointMake(_sendButton.center.x, _replyTextView.center.y);
        [self addSubview:_sendButton];
        [_sendButton release];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"mama_lest"] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(hidePhotoView) forControlEvents:UIControlEventTouchUpInside];
//        [_markButton setBackgroundImage:[UIImage imageNamed:@"mama_lest"] forState:UIControlStateHighlighted];
//        [_markButton setTitleColor:[UIColor colorwithHexString:@"#5a3b3b"]  forState:UIControlStateNormal];
//        [_markButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
//        [_markButton setTitle:@"发表" forState:UIControlStateNormal];
        _sendButton.titleLabel.font= [UIFont systemFontOfSize:13];
        
        _photoBackgroundImageView = [[UIImageView alloc]init];
        [self addSubview:_photoBackgroundImageView];
        [_photoBackgroundImageView release];
        [_photoBackgroundImageView setImage:[UIImage imageNamed:@"riji6"]];
        [_photoBackgroundImageView setHidden:YES];
        [_photoBackgroundImageView setUserInteractionEnabled:YES];
        
        _addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 4, 37, 37)];
        [_photoBackgroundImageView addSubview:_addPhotoButton];
        [_addPhotoButton release];
        [_addPhotoButton setBackgroundImage:[UIImage imageNamed:@"riji2"] forState:UIControlStateNormal];
//        [_addPhotoButton setBackgroundImage:[UIImage imageNamed:@"riji2"] forState:UIControlStateHighlighted];
    }
    return self;
}


-(void)hidePhotoView
{
    [self.replyTextView resignFirstResponder];
    
    if (_photoBackgroundImageView.hidden)
    {
        [self setFrame:CGRectMake(self.frame.origin.x, self.superview.frame.size.height - self.frame.size.height, 320, self.frame.size.height)];
    }
    else
    {
        [self setFrame:CGRectMake(self.frame.origin.x, self.superview.frame.size.height - self.frame.size.height + 79, 320, self.frame.size.height - 79)];
    }
    
    
    [_photoBackgroundImageView setHidden:YES];

}

- (void)setPhotoImage:(UIImage *)photoImage
{
    [photoImage retain];
    [_photoImage release];
    _photoImage = photoImage;
    if (_photoImage == nil)
    {
        [self.addPhotoButton setBackgroundImage:[UIImage imageNamed:@"riji2"] forState:UIControlStateNormal];
    }
    else
    {
        [self.addPhotoButton setBackgroundImage:photoImage forState:UIControlStateNormal];
    }
    
    
}

- (id)initWithFrame:(CGRect)frame withReplyType:(ZZReplayViewType )type
{
    self = [self initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        switch (type)
        {
            case 1:
            {
                [_shareButton setHidden:NO];
                [_sendButton setHidden:NO];
//                [_replyTextFieldBackgroundImageView setImage:[UIImage imageNamed:@"pinglun_et@2x.png"]];
//                [_replyTextFieldBackgroundImageView setFrame:CGRectMake(45, 15, 212, 31)];
//                [_replyTextField setFrame:CGRectMake(50, 10, 185, 30)];
            }
                break;
                
            default:
                break;
        }
        
        
        
        
    }
    return self;
}

- (void) showAddPhotoView:(UIButton *)senderButton
{
    [_photoBackgroundImageView setHidden:!_photoBackgroundImageView.hidden];
    if (_photoBackgroundImageView.hidden)
    {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + 79, 320, self.frame.size.height - 79)];

    }
    else
    {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - 79, 320, self.frame.size.height + 79)];
        
        [_photoBackgroundImageView setFrame:CGRectMake(20, _bgView.frame.origin.y + _bgView.frame.size.height + 10, 280, 46)];
        
        [self.addPhotoButton setBackgroundImage:[UIImage imageNamed:@"riji2"] forState:UIControlStateNormal];

    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
