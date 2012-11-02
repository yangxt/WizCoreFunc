//
//  WizApiUploadTags.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-27.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "WizApiUploadTags.h"

@implementation WizApiUploadTags

- (void) callUploadTags
{
    id<WizMetaDataBaseDelegate> db = [self groupDataBase];
    
    NSArray* tagList = [db tagsForUpload];
    if (0 == [tagList count]) {
        [self end];
        return;
    }
    
    NSMutableArray* tagTemp = [[NSMutableArray alloc] initWithCapacity:[tagList count]];
    for(WizTag* each in tagList)
    {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:each.strGuid forKey:@"tag_guid"];
        if(nil !=each.strParentGUID)
            [dic setObject:each.strParentGUID forKey:@"tag_group_guid"];
        [dic setObject:each.strTitle forKey:@"tag_name"];
        [dic setObject:each.description forKey:@"tag_description"];
        [dic setObject:each.dateInfoModified forKey:@"dt_info_modified"];
        [tagTemp addObject:dic];
        [dic release];
        
    }
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    [postParams setObject:tagTemp forKey:@"tags"];
    [tagTemp release];
    [self executeXmlRpcWithArgs:postParams methodKey:SyncMethod_PostTagList needToken:YES];
}

- (void) onUploadTags
{
    id <WizMetaDataBaseDelegate> db = [self groupDataBase];
    NSArray* tags = [db tagsForUpload];
    for (WizTag* each in tags) {
        [db setTagLocalChanged:each.strGuid changed:NO];
    }
    [self end];
}
- (BOOL) start
{
    if (![super start]) {
        return NO;
    }
    [self callUploadTags];
    return YES;
}

- (void) xmlrpcDoneSucced:(id)retObject forMethod:(NSString *)method
{
    if ([method isEqualToString:SyncMethod_PostTagList]) {
        [self onUploadTags];
    }
}
@end
