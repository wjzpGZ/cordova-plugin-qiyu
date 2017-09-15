
#import "Qiyu.h"
#import "QYSDK.h"

@interface Qiyu()
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSDictionary *userInfoDictionary;
@property (nonatomic, strong) NSString *userAvatarURLString;
@end

@implementation Qiyu
- (void)setUserInfo:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* result = nil;
    self.userInfoDictionary = command.arguments.firstObject;
    if (self.userInfoDictionary == nil) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"没有参数"];
    }else {
        self.userAvatarURLString = [self.userInfoDictionary objectForKey:@"avatar"];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)open:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    id argument = command.arguments.firstObject;
    if (nil == argument) {
         pluginResult  = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"调用open方法必须要传入参数"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    
    @try {
        
        //设置聊天窗口中用户的头像
        if (nil != self.userAvatarURLString) {
            [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = self.userAvatarURLString;
        }
        
        //设置用户信息
        QYUserInfo *userInfo = nil;
        if (nil != self.userInfoDictionary ) {
            if ([self.userInfoDictionary isKindOfClass:NSDictionary.class] == NO) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"UserInfo参数类型错误"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            
            userInfo = [[QYUserInfo alloc] init];
            userInfo.userId = [self.userInfoDictionary objectForKey:@"userId"];
            NSDictionary *userData = [self.userInfoDictionary objectForKey:@"data"];
            if (nil != userData) {
                if ([userData isKindOfClass:NSDictionary.class] == NO) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"UserData参数类型错误"];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    return;
                }
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:userData options:kNilOptions error:nil];
                if (nil != data) {
                    userInfo.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [[QYSDK sharedSDK] setUserInfo:userInfo];
                }
            }
        }
        
        if ([argument isKindOfClass:NSDictionary.class] == NO) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数类型错误"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            return;
        }
        
        //设置来源
        QYSource *source = nil;
        NSDictionary *s = [argument objectForKey:@"source"];
        if (nil != s) {
            if ([s isKindOfClass:NSDictionary.class] == NO) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"source参数类型错误"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            
            source = [[QYSource alloc] init];
            source.title =  [s objectForKey:@"title"];
            source.urlString = [s objectForKey:@"uri"];
            source.customInfo = [s objectForKey:@"custom"];
        }
        
      
        
        //设置商品信息
        QYCommodityInfo *commodityInfo = nil;
        NSDictionary *commodityDictionary = [argument objectForKey:@"product"];
        if (nil != commodityDictionary) {
            if ([commodityDictionary isKindOfClass:NSDictionary.class] == NO) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"product参数类型错误"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            
            commodityInfo.title = [commodityDictionary objectForKey:@"title"];
            commodityInfo.desc = [commodityDictionary objectForKey:@"desc"];
            commodityInfo.pictureUrlString = [commodityDictionary objectForKey:@"picture"];
            commodityInfo.note = [commodityDictionary objectForKey:@"note"];
            commodityInfo.urlString = [commodityDictionary objectForKey:@"url"];
        }
        
        NSString *appKey = [[self.commandDelegate settings] objectForKey:@"qiyu_app_key"];
        [[QYSDK sharedSDK] registerAppId:appKey appName:@"黔赞"];
        
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.sessionTitle = [argument objectForKey:@"title"];
        sessionViewController.source = source;
        sessionViewController.commodityInfo = commodityInfo;
        sessionViewController.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain
                                        target:self action:@selector(onBack)];
        
        self.navigationController =
        [[UINavigationController alloc] initWithRootViewController:sessionViewController];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.navigationController animated:YES completion:nil];

    } @catch (NSException *exception) {
        NSLog(@"[Qiyu]:%@",exception);
        NSString *message = [NSString stringWithFormat:@"App发生异常[%@]",exception.name];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    }
    
    if (nil != pluginResult) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logout:(CDVInvokedUrlCommand *)command
{
    [[QYSDK sharedSDK] logout:^(){
        NSLog(@"用户退出登录");
    }];
}

- (void)onBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
@end
