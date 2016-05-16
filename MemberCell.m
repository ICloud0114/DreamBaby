//
//  MemberCell.m
//  DreamBaby
//
//  Created by easaa on 14-2-10.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell
@synthesize titleLabel = _titleLabel;
@synthesize contentField = _contentField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, -7, 70, 45)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    
    
    //
    
    _contentField = [[CustomTextField alloc]initWithFrame:CGRectMake(110, 0, 190, 45)];
     
    [_contentField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    _contentField.font = [UIFont systemFontOfSize:14];
//    [self.contentView addSubview:_contentField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//
- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    
    CGRect frame = _titleLabel.frame;
    CGSize size = [title sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    frame.size.width = size.width;
    _titleLabel.frame = frame;
    
    
    frame = _contentField.frame;
    frame.origin.x = _titleLabel.frame.origin.x + _titleLabel.frame.size.width + 20;
    _contentField.frame = frame;
}


- (void)setContent:(NSString *)content
{
    _contentField.text = content;
    
    CGRect frame = _contentField.frame;
    CGSize size = [content sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    frame.size.width = size.width;
    _contentField.frame = frame;
}



- (void)dealloc
{
    [_titleLabel release];
    [_contentField release];
    [super dealloc];
}

@end
