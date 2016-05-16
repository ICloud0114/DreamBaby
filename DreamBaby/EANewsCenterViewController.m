//
//  EANewsCenterViewController.m
//  梦想宝贝
//
//  Created by easaa on 7/10/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EANewsCenterViewController.h"
#import "EANewsListViewController.h"
@interface EANewsCenterViewController ()

@end

@implementation EANewsCenterViewController

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
    
    self.navigationItem.title = @"新闻中心";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
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
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)newsTip:(id)sender
{
    EANewsListViewController *newList = [[[EANewsListViewController alloc]initWithNibName:@"EANewsListViewController" bundle:nil]autorelease];
    newList.item = @"新闻资讯";
    newList.type = @"3";
    [self.navigationController pushViewController:newList animated:YES];
    
}
- (IBAction)govNotice:(id)sender
{
    
    EANewsListViewController *newList = [[[EANewsListViewController alloc]initWithNibName:@"EANewsListViewController" bundle:nil]autorelease];
    
    
    newList.item = @"政府公告";
    newList.type = @"2";
    [self.navigationController pushViewController:newList animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
