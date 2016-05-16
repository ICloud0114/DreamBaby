//
//  FeedbackViewController.h
//  VitiSport
//
//  Created by easaa on 6/14/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberViewController.h"
#import "UIPlaceHolderTextView.h"
#import <QuartzCore/QuartzCore.h>
@class FeedbackViewController;
@protocol FeedbackViewControllerDelegate <NSObject>

//- (void)FeedbackViewController:(FeedbackViewController *)controller didFinishUpload:(NSDictionary *)dictionary;
- (void)FeedbackViewController:(FeedbackViewController *)controller didFinishUpdateSignature:(NSString *)signature;

@end
@interface FeedbackViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIPlaceHolderTextView *contentFied;
    UIImageView *photoImageView;
    BOOL isUp;
}

@property(nonatomic) BOOL isFeedback;
@property(nonatomic) BOOL isSign;
@property (nonatomic ,retain) id<FeedbackViewControllerDelegate> delegate;
@end
