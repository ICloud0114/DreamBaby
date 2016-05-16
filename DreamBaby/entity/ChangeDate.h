//
//  ChangeDate.h
//  GoodMom
//
//  Created by easaa on 8/14/13.
//  Copyright (c) 2013 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeDate : NSObject
@property(nonatomic,retain)NSString *type_id;
+(ChangeDate *)instance;
-(id)init;
@end
