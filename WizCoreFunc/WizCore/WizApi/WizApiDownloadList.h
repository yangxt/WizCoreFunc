//
//  WIzApiDownloadList.h
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApi.h"

@interface WizApiDownloadList : WizApi
@property (nonatomic, assign)    NSInteger serverVersion;
- (NSInteger) getLocalVersion;
- (NSString*) getMethodName;
- (void)  updateLocaList:(NSArray*)list;
- (void) updateLocalVersion:(int64_t)version;
@end
