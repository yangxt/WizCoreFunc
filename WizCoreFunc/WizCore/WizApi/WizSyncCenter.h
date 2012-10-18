//
//  WizSyncCenter.h
//  WizCore
//
//  Created by wiz on 12-8-2.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WizSyncCenter : NSObject
+ (WizSyncCenter*) defaultCenter;
- (void) refreshGroupsListFor:(NSString*)accountUserId;
- (void) refreshGroupData:(NSString*)kbguid accountUserId:(NSString*)accountUserId;
- (void) downloadDocument:(WizDocument*)doc kbguid:(NSString*)kbguid accountUserId:(NSString*)accountUserId;

//
- (void) testSyncKb:(NSString*)kbguid accountUserId:(NSString*)accountUserId;
@end
