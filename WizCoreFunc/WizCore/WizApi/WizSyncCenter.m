//
//  WizSyncCenter.m
//  WizCore
//
//  Created by wiz on 12-8-2.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizSyncCenter.h"
#import "WizApiClientLogin.h"
#import "WizApiRefreshGroups.h"
#import "WizAccountManager.h"
#import "WizGroupSync.h"

#import "WizSyncGropOperation.h"

@interface WizSyncCenter () <WizApiLoginDelegate, WizApiRefreshGroupsDelegate>
{
    NSMutableDictionary* syncToolDictionay;
}
@property (nonatomic, retain) WizApiRefreshGroups* refreshGroupsTool;
@property (nonatomic, retain) WizApiClientLogin* loginTool;
@end

@implementation WizSyncCenter
@synthesize refreshGroupsTool;
@synthesize loginTool;

- (void) dealloc
{
    [syncToolDictionay release];
    [loginTool release];
    [refreshGroupsTool release];
    [super dealloc];
}

- (id) init
{
    self = [super init];
    if (self) {
        syncToolDictionay = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (WizGroupSync*) getSyncToolForGroup:(NSString*)kbguid  accountUserId:(NSString*)accountUserid
{
    NSString* key = [NSString stringWithFormat:@"%@%@",kbguid,accountUserid];
    WizGroupSync* syncTool = [syncToolDictionay objectForKey:key];
    if (nil == syncTool) {
        syncTool = [[WizGroupSync alloc] init];
        syncTool.kbguid = kbguid;
        syncTool.accountUserId = accountUserid;
        [syncToolDictionay setObject:syncTool forKey:key];
        [syncTool release];
    }
    return syncTool;
}

- (void) didRefreshGroupsSucceed
{
    [[WizNotificationCenter defaultCenter] postNotificationName:WizNMDidUpdataGroupList object:nil];
}

- (void) didClientLoginFaild:(NSError *)error
{
    
}

- (void) didClientLoginSucceed:(NSString *)accountUserId retObject:(id)ret
{
    self.refreshGroupsTool = [[[WizApiRefreshGroups alloc] initWithKbguid:nil accountUserId:accountUserId apiDelegate:nil] autorelease];
    self.refreshGroupsTool.delegate = self;
    [self.refreshGroupsTool start];
}
+ (WizSyncCenter*) defaultCenter
{
    static WizSyncCenter* defaultCenter = nil;
    @synchronized(self)
    {
        if (defaultCenter == nil) {
            defaultCenter = [[WizSyncCenter alloc] init];
        }
    }
    return defaultCenter;
}
- (void) refreshGroupsListFor:(NSString*)accountUserId
{
    self.loginTool = [[[WizApiClientLogin alloc] init] autorelease];
    self.loginTool.accountUserId = accountUserId;
    self.loginTool.password = [[WizAccountManager defaultManager] accountPasswordByUserId:accountUserId];
    self.loginTool.delegate = self;
    [self.loginTool start];
}

- (void) refreshGroupData:(NSString*)kbguid accountUserId:(NSString*)accountUserId
{
    WizGroupSync* syncTool = [self getSyncToolForGroup:kbguid accountUserId:accountUserId];
    NSLog(@"syncTool is %@",syncTool);
    [syncTool startSyncMeta];
}

- (void) downloadDocument:(WizDocument *)doc kbguid:(NSString *)kbguid accountUserId:(NSString *)accountUserId
{
    WizGroupSync* syncTool = [self getSyncToolForGroup:kbguid accountUserId:accountUserId];
    [syncTool downloadWizObject:doc];
}


- (void) testSyncKb:(NSString*)kbguid accountUserId:(NSString*)accountUserId
{
    NSOperationQueue* operationQueque = [[NSOperationQueue alloc] init];
    WizSyncGropOperation* op = [[WizSyncGropOperation alloc] initWithBbguid:kbguid accountUserId:accountUserId];
    [operationQueque addOperation:op];
}
@end
