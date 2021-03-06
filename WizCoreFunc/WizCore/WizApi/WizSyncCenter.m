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

typedef enum WizGroupSyncStatue_
{
    WizGroupSyncStatueNormal = 0,
    WizGroupSyncStatueSycning = 1
}WizGroupSyncStatue;

@interface WizSyncCenter () <WizApiLoginDelegate, WizApiRefreshGroupsDelegate>
{
    NSMutableDictionary* syncToolDictionay;
    //
}
@property (nonatomic, retain) WizApiRefreshGroups* refreshGroupsTool;
@property (nonatomic, retain) WizApiClientLogin* loginTool;
@property (atomic, retain)     NSMutableDictionary* syncStatueDic;
@end

@implementation WizSyncCenter
@synthesize refreshGroupsTool;
@synthesize loginTool;
@synthesize syncStatueDic;
- (void) dealloc
{
    [syncStatueDic release];
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
        syncStatueDic = [[NSMutableDictionary alloc] init];
        //
        [[WizNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(didUpdateGroup:)
                                                      name:WizNMWillUpdateGroupList
                                                    object:nil];
        [[WizNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(willUpdateGroup:)
                                                      name:WizNMDidUpdataGroupList
                                                    object:nil];
        
    }
    return self;
}

- (void) setSync:(NSString*)key statue:(NSInteger)statue
{
    [self.syncStatueDic setObject:[NSNumber numberWithInteger:statue] forKey:key];
}

- (void) didUpdateGroup:(NSNotification*)nc
{
    NSString* kbguid = [WizNotificationCenter getGuidFromNc:nc];
    if (kbguid) {
        [self setSync:kbguid statue:WizGroupSyncStatueNormal];
    }
}
- (void) willUpdateGroup:(NSNotification*)nc
{
    NSString* kbguid = [WizNotificationCenter getGuidFromNc:nc];
    if (kbguid) {
        [self setSync:kbguid statue:WizGroupSyncStatueSycning];
    }
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
    NSString* accountUserId = [[WizAccountManager defaultManager] activeAccountUserId];
    NSArray* groupsArray = [[WizAccountManager defaultManager] groupsForAccount:accountUserId];
    for (WizGroup* each in groupsArray) {
        [self refreshGroupData:each.kbguid accountUserId:accountUserId];
    }
}


- (void) didClientLoginFaild:(NSError *)error
{
    [WizGlobals reportError:error];
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
    if (self.loginTool == nil || self.loginTool.statue == WizApiStatueNormal) {
        self.loginTool = [[[WizApiClientLogin alloc] init] autorelease];
        self.loginTool.accountUserId = accountUserId;
        self.loginTool.password = [[WizAccountManager defaultManager] accountPasswordByUserId:accountUserId];
        self.loginTool.delegate = self;
        [self.loginTool start];
    }
}

- (void) refreshGroupData:(NSString*)kbguid accountUserId:(NSString*)accountUserId
{
    WizGroupSync* syncTool = [self getSyncToolForGroup:kbguid accountUserId:accountUserId];
    [syncTool startSyncMeta];
}

- (void) downloadDocument:(WizDocument *)doc kbguid:(NSString *)kbguid accountUserId:(NSString *)accountUserId
{
    WizGroupSync* syncTool = [self getSyncToolForGroup:kbguid accountUserId:accountUserId];
    [syncTool downloadWizObject:doc];
}
- (void) downloadAttachment:(WizAttachment*)attach kbguid:(NSString*)kbguid accountUserId:(NSString*)accountUserId
{
     WizGroupSync* syncTool = [self getSyncToolForGroup:kbguid accountUserId:accountUserId];
    [syncTool downloadWizObject:attach];
}

- (BOOL) isSyncingGropMeta
{
    NSArray* array = [syncToolDictionay allValues];
    for (id each in array) {
        if ([each isKindOfClass:[WizGroupSync class]]) {
            WizGroupSync* gs = (WizGroupSync*)each;
            if ([gs isSyncingMeta]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (NSString*) syncStatueKeyGrop:(NSString *)kbguid accountUserId:(NSString *)accountUserId
{
    return [NSString stringWithFormat:@"syncStatue%@%@",kbguid,accountUserId];;
}


- (BOOL) isSyncingGrop:(NSString *)kbguid accountUserId:(NSString *)accountUserId
{
    NSArray* array = [syncToolDictionay allValues];
    for (id each in array) {
        if ([each isKindOfClass:[WizGroupSync class]]) {
            WizGroupSync* gs = (WizGroupSync*)each;
            if ([gs.kbguid isEqualToString:kbguid] && [gs.accountUserId isEqualToString:accountUserId]) {
                if ([gs isSyncingMeta]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}
- (void) testSyncKb:(NSString*)kbguid accountUserId:(NSString*)accountUserId
{
    NSOperationQueue* operationQueque = [[NSOperationQueue alloc] init];
    WizSyncGropOperation* op = [[WizSyncGropOperation alloc] initWithBbguid:kbguid accountUserId:accountUserId];
    [operationQueque addOperation:op];
}
@end
