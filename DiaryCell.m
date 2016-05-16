//
//  DiaryCell.m
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "DiaryCell.h"

@implementation DiaryCell
@synthesize bgView,sharebtn;
- (id)initWithInfoStyle:(DiaryCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons height:(CGFloat)height
{
    _style = style;
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons height:height];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorwithHexString:@"#f1e5ec"];
        
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.height)];
        //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#e7d4df"].CGColor;
        bgView.layer.cornerRadius = 3;
        [self.contentView addSubview:bgView];
        
        if (style == DiaryCellStyle1)
        {
            [self setUpStyle1];
        }else if (style == DiaryCellStyleDefault)
        {
            [self setUpDefault];
        }else if (style == DiaryCellStyle2)
        {
            [self setUpStyle2];
        }
    }
    return self;
}

- (id)initWithInfoStyle:(DiaryCellStyle)style  reuseIdentifier:(NSString *)reuseIdentifier
{
    _style = style;
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.height)];
        //bgView.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f].CGColor;
        bgView.layer.backgroundColor = [UIColor colorwithHexString:@"#e7d4df"].CGColor;
        bgView.layer.cornerRadius = 3;
        [self.contentView addSubview:bgView];
        
        if (style == DiaryCellStyle1)
        {
            [self setUpStyle1];
        }else if (style == DiaryCellStyleDefault)
        {
            [self setUpDefault];
        }else if (style == DiaryCellStyle2)
        {
            [self setUpStyle2];
        }
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    bgView.frame = CGRectMake(15, 0, self.contentView.bounds.size.width - 25, self.contentView.bounds.size.height);
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if(version<7.0f){
        bgView.frame = CGRectMake(0, 0, 300, self.contentView.bounds.size.height);
        bgView.layer.cornerRadius = 8;
    }
    
    
    if (_style == DiaryCellStyleDefault ) {
        sharebtn.frame=CGRectMake(self.bgView.frame.size.width-30, self.bgView.frame.size.height-30, 30, 30);
        diaContentLabel.frame =CGRectMake(85, 12, 195, self.bgView.frame.size.height-70);
    }
    if (_style == DiaryCellStyle1 )
    {
        sharebtn.frame=CGRectMake(self.bgView.frame.size.width-30, self.bgView.frame.size.height-30, 30, 30);
    }
    if (_style == DiaryCellStyle2 )
    {
        sharebtn.frame=CGRectMake(self.bgView.frame.size.width-30, self.bgView.frame.size.height-30, 30, 30);
    }
    
}
- (void)setUpStyle1
{
    dayLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 5, 20, 20)];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.font = [UIFont systemFontOfSize:16];
    dayLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:dayLabel];
    [dayLabel release];
    
    monthLabel = [[UILabel alloc]initWithFrame: CGRectMake(30, 12, 20, 10)];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.font = [UIFont systemFontOfSize:11];
    monthLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:monthLabel];
    [monthLabel release];
    
    UIImageView * ivBG = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 62, 62)];
    [ivBG setBackgroundColor:[UIColor clearColor]];
    ivBG.userInteractionEnabled = YES;
    ivBG.image = [UIImage imageNamed:@"huiyuan_touxiang_pic_bg"];
    [self.bgView addSubview:ivBG];
    [ivBG release];
    
    photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 58, 58)];
    photoImage.userInteractionEnabled = YES;
    photoImage.image = [UIImage imageNamed:@"icon"];
    [ivBG addSubview:photoImage];
    [photoImage release];
    
    
    sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame=CGRectMake(self.bgView.frame.size.width-30, self.bgView.frame.size.height-30, 30, 30);
    sharebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon"] forState:UIControlStateNormal];
    [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon_h"] forState:UIControlStateHighlighted];
    [self.bgView addSubview:sharebtn];
}
///////////
- (void)setUpDefault
{
    dayLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 5, 20, 20)];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.font = [UIFont systemFontOfSize:16];
    dayLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:dayLabel];
    [dayLabel release];
    
    monthLabel = [[UILabel alloc]initWithFrame: CGRectMake(30, 12, 20, 10)];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.font = [UIFont systemFontOfSize:11];
    monthLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:monthLabel];
    [monthLabel release];
    
    diaContentLabel = [[UILabel alloc]initWithFrame: CGRectMake(85, 12, 195, 40)];
    diaContentLabel.backgroundColor = [UIColor clearColor];
    diaContentLabel.font = [UIFont systemFontOfSize:11];
    diaContentLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:diaContentLabel];
    [diaContentLabel release];
    diaContentLabel.numberOfLines = 0;
    
    
    
    sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame=CGRectMake(self.bgView.frame.size.width-30, self.bgView.frame.size.height-30, 30, 30);
    sharebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon"] forState:UIControlStateNormal];
    [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon_h"] forState:UIControlStateHighlighted];
    [self.bgView addSubview:sharebtn];
    //[sharebtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [sharebtn addTarget:self action:@selector(shareWeibo) forControlEvents:UIControlEventTouchUpInside];
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
    diaContentLabel.text = diaContent;
}
- (void)setMusic:(NSString *)music
{
    musicLabel.text = music;
}


- (void)setUpStyle2
{
    dayLabel = [[UILabel alloc]initWithFrame: CGRectMake(10, 5, 20, 20)];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.font = [UIFont systemFontOfSize:16];
    dayLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:dayLabel];
    [dayLabel release];
    
    monthLabel = [[UILabel alloc]initWithFrame: CGRectMake(30, 12, 20, 10)];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.font = [UIFont systemFontOfSize:11];
    monthLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:monthLabel];
    [monthLabel release];
    
    UIImageView * musicLogo = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 35, 35)];
    musicLogo.userInteractionEnabled = YES;
    musicLogo.image = [UIImage imageNamed:@"tanchukuang_icon"];
    [self.bgView addSubview:musicLogo];
    [musicLogo release];
    
    
    musicLabel = [[UILabel alloc]initWithFrame: CGRectMake(120, 30, 135, 10)];
    musicLabel.backgroundColor = [UIColor clearColor];
    musicLabel.font = [UIFont systemFontOfSize:11];
    musicLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
    [self.bgView addSubview:musicLabel];
    [musicLabel release];
    
    
    sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame=CGRectMake(self.bgView.frame.size.width-30, self.bgView.frame.size.height-30, 30, 30);
    sharebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon"] forState:UIControlStateNormal];
    [sharebtn setImage:[UIImage imageNamed:@"fenxiang_icon_h"] forState:UIControlStateHighlighted];
    [self.bgView addSubview:sharebtn];

}
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

- (void)dealloc
{
    [bgView release];
    //[diaContentLabel release];
    [dayLabel release];
    //[monthLabel release];
    [super dealloc];
}

@end
