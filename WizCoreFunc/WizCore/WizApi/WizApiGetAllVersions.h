//
//  WizApiGetAllVersions.h
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApi.h"
@protocol WizApiGetAllVersionsDelegate <NSObject>
- (void) didGetAllObjectVersions:(NSDictionary*)dic;
@end
@interface WizApiGetAllVersions : WizApi
@property (nonatomic, assign) id<WizApiGetAllVersionsDelegate> delegate;
@end
