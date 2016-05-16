//
//  EADoctorCell.m
//  梦想宝贝
//
//  Created by easaa on 7/9/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EADoctorCell.h"

@implementation EADoctorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_doctorPicture release];
    [_doctorDetail release];
    [_doctorName release];
    [super dealloc];
}
@end
