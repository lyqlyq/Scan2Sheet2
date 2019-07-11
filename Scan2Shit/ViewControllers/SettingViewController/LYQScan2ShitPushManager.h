
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#define LYQScan2Shit_AppStorePushKey @"c52662296f656ec6fdbd8d3a"

@interface LYQScan2ShitPushManager : NSObject
+ (LYQScan2ShitPushManager *)shareInstance;
//注册通知
- (void)LYQScan2Shit_ConfigerPushWithLaunchOptions:(NSDictionary *)launchOptions;
//注册deviceToken
- (void)LYQScan2Shit_RegisterToken:(NSData *)deviceToken;

@end

NS_ASSUME_NONNULL_END
