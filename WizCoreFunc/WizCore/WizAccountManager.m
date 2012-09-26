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

#define SettingsFileName            @"settings.plist"
#define KeyOfAccounts               @"accounts"
#define KeyOfUserId                 @"userId"
#define KeyOfPassword               @"password"
#define KeyOfDefaultUserId          @"defaultUserId"
#define KeyOfProtectPassword        @"protectPassword"
#define KeyOfKbguids                @"KeyOfKbguids"



//
@interface WizAccountManager()
{
    NSString* activeAccountUserId_;
    NSTimer* timer;
}
@property (nonatomic, retain) NSTimer* timer;
@property (atomic, retain) NSString* activeAccountUserId_;
@end

@implementation WizAccountManager
@synthesize timer;
@synthesize activeAccountUserId_;
+ (id) shareManager;
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
    return [[self shareManager] retain];
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

@end
