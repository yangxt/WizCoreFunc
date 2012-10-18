//
//  WizAccountManager.m
//  Wiz
//
//  Created by 朝 董 on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WizAccountManager.h"
#import "WizAccount.h"

#import "WizFileManager.h"
#import "WizDbManager.h"
#import "WizSyncCenter.h"

#define KeyOfAccounts               @"accounts"
#define KeyOfUserId                 @"userId"
#define KeyOfPassword               @"password"
#define KeyOfDefaultUserId          @"defaultUserId"
#define KeyOfProtectPassword        @"protectPassword"
#define KeyOfKbguids                @"KeyOfKbguids"



//
@interface WizAccountManager()

@end

@implementation WizAccountManager
+ (id) defaultManager;
{
    static WizAccountManager* shareManager = nil;
    @synchronized(self)
    {
        if (shareManager == nil) {
            shareManager = [[super allocWithZone:NULL] init];
        }
        return shareManager;
    }
}
+ (id) allocWithZone:(NSZone *)zone
{
    return [[self defaultManager] retain];
}
- (id) retain
{
    return self;
}
- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}
- (id) copyWithZone:(NSZone*)zone
{
    return self;
}
- (id) autorelease
{
    return self;
}
- (oneway void) release
{
    return;
}
//over singlong

- (NSArray*) allAccountUserIds
{
    NSArray* accounts = [[[WizDbManager shareInstance] getGlobalSettingDb] allAccounts];
    NSMutableArray* accountUserIds = [NSMutableArray array];
    for (WizAccount* account in accounts) {
        [accountUserIds addObject:account.strUserId];
    }
    return accountUserIds;
}

- (BOOL) canFindAccount:(NSString *)userId
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    WizAccount* account = [db accountFromUserId:userId];
    if (nil == account) {
        return NO;
    }
    return YES;
}

- (NSString*) accountPasswordByUserId:(NSString *)userID
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    WizAccount* account = [db accountFromUserId:userID];
    if (account) {
        return account.strPassword;
    }
    return nil;
}


- (BOOL) registerActiveAccount:(NSString *)userId
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    [db setStrSettingSettingVelue:userId forKey:WizSettingGlobalActiveAccount accountUserId:nil kbguid:nil];
    [[WizSyncCenter defaultCenter] refreshGroupsListFor:userId];
    return YES;
}

- (void) resignAccount
{
#warning do something to clear enviroment
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    [db setStrSettingSettingVelue:@"" forKey:WizSettingGlobalActiveAccount accountUserId:nil kbguid:nil];
}
- (NSString*) activeAccountUserId
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    NSString* userId = [db strSettingValueForKey:WizSettingGlobalActiveAccount accountUserId:nil kbguid:nil];
    if (userId) {
        return userId;
    }
    return WizDefalutAccount;
}

- (void) updateAccount:(NSString *)userId password:(NSString *)passwrod
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    [db updateAccount:userId password:passwrod];
}

- (void) removeAccount:(NSString *)userId
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    [db deleteAccountByUserId:userId];
}
//

- (BOOL) registerActiveGroup:(NSString *)groupGuid
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    
    [db setStrSettingSettingVelue:groupGuid forKey:WizSettingGlobalActiveGroup accountUserId:nil kbguid:nil];
    return YES;
}
- (void) resignActiveGroup
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    [db setStrSettingSettingVelue:@"" forKey:WizSettingGlobalActiveGroup accountUserId:nil kbguid:nil];
}
- (NSString*) activeGroupGuid
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    NSString* userId = [db strSettingValueForKey:WizSettingGlobalActiveGroup accountUserId:nil kbguid:nil];
    if (userId) {
        return userId;
    }
    return WizDefalutAccount;
}
- (NSArray*) groupsForAccount:(NSString *)accountUserId
{
    id<WizSettingsDbDelegate> db = [[WizDbManager shareInstance] getGlobalSettingDb];
    return [db groupsByAccountUserId:accountUserId];
}
@end
