//
//  ComuDetailViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZZReplyView.h"
#import "NSString+HTML.h"
#import "JiaoliuDetailCell.h"
#import "HPGrowingTextView.h"
@interface ComuDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,HPGrowingTextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView * contentScrollerView;
    UITableView * mTableView;
//    ZZReplyView *replyView;
    BOOL isSendMessage;
    
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
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *ageGroup;
@property (nonatomic ,copy) NSString *headImg_url;
@property (nonatomic ,copy) NSString *contentString;
@end
