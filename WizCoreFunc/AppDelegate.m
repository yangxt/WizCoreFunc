//
//  AppDelegate.m
//  WizCoreFunc
//
//  Created by wiz on 12-9-26.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import "AppDelegate.h"

#import "WizApiClientLogin.h"
#import "WizApiRefreshGroups.h"
#import "WizApiDownloadDeletedGuids.h"

#import "WizApiDownloadDocumentList.h"

#import "WizDownloadObject.h"

#import "WizUploadObject.h"


@interface AppDelegate () <WizApiLoginDelegate>
{
    
}
@end

@implementation AppDelegate


- (void) didClientLoginFaild:(NSError *)error
{
    
}

- (void) didClientLoginSucceed:(NSString *)accountUserId retObject:(id)ret
{
    
    NSString* kbguid = [ret objectForKey:@"kb_guid"];
    
    id<WizMetaDataBaseDelegate> db = [[WizDbManager shareInstance] getMetaDataBaseForAccount:accountUserId kbGuid:kbguid];
    WizDocument* doc = [db documentFromGUID:@"c56e99f2-3948-4a80-8568-e11106642336"];
    
    WizUploadObject* downloadDeletedGuids = [[WizUploadObject alloc] init];
    downloadDeletedGuids.kbGuid = kbguid;
    downloadDeletedGuids.accountUserId = accountUserId;
    downloadDeletedGuids.uploadObject = doc;
    
    [downloadDeletedGuids start];
    
}
- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    WizApiClientLogin* clientLogin = [[WizApiClientLogin alloc] init];
    clientLogin.accountUserId= @"yishuiliunian@gmail.com";
    clientLogin.password = @"654321";
    clientLogin.delegate = self;
    [clientLogin start];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
