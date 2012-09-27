//
//  WizApiGetAllVersions.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiGetAllVersions.h"

@implementation WizApiGetAllVersions

@synthesize delegate;

- (void) dealloc
{
    delegate = nil;
    [super dealloc];
}
-(BOOL) start
{
    if (![super start]) {
        return NO;
    }
    //
    [self executeXmlRpcWithArgs:[NSMutableDictionary dictionary] methodKey:SyncMethod_GetAllObjectVersion];
    return YES;
}

- (void) xmlrpcDoneSucced:(id)retObject forMethod:(NSString *)method
{
    if ([method isEqualToString:SyncMethod_GetAllObjectVersion]) {
        [self.delegate didGetAllObjectVersions:retObject];
    }
}


@end
