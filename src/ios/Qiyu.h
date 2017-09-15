#import <Cordova/CDV.h>

@interface Qiyu : CDVPlugin

- (void)setUserInfo:(CDVInvokedUrlCommand *)command;
- (void)open:(CDVInvokedUrlCommand *)command;
- (void)logout:(CDVInvokedUrlCommand *)command;

@end
