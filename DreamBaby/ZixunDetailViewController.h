//
//  ZixunDetailViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewController.h"
#import "NSString+HTML.h"
#import "ZZExpertCenterView.h"
//#import "ZZReplyView.h"
#import "HPGrowingTextView.h"
#import "IsLogIn.h"

@interface ZixunDetailViewController : UIViewController<UIWebViewDelegate, HPGrowingTextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView * contentScrollerView;
    UIWebView *contentWebView;
    UIView *listView;
    
//    ZZReplyView *replyView;
    NSMutableArray *commentMutableArray;
    BOOL isShowingImagePickerView;
    float replyViewFirstY;
    BOOL replyEditing;
    
    
    //replyView
    UIView *containerView;
    HPGrowingTextView *textView;
    UIButton *doneBtn;
    UIImageView *leftImage;
    UIButton *addPicture;
    
    UIView *addPhotoView;
    UIImageView *photoBackgroundImageView;
    UIButton *addPhotoButton;
    UIImage *photoImage;
    
}
@property (nonatomic ,retain) UIView *bgView;
@property (nonatomic ,copy) NSString *Id;

@end
