//
//  WizAccountManager.h
//  Wiz
//
//  Created by 朝 董 on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WizAccount;
@interface WizAccountManager : NSObject
+ (WizAccountManager *) defaultManager;
- (NSArray*)            allAccountUserIds;
- (BOOL)                canFindAccount: (NSString*)userId;
- (NSString*)           accountPasswordByUserId:(NSString *)userID;
//
- (BOOL)                registerActiveAccount:(NSString*)userId;
- (void)                resignAccount;
- (NSString*)           activeAccountUserId;
- (void)                addAccount: (NSString*)userId password:(NSString*)password;
- (void)                changeAccountPassword: (NSString*)userId password:(NSString*)password;
- (void)                removeAccount: (NSString*)userId;
//
- (BOOL)                registerActiveGroup:(NSString*)groupGuid;
- (void)                resignActiveGroup;
- (NSString*)           activeGroupGuid;
//
@end
