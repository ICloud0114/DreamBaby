//
//  MyDiaryCell.m
//  DreamBaby
//
//  Created by easaa on 14-2-18.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "MyDiaryCell.h"

@implementation MyDiaryCell
@synthesize contentImageView;
@synthesize musicImageView;
@synthesize musicLabel;
@synthesize contentLabel;
@synthesize bgView;
@synthesize sharebtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
    }
    return self;
}

- (void)dealloc
{
    [bgView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor colorwithHexString:@"#FFD9EC"];;
        self.cellScrollView.backgroundColor = [UIColor yellowColor];
        bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.height - 5)];
        //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
        bgView.layer.backgroundColor = [UIColor clearColor].CGColor;
        bgView.layer.cornerRadius = 3;
        [self.contentView addSubview:bgView];
        
        
        dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 35, 20)];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.font = [UIFont systemFontOfSize:22];
        dayLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [bgView addSubview:dayLabel];
        [dayLabel release];
        
        monthLabel = [[UILabel alloc]initWithFrame: CGRectMake(35, 20, 25, 15)];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.font = [UIFont systemFontOfSize:13];
        monthLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [bgView addSubview:monthLabel];
        [monthLabel release];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 200, 40)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.numberOfLines = 2;
        contentLabel.textColor = [UIColor colorwithHexString:@"#DD2E94"];
        [bgView addSubview:contentLabel];
        [contentLabel release];
        
        contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 5, 200, 100)];
        contentImageView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:contentImageView];
        [contentImageView release];
        
        musicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(82, 7, 35, 35)];
        musicImageView.image = [UIImage imageNamed:@"tanchukuang_icon"];
        [bgView addSubview:musicImageView];
        musicImageView.hidden = YES;
        [musicImageView release];
        
        musicLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 140, 20)];
        musicLabel.backgroundColor = [UIColor clearColor];
        musicLabel.font = [UIFont systemFontOfSize:13];
        musicLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [bgView addSubview:musicLabel];
        [musicLabel release];
        
//        sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        sharebtn.frame=CGRectMake(bgView.frame.size.width-30, bgView.frame.size.height-30, 30, 30);
//        sharebtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon"] forState:UIControlStateNormal];
//        [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon_h"] forState:UIControlStateHighlighted];
//        [bgView addSubview:sharebtn];
        self.photoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(85, 55, 150, 100)] autorelease];
        [bgView addSubview:self.photoImage];
        self.photoImage.hidden = YES;
//        [self.photoImage release];
        self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImage.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.cellScrollView.backgroundColor = [UIColor clearColor];
        bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.height - 5)];
        //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
        bgView.layer.backgroundColor = [UIColor clearColor].CGColor;
        bgView.layer.cornerRadius = 3;
        [self.contentView addSubview:bgView];
        
        
        dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 35, 20)];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.font = [UIFont systemFontOfSize:22];
        dayLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [bgView addSubview:dayLabel];
        [dayLabel release];
        
        monthLabel = [[UILabel alloc]initWithFrame: CGRectMake(35, 20, 25, 15)];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.font = [UIFont systemFontOfSize:13];
        monthLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [bgView addSubview:monthLabel];
        [monthLabel release];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 200, 40)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.numberOfLines = 2;
        contentLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [bgView addSubview:contentLabel];
        [contentLabel release];
        
        contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 60, 60)];
        contentImageView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:contentImageView];
        [contentImageView release];
        
        musicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(82, 7, 35, 35)];
        musicImageView.image = [UIImage imageNamed:@"tanchukuang_icon"];
        [bgView addSubview:musicImageView];
        musicImageView.hidden = YES;
        [musicImageView release];
        
        musicLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 140, 20)];
        musicLabel.backgroundColor = [UIColor clearColor];
        musicLabel.font = [UIFont systemFontOfSize:13];
        musicLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
        [bgView addSubview:musicLabel];
        [musicLabel release];
        
        sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sharebtn.frame=CGRectMake(bgView.frame.size.width-30, bgView.frame.size.height-30, 30, 30);
        sharebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon"] forState:UIControlStateNormal];
        [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon_h"] forState:UIControlStateHighlighted];
        [bgView addSubview:sharebtn];
        self.photoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(85, 55, 150, 100)] autorelease];
        [bgView addSubview:self.photoImage];
        self.photoImage.hidden = YES;
//        [self.photoImage release];
        self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImage.backgroundColor = [UIColor clearColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    bgView.frame = CGRectMake(15, 0, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.height - 5);
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if(version<7.0f){
        bgView.frame = CGRectMake(0, 0, 300, self.contentView.bounds.size.height);
        bgView.layer.cornerRadius = 8;
    }
    sharebtn.frame=CGRectMake(bgView.frame.size.width-30, bgView.frame.size.height-30, 30, 30);
    
}



- (void)setDaySTR:(NSString *)daySTR
{
    dayLabel.text = daySTR;
}
- (void)setMonth:(NSString *)month
{
    monthLabel.text = [NSString stringWithFormat:@"%@月",month];
}
- (void)setDiaContent:(NSString *)diaContent
{
    contentLabel.text = diaContent;
}
- (void)setMusic:(NSString *)music
{
    musicLabel.text = music;
    musicImageView.hidden = NO;
}

@end
