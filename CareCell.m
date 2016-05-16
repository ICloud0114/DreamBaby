//
//  CareCell.m
//  GoodMom
//
//  Created by easaa on 7/29/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import "CareCell.h"

@implementation CareCell
@synthesize titlelabel;
@synthesize remindlabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
        titlelabel.textColor=[UIColor blackColor];
        titlelabel.font=[UIFont boldSystemFontOfSize:14];
        titlelabel.backgroundColor=[UIColor clearColor];
        titlelabel.numberOfLines=0;
        titlelabel.lineBreakMode=NSLineBreakByWordWrapping;
        [self addSubview:titlelabel];
        remindlabel=[[UILabel alloc]initWithFrame:CGRectMake(115, 10, 50, 20)];
        remindlabel.text=@"本周重点";
        remindlabel.textColor=[UIColor redColor];
        remindlabel.font=[UIFont boldSystemFontOfSize:12];
        remindlabel.backgroundColor=[UIColor clearColor];
        [self addSubview:remindlabel];
        UIButton *accessBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [accessBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [accessBtn setImage:[UIImage imageNamed:@"arrow_h"] forState:UIControlStateHighlighted];
        accessBtn.frame=CGRectMake(270, 15, 20, 20);
        [self addSubview:accessBtn];
    }
    return self;
}
-(void)setTitlelabelText:(NSString *)text
{
    CGSize size=[text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(205, 30)];
    titlelabel.frame=CGRectMake(15, 10, size.width,size.height);
    titlelabel.text=text;
//    NSLog(@"---%f%f",size.width,size.height);
    remindlabel.frame=CGRectMake(20+size.width, 10, 50, 20);
}

- (void)dealloc
{
    RELEASE_SAFE(remindlabel);
    RELEASE_SAFE(titlelabel);
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_line"]].CGColor);
    CGContextStrokeRect(context, CGRectMake(10, -1, rect.size.width - 20, 2));
}
@end
