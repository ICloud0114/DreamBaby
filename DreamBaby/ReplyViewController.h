//
//  ReplyViewController.h
//  梦想宝贝
//
//  Created by IOS001 on 14-5-23.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPRequest.h"
#import "JsonUtil.h"
#import "FBEncryptorDES.h"
#import "NSString+URLEncoding.h"
#import "ATMHud.h"
#import "ActivityPlageView.h"
@protocol reloadDataDelegate <NSObject>
-(void)beginReloadData;

@end
@interface ReplyViewController : UIViewController<UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ActivityPlageView *actPlay;
    BOOL isUp; //阻止多次上传
}
- (IBAction)endReturn:(UITextField *)sender;
@property(nonatomic ,copy)NSString *IDstring;
@property(nonatomic ,retain)id <reloadDataDelegate> delegate;
@end
