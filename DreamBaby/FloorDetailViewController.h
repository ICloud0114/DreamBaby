//
//  FloorDetailViewController.h
//  DreamBaby
//
//  Created by easaa on 14-2-17.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@interface FloorDetailViewController : UIViewController<HPGrowingTextViewDelegate>
{
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
@property (nonatomic ,copy) NSString *Id;
@property (nonatomic , retain) NSDictionary *dataDictionary;
@end
