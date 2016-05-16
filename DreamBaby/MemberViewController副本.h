//
//  MemberViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "NSString+HTML.h"
@interface MemberViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    LoginView * loginView;
   
    UITableView *memberTable;
//    UIImageView * iconIV;
}
@end
