//
//  WizGroupSync.h
//  WizCore
//
//  Created by wiz on 12-9-20.
//  Copyright (c) 2012年 cn.wiz. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface WizGroupSync : NSObject
- (void) downloadWizObject:(WizObject*)wizObject;
- (void) uploadWizObject:(WizObject*)wizObject;
- (void) startSyncMeta;
- (void) stopSync;
@end
