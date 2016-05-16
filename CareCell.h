//
//  CareCell.h
//  GoodMom
//
//  Created by easaa on 7/29/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareCell : UITableViewCell
@property(nonatomic,retain)UILabel *titlelabel;
@property(nonatomic,retain)UILabel *remindlabel;
-(void)setTitlelabelText:(NSString *)text;
@end
