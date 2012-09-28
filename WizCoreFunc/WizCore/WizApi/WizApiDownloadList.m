//
//  WIzApiDownloadList.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiDownloadList.h"

@interface WizApiDownloadList ()
{
    NSInteger currentVersion;
}
@end


@implementation WizApiDownloadList
@synthesize serverVersion;
- (int64_t) getNewVersion:(NSArray*)array
{
    int64_t newVer = 0;
    for (NSDictionary* dict in array)
    {
        NSString* verString = [dict valueForKey:@"version"];
        
        int64_t ver = [verString longLongValue];
        if (ver > newVer)
        {
            newVer = ver;
        }
    }
    return newVer;
}
- (NSInteger) getLocalVersion
{
    return 0;
}

- (NSString*) getMethodName
{
    return nil;
}
- (void)  updateLocaList:(NSArray*)list
{
    
}

- (void) updateLocalVersion:(int64_t)version
{
    
}
- (void) callDownloadList
{
    NSInteger localVersion = [self getLocalVersion];
    currentVersion = localVersion;
    if (self.serverVersion !=0 && localVersion >= self.serverVersion) {
        [super end];
        return;
    }
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    [postParams setObject:[NSNumber numberWithInt:[self listCount]] forKey:@"count"];
    
    [postParams setObject:[NSNumber numberWithInt:localVersion] forKey:@"version"];
    [self executeXmlRpcWithArgs:postParams methodKey:[self getMethodName]];
}

- (BOOL) start
{
    if (![super start]) {
        return NO;
    }
    //
    [self callDownloadList];
    return YES;
}


- (void) onDownloadList:(NSArray*)list
{
    [self updateLocaList:(NSArray*)list];
    int64_t version = [self getNewVersion:list];
    if (version > currentVersion) {
        [self updateLocalVersion:version];
        currentVersion = version;
        if (self.serverVersion !=0 && version >= self.serverVersion) {
            [self end];
        }
        [self callDownloadList];
    }
    else
    {
        [self end];
    }
}

- (void) xmlrpcDoneSucced:(id)retObject forMethod:(NSString *)method
{
    if ([method isEqualToString:[self getMethodName]]) {
        [self onDownloadList:retObject];
    }
}
@end
