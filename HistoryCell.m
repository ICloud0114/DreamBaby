//
//  HistoryCell.m
//  DreamBaby
//
//  Created by easaa on 14-1-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    self.NameLabel.textColor =[UIColor colorwithHexString:@"#d470a8"];
    self.ResultLabel.textColor = [UIColor colorwithHexString:@"#ff6600"];
    self.DateLabel.textColor = [UIColor colorwithHexString:@"#ffffff"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_NameLabel release];
    [_ResultLabel release];
    [_DateLabel release];
    [super dealloc];
}
@end
