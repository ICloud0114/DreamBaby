//
//  MemberCell.h
//  DreamBaby
//
//  Created by easaa on 14-2-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
@interface MemberCell : UITableViewCell
{
    UILabel *_titleLabel;
    CustomTextField *_contentField;
    
}

@property (nonatomic ,assign) UILabel     *titleLabel;
@property (nonatomic ,assign) CustomTextField *contentField;


@property (nonatomic ,assign) NSString    *title;
@property (nonatomic ,assign) NSString    *content;
@end
