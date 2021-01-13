//
//  PTRIDFA.m
//  IDFA
//
//  Created by Tomas Roos on 22/07/16.
//  Copyright © 2016 Tomas Roos. All rights reserved.
//

#import "PTRIDFA.h"
#import <React/RCTUtils.h>
#import <UIKit/UIKit.h>
@import AdSupport;
@import AppTrackingTransparency;

@implementation PTRIDFA

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(getIDFA:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    /*
     if([self isAdvertisingTrackingEnabled]) {
     NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
     resolve([IDFA UUIDString]);
     } else {
     resolve(@"");
     }
     */
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                resolve(idfa);
            } else {
                resolve(@"");
                //NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
            }
        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            resolve(idfa);
        } else {
            resolve(@"");
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
}

- (BOOL) isAdvertisingTrackingEnabled {
    if (@available(iOS 14, *)) {
        return [ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusAuthorized;
    } else {
        return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    }
}

@end
