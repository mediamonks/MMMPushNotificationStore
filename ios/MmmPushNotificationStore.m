#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(MMMPushNotificationStore, NSObject)

RCT_EXTERN_METHOD(loadNotifications:(NSString *)groupIdentifier withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(clearNotifications:(NSString *)groupIdentifier withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

@end
