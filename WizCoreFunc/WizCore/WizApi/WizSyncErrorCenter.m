//
//  WizSyncErrorCenter.m
//  WizCore
//
//  Created by wiz on 12-9-24.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizSyncErrorCenter.h"
#import "WizApiClientLogin.h"
#import "WizSyncDataCenter.h"
#import "WizAccountManager.h"

#define WizErrorQuequeUnactiveToken @"WizErrorQuequeUnactiveToken"
#define WizShowErrorSpaceTime           120

@interface WizSyncErrorCenter () <WizApiLoginDelegate>
@property (atomic, retain) NSMutableDictionary* syncDataDictionay;
@property (atomic, retain) NSMutableDictionary* errorQuequeDictionary;
@property (nonatomic, retain) WizApiClientLogin* refreshTokenTool;
@end

@implementation WizSyncErrorCenter
@synthesize errorQuequeDictionary;
@synthesize syncDataDictionay;
@synthesize refreshTokenTool;
- (void) dealloc
{
    [refreshTokenTool release];
    [errorQuequeDictionary release];
    [syncDataDictionay release];
    [super dealloc];
}

- (id) init
{
    self = [super init];
    if (self) {
        errorQuequeDictionary = [[NSMutableDictionary alloc] init];
        syncDataDictionay = [[NSMutableDictionary alloc] init];
    }
    return self;
}


+ (id) shareInstance
{
    static WizSyncErrorCenter* shareInstance = nil;
    @synchronized(self)
    {
        if (nil == shareInstance) {
            shareInstance = [[WizSyncErrorCenter alloc] init];
        }
        return shareInstance;
    }
}



- (NSMutableArray*) errorQuequeFor:(NSString*)errorKey
{
    NSMutableArray* errorQueque = [self.errorQuequeDictionary objectForKey:errorKey];
    if (nil == errorQueque) {
        errorQueque = [NSMutableArray array];
        [self.errorQuequeDictionary setObject:errorQueque forKey:errorKey];
    }
    return errorQueque;
}

- (void) didClientLoginFaild:(NSError *)error
{
    
}

- (void) didClientLoginSucceed:(NSString *)accountUserId retObject:(id)ret
{
    self.refreshTokenTool = nil;
    //
    NSLog(@"ret %@",ret);
    NSString* apiUrl = [ret objectForKey:@"kapi_url"];
    NSString* token = [ret objectForKey:@"token"];
    
    id<WizSyncShareParamsDelegate> wizSyncCenter = [WizSyncDataCenter shareInstance];
    [wizSyncCenter refreshApiurl:[NSURL URLWithString:apiUrl] kbguid:apiUrl];
    [wizSyncCenter refreshToken:token accountUserId:accountUserId];
    //
    
    NSMutableArray* errorQueque = [self errorQuequeFor:WizErrorQuequeUnactiveToken];
    for (WizApi* api in errorQueque ) {
        [api start];
    }
    [errorQueque removeAllObjects];
}
- (void) refreshToken
{
    if (self.refreshTokenTool == nil) {
        self.refreshTokenTool = [[[WizApiClientLogin alloc] init] autorelease];
    }
    // is refreshing
    if (self.refreshTokenTool.statue != WizApiStatueNormal) {
        return;
    }
    //
    self.refreshTokenTool.accountUserId = [[WizAccountManager defaultManager] activeAccountUserId];
    self.refreshTokenTool.password = [[WizAccountManager defaultManager] accountPasswordByUserId:self.refreshTokenTool.accountUserId];
    self.refreshTokenTool.delegate = self;
    [self.refreshTokenTool start];
    
}

- (void) willSolveWizApi:(WizApi *)api onError:(NSError *)error
{
    if (nil == error) {
        [api end];
        return;
    }
    if([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet)
    {
        static NSDate* lastDateShowAlert = nil;
        NSDate* now = [NSDate date];
        if (lastDateShowAlert == nil || [lastDateShowAlert timeIntervalSinceDate:now] > WizShowErrorSpaceTime) {
            [WizGlobals reportError:error];
            lastDateShowAlert = now;
        }
        [api end];
    }
    else if ([error.domain isEqualToString:WizErrorDomain] && WizSyncErrorNullException == error.code) {
        NSMutableArray* errorQueque = [self errorQuequeFor:WizErrorQuequeUnactiveToken];
        [errorQueque addObject:api];
        [self refreshToken];
    }
    else if ([error.domain isEqualToString:NSURLErrorDomain] && NSURLErrorTimedOut == error.code)
    {
        [WizGlobals reportError:error];
        [api end];
    }
    else
    {
        [WizGlobals reportError:error];
        [api end];
    }
}
@end
