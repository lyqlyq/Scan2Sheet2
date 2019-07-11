
#import "LYQScan2ShitPushManager.h"
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface LYQScan2ShitPushManager ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) BOOL isNeedBoottomView;
@property (nonatomic, assign) CGFloat bottomViewHeight;
@end

@implementation LYQScan2ShitPushManager
static LYQScan2ShitPushManager *_LYQScan2Shit_MGR;

+ (LYQScan2ShitPushManager *)shareInstance
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _LYQScan2Shit_MGR = [[LYQScan2ShitPushManager alloc] init];
    });
    return _LYQScan2Shit_MGR;
}



- (void)LYQScan2Shit_ConfigerPushWithLaunchOptions:(NSDictionary *)launchOptions;
{
    
    [JPUSHService setupWithOption:launchOptions appKey:LYQScan2Shit_AppStorePushKey
                          channel:@"APPStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}
- (void)LYQScan2Shit_RegisterToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}
@end
