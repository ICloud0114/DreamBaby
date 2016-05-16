//
//  EAWriteTodayViewController.m
//  梦想宝贝
//
//  Created by easaa on 7/10/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAWriteTodayViewController.h"
#import "SubmitAudioViewController.h"
#import "EAWriteDiaryViewController.h"
@interface EAWriteTodayViewController ()

@end

@implementation EAWriteTodayViewController


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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"写下今天";
    
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)photoAction:(id)sender
{
    EAWriteDiaryViewController *writeDiary = [[[EAWriteDiaryViewController alloc]initWithNibName:@"EAWriteDiaryViewController" bundle:Nil]autorelease];
    [self.navigationController pushViewController:writeDiary animated:YES];
}
- (IBAction)vidoAction:(id)sender
{
    SubmitAudioViewController * subVC = [[[SubmitAudioViewController  alloc]init] autorelease];
    [self.navigationController pushViewController:subVC animated:YES];

}
@end
