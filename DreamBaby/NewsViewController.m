//
//  NewsViewController.m
//  梦想宝贝
//
//  Created by IOS001 on 14-4-23.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
@interface NewsViewController ()
@property (retain, nonatomic) IBOutlet UITableView *NewstableVeiw;

@end

@implementation NewsViewController

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
    [self.NewstableVeiw registerNib:[UINib nibWithNibName:@"NewsCell" bundle:Nil] forCellReuseIdentifier:@"newsCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_NewstableVeiw release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNewstableVeiw:nil];
    [super viewDidUnload];
}
@end
