//
//  ZZReplyView.h
//  ZZDaheNewspaperIPhone
//
//  Created by wangshaosheng on 13-5-29.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
typedef NS_ENUM(NSInteger, ZZReplayViewType)
{
    ZZReplayViewTypeDefault = 0,
    ZZReplayViewTypeNoShare = 1,
};

@interface ZZReplyView : UIView
{

}

@property (nonatomic, retain)UIView *bgView;
@property (nonatomic, retain)UIImageView *backgroundImageView;
@property (nonatomic, retain)UIImageView *replyTextFieldBackgroundImageView;
//@property (nonatomic, retain)UITextField *replyTextField;
@property (nonatomic, retain)UITextView *replyTextView;
@property (nonatomic, retain)UIButton *shareButton;
@property (nonatomic, retain)UIButton *sendButton;
@property (nonatomic, retain)UIButton *imageButton;
@property (nonatomic, retain)UIImageView *leftIcon;
@property (nonatomic, retain)UIImageView *photoBackgroundImageView;
@property (nonatomic, retain)UIButton *addPhotoButton;
@property (nonatomic, retain)UIImage *photoImage;

- (id)initWithFrame:(CGRect)frame withReplyType:(ZZReplayViewType )type;

@end

