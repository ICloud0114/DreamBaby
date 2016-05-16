//
//  MemberEntiy.h
//  GoodMom
//
//  Created by 李东辉 on 13-8-8.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberEntiy : NSObject
@property (nonatomic,retain) NSString * user_name;
@property (nonatomic,retain) NSString * idString;
@property (nonatomic,retain) NSString * mobileNum;
@property (nonatomic,retain) NSString * nick_name;
@property (nonatomic,retain) NSString * email;
@property (nonatomic,retain) NSString * birthday;
@property (nonatomic, retain)NSString *city;
@property (nonatomic,retain) NSString * area;
@property (nonatomic,retain) NSString * rows;
@property (nonatomic,retain) NSString * address;
@property (nonatomic,retain) NSString * avatar;
@property (nonatomic,retain) NSString * id_card;
@property (nonatomic,retain) NSString * signature;
@property (nonatomic,retain) NSString * census;
@property (nonatomic,assign) NSInteger isvip;

@property (nonatomic, assign)NSInteger cityId;
@property (nonatomic,assign) NSInteger areaId;
@property (nonatomic,assign) NSInteger rowId;

@property (nonatomic) BOOL hasValue;
@end
