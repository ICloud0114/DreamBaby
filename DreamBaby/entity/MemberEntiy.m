//
//  MemberEntiy.m
//  GoodMom
//
//  Created by 李东辉 on 13-8-8.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import "MemberEntiy.h"

@implementation MemberEntiy

@synthesize user_name,mobileNum,idString,nick_name,email,birthday,city,area,rows,address,avatar;
- (void)dealloc
{
    [user_name release];
    [mobileNum release];
    [idString release];
    [nick_name release];
    [email release];
    [birthday release];
    [city release];
    [area release];
    [rows release];
    [address release];
    [avatar release];
    [super dealloc];
}

@end
