//
//  DayKnowledgeCell.m
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "DayKnowledgeCell.h"

@implementation DayKnowledgeCell

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
    self.BgView.frame = CGRectMake(self.BgView.frame.origin.x, self.BgView.frame.origin.y, 320, self.frame.size.height-5);
    self.BgView.layer.backgroundColor = [UIColor colorwithHexString:@"#e7d4df"].CGColor;
    self.BgView.layer.cornerRadius = 0;
    
    self.WeekLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    self.Daylabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    self.TilLabel.textColor  = [UIColor colorwithHexString:@"#DD2E94"];
//    self.ContentLabel.textColor=[UIColor greenColor];
    if (_IconImage == nil)
    {
        _IconImage = [[ZZAutoSizeImageView alloc]initWithFrame:CGRectMake(10, 40, 300, 147)];
        [self addSubview:_IconImage];
        [_IconImage release];
    }

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_BgView release];
    [_WeekLabel release];
    [_Daylabel release];
    [_TilLabel release];
    [_IconImage release];
    [_ContentLabel release];
    [_ContentWeb release];
    [super dealloc];
}
@end
