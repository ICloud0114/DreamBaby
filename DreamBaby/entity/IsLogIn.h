//
//  IsLogIn.h
//  GoodMom
//
//  Created by 李东辉 on 13-8-8.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberEntiy.h"

@interface IsLogIn : NSObject
@property (nonatomic,retain)MemberEntiy * memberData;
@property (nonatomic,assign)BOOL isLogIn;
@property (nonatomic,retain) NSArray *cityArray;
+(IsLogIn *)instance;
- (void)memberClean;
//- (void)getmemberInfo;

@end
