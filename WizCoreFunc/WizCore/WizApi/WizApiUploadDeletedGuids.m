//
//  WizApiUploadDeletedGuids.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-27.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiUploadDeletedGuids.h"

@implementation WizApiUploadDeletedGuids

- (void) callUploadDeletedGuids
{
    
    id<WizMetaDataBaseDelegate> db = [self groupDataBase];
    NSArray* deleteGuids = [db deletedGUIDsForUpload];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    NSMutableArray* deletedArray = [NSMutableArray array];
    if ([deletedArray count] == 0) {
        [self end];
        return;
    }
    for (id deletedGuid in deleteGuids) {
        if ([deletedGuid isKindOfClass:[WizDeletedGUID class]]) {
            WizDeletedGUID* deletedObject = (WizDeletedGUID*)deletedGuid;
            
            NSMutableDictionary* deletedObjectDic = [NSMutableDictionary dictionaryWithCapacity:3];
            [deletedObjectDic setObject:deletedObject.strGuid forKey:@"deleted_guid"];
            [deletedObjectDic setObject:deletedObject.strType forKey:@"guid_type"];
            [deletedObjectDic setObject:[deletedObject.dateDeleted dateFromSqlTimeString]  forKey:@"dt_deleted"];
            
            [deletedArray addObject:deletedObjectDic];
        }
    }
    [postParams setObject:deletedArray forKey:@"deleteds"];
    [self executeXmlRpcWithArgs:postParams methodKey:SyncMethod_UploadDeletedList];
}
- (BOOL) start
{
    if (![super start]) {
        return NO;
    }
    //
    [self callUploadDeletedGuids];
    return YES;
}

- (void) onUploadDeletedGuids:(id)retObject
{
    id<WizMetaDataBaseDelegate> db = [self groupDataBase];
    [db clearDeletedGUIDs];
    [self end];
}

- (void) xmlrpcDoneSucced:(id)retObject forMethod:(NSString *)method
{
    if ([method isEqualToString:SyncMethod_UploadDeletedList]) {
        [self onUploadDeletedGuids:retObject];
    }
}
@end
