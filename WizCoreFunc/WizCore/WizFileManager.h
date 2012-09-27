//
//  WizFileManger.h
//  Wiz
//
//  Created by MagicStudio on 12-4-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define EditTempDirectory   @"EditTempDirectory"

//const NSString*  DocumentFileIndexName = @"index.html";
//const NSString*  DocumentFileMobileName = @"wiz_mobile.html";
//const NSString*  DocumentFileAbstractName = @"wiz_abstract.html";
//const NSString*  DocumentFileFullName = @"wiz_full.html";


@interface WizFileManager : NSFileManager
+(NSString*) documentsPath;
+ (id) shareManager;
- (NSString*) accountPathFor:(NSString*)accountUserId;
- (NSString*) wizObjectFilePath:(NSString*)objectGuid           accountUserId:(NSString*)accountUserId;
- (NSString*) getDocumentFilePath:(NSString*)documentFileName   documentGUID:(NSString*)documentGuid    accountUserId:(NSString*)accountUserId;
//
- (NSString*) documentIndexFilesPath:(NSString*)documentGUID    accountUserId:(NSString*)accountUserId;
- (BOOL)      removeObjectPath:(NSString*)guid                  accountUserId:(NSString*)accountUserId;
- (long long) folderTotalSizeAtPath:(NSString*) folderPath;
//
- (NSString*) downloadObjectTempFilePath:(NSString*)objGuid accountUserId:(NSString*)userId;
- (BOOL)      unzipWizObjectData:(NSString*)ziwFilePath toPath:(NSString*)aimPath;
//
- (NSString*) uploadTempFile:(NSString*)objGuid accountUserId:(NSString*)userId;
-(NSString*)  createZipByPath:(NSString*)filesPath;
//
- (NSInteger) accountCacheSize:(NSString*)accountUserId;
//
-(BOOL) ensurePathExists:(NSString*)path;
-(BOOL) deleteFile:(NSString*)fileName;
//
- (NSString*) tempDataBatabasePath:(NSString*)accountUserId;
- (NSString*) metaDataBasePathForAccount:(NSString*)accountUserId   kbGuid:(NSString*)kbGuid;
- (NSString*) settingDataBasePath;
@end
