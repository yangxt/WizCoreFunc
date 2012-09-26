//
//  WizSyncDataCenter.m
//  WizCore
//
//  Created by wiz on 12-9-24.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#define WizSyncKbguid @"WizSyncKbguid"

#import "WizSyncDataCenter.h"
@interface WizSyncDataCenter()
@property (atomic, retain)    NSMutableDictionary* syncDataDictionary;
@end

@implementation WizSyncDataCenter
@synthesize syncDataDictionary;

-(void) dealloc
{
    [syncDataDictionary release];
    [super dealloc];
}

- (id) init
{
    self = [super init];
    if (self) {
        syncDataDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
+ (id<WizSyncShareParamsDelegate>) shareInstance;
{
    static WizSyncDataCenter* shareCenter = nil;
    @synchronized(self)
    {
        if (nil == shareCenter) {
            shareCenter = [[WizSyncDataCenter alloc] init];
        }
        return shareCenter;
    }
}

- (NSURL*) apiUrlForKbguid:(NSString *)kbguid
{
    static NSURL* serverUrl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverUrl = [[NSURL alloc] initWithString:@"http://service.wiz.cn/wizkm/xmlrpc"];
    });
    
    if (nil == kbguid) {
        return serverUrl;
    }
    
    NSURL* apiUrl = [self.syncDataDictionary objectForKey:kbguid];
    if (apiUrl) {
        return apiUrl;
    }
    return serverUrl;
}
- (NSString*) tokenForKbguid:(NSString *)kbguid
{
    return [self.syncDataDictionary objectForKey:WizSyncKbguid];
}
- (void) refreshApiurl:(NSURL *)apiUrl kbguid:(NSString *)kbguid
{
    [self.syncDataDictionary setObject:apiUrl forKey:kbguid];
}
- (void) refreshToken:(NSString *)token kbguid:(NSString *)kbguid
{
    [self.syncDataDictionary setObject:token forKey:WizSyncKbguid];
}

@end
