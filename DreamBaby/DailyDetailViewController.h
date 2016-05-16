//
//  DailyDetailViewController.h
//  GoodMom
//
//  Created by easaa on 7/8/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DailyDetailViewController : UIViewController<UIWebViewDelegate>
{

    NSString *article_id;
}
@property(nonatomic, assign) int section;
@property(nonatomic, assign) int row;
-(id)initWithDetail:(NSString*)entity;


@end
