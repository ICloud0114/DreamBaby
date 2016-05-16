//
//  ValuableBookViewController.m
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ValuableBookViewController.h"
#import "DayKnowledgeViewController.h"
#import "TaijiaoMusicViewController.h"
#import "YuerHistoryViewController.h"
#import "PinceViewController.h"

#import "EACareRemindViewController.h"

@interface ValuableBookViewController ()

@end

@implementation ValuableBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    self.navigationItem.title = @"孕期宝典";
    
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:titleLabel];
    
    if (self.title != nil)
    {
        [titleLabel setText:self.title];
    }
    if (self.navigationItem.title != nil)
    {
        [titleLabel setText:self.navigationItem.title];
    }
    
    //视图背景
    viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 260)];
    [self.view addSubview:viewBG];
    [viewBG release];
    
    
    //左侧选项卡视图
    UIImageView * leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 235+35)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.userInteractionEnabled = YES;
//    leftView.image = [UIImage imageNamed:@"baodian_bg"];
    [viewBG addSubview:leftView];
    [leftView release];
    
    
    //每日知识
    dayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    dayBtn.frame=CGRectMake(10, 0, 300, 35);
    [dayBtn setTitle:@"每日知识" forState:UIControlStateNormal];
    [dayBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 200, 0, 0)];
    [dayBtn  setTitleColor:[UIColor colorwithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [dayBtn  setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateSelected];
    dayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [dayBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"]forState:UIControlStateNormal];
    [dayBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateSelected];
    [dayBtn addTarget:self action:@selector(dayKonwlege:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:dayBtn];
    
    //胎教音乐
    taiJiaoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    taiJiaoBtn.frame=CGRectMake(10, 45, 300, 35);
    [taiJiaoBtn setTitle:@"胎教音乐" forState:UIControlStateNormal];
    [taiJiaoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 200, 0, 0)];
    [taiJiaoBtn  setTitleColor:[UIColor colorwithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [taiJiaoBtn  setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateSelected];
    taiJiaoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [taiJiaoBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"] forState:UIControlStateNormal];
    [taiJiaoBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateSelected];
    [taiJiaoBtn addTarget:self action:@selector(taiJiao:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:taiJiaoBtn];
    
//    //育儿故事
//    yuerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    yuerBtn.frame=CGRectMake(30, 70+35+35, 120, 30);
//    [yuerBtn setTitle:@"育儿故事" forState:UIControlStateNormal];
//    [yuerBtn  setTitleColor:[UIColor colorwithHexString:@"#ca2281"] forState:UIControlStateNormal];
//    [yuerBtn  setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateSelected];
//    yuerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [yuerBtn setBackgroundImage:[UIImage imageNamed:@"baodian_list_bg"] forState:UIControlStateNormal];
//    [yuerBtn setBackgroundImage:[UIImage imageNamed:@"baodian_list_bg_h"] forState:UIControlStateSelected];
//    [yuerBtn addTarget:self action:@selector(yuerBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [leftView addSubview:yuerBtn];
    
    //评测
    pinceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    pinceBtn.frame=CGRectMake(10, 45 + 45, 300, 35);
    pinceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
    [pinceBtn setTitle:@"评测" forState:UIControlStateNormal];
    [pinceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 200, 0, 0)];
    [pinceBtn  setTitleColor:[UIColor colorwithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [pinceBtn  setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateSelected];
    pinceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [pinceBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"] forState:UIControlStateNormal];
    [pinceBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateSelected];
    [pinceBtn addTarget:self action:@selector(pinceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:pinceBtn];
    //关爱提醒
//    loveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    loveBtn.frame=CGRectMake(30, 70+35+35+35+35, 120, 30);
//    loveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 22);
//    [loveBtn setTitle:@"关爱提醒" forState:UIControlStateNormal];
//    [loveBtn  setTitleColor:[UIColor colorwithHexString:@"#ca2281"] forState:UIControlStateNormal];
//    [loveBtn  setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateSelected];
//    loveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [loveBtn setBackgroundImage:[UIImage imageNamed:@"baodian_list_bg"] forState:UIControlStateNormal];
//    [loveBtn setBackgroundImage:[UIImage imageNamed:@"baodian_list_bg_h"] forState:UIControlStateSelected];
//    [loveBtn addTarget:self action:@selector(loveBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    loveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loveBtn.frame=CGRectMake(10,  45  + 45 + 45, 300, 35);
    [loveBtn setTitle:@"关爱提醒" forState:UIControlStateNormal];
    [loveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 200, 0, 0)];
    [loveBtn  setTitleColor:[UIColor colorwithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [loveBtn  setTitleColor:[UIColor colorwithHexString:@"#ffffff"] forState:UIControlStateSelected];
    loveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [loveBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu"] forState:UIControlStateNormal];
    [loveBtn setBackgroundImage:[UIImage imageNamed:@"yuchangqi_xiayibu_h"] forState:UIControlStateSelected];
    [loveBtn addTarget:self action:@selector(loveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:loveBtn];
}
- (void)dayKonwlege:(UIButton *)sender
{
//      sender.selected = !sender.selected;
//    if (sender.selected) {
        dayBtn.selected = YES;
        taiJiaoBtn.selected = NO;
        yuerBtn.selected = NO;
        pinceBtn.selected = NO;
        loveBtn.selected=NO;
        DayKnowledgeViewController * dayVC = [[DayKnowledgeViewController alloc]init];
        [dayVC setValue:@"002" forKey:@"flagType"];
//        LoveTipsViewController *lovet=[[LoveTipsViewController alloc]init];
//        lovet.isLoveTip=@"love";
        [self.navigationController pushViewController:dayVC animated:YES];
//        [lovet release];
        [dayVC release];
//    }
}

//关爱提醒
-(void)loveBtn:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
        dayBtn.selected = NO;
        taiJiaoBtn.selected = NO;
        yuerBtn.selected = NO;
        pinceBtn.selected = NO;
        loveBtn.selected=YES;
        
//        DayKnowledgeViewController * dayVC = [[DayKnowledgeViewController alloc]init];
//        [dayVC setValue:@"002" forKey:@"flagType"];
//       LoveTipsViewController *lovet=[[LoveTipsViewController alloc]init];
//    lovet.isLoveTip=@"love";
//        [self.navigationController pushViewController:lovet animated:YES];
//           [lovet release];
//        [dayVC release];
        
        EACareRemindViewController *careRemind = [[[EACareRemindViewController alloc]initWithNibName:@"EACareRemindViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:careRemind animated:YES];
        
        
//    }
}

- (void)taiJiao:(UIButton *)sender
{
//     sender.selected = !sender.selected;
//    if (sender.selected) {
        dayBtn.selected = NO;
        taiJiaoBtn.selected = YES;
        yuerBtn.selected = NO;
        pinceBtn.selected = NO;
        loveBtn.selected=NO;
        TaijiaoMusicViewController * tVC = [[TaijiaoMusicViewController alloc]init];
        tVC.article_id = @"1";
        [self.navigationController pushViewController:tVC animated:YES];
        [tVC release];
//    }
   
}
- (void)yuerBtn:(UIButton *)sender
{
//     sender.selected = !sender.selected;
//    if (sender.selected) {
        dayBtn.selected = NO;
        taiJiaoBtn.selected = NO;
        yuerBtn.selected = YES;
        pinceBtn.selected = NO;
        loveBtn.selected=NO;
        YuerHistoryViewController * yuerVC = [[YuerHistoryViewController alloc]init];
        yuerVC.article_id = @"2";
        [self.navigationController pushViewController:yuerVC animated:YES];
        [yuerVC release];
//    }
   
}
- (void)pinceBtn:(UIButton *)sender
{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
        dayBtn.selected = NO;
        taiJiaoBtn.selected = NO;
        yuerBtn.selected = NO;
        pinceBtn.selected = YES;
        loveBtn.selected=NO;
        PinceViewController * yuerVC = [[PinceViewController alloc]init];
        [self.navigationController pushViewController:yuerVC animated:YES];
        [yuerVC release];
//    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
