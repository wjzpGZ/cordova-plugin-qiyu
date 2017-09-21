
/*
 集成:
 此插件使用的智齿SDK版本未2.3.0
 
 安装插件后,需要在工程中集成“智齿”SDK。请参考文档:https://dev.help.sobot.com/chapter1/ios-sdk-jie-ru.html 进行集成。
 推荐使用cocoapods进行集成。
 */

#import "Qiyu.h"
#import <SobotKit/SobotKit.h>


@interface Qiyu()
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSDictionary *userInfoDictionary;
@end

@implementation Qiyu
- (void)setUserInfo:(CDVInvokedUrlCommand *)command
{
    NSLog(@"[智齿]方法:setUserInfo, 参数:%@",command.arguments.firstObject);

    CDVPluginResult* result = nil;
    self.userInfoDictionary = command.arguments.firstObject;
    if (self.userInfoDictionary == nil) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"没有参数"];
    }else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)open:(CDVInvokedUrlCommand *)command
{
    @try {
        NSLog(@"[智齿]方法:open, 参数:%@",command.arguments.firstObject);
        
        ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
        initInfo.appKey = @"d410160e7f194a38b3574a11d8ca0938";
        
        //设置用户信息
        if (nil != self.userInfoDictionary && self.userInfoDictionary.count > 0) {
            @try{
                initInfo.userId = self.userInfoDictionary[@"partnerId"];
                initInfo.phone = self.userInfoDictionary[@"tel"];
                initInfo.email = self.userInfoDictionary[@"email"];
                initInfo.nickName = self.userInfoDictionary[@"uname"];
                initInfo.realName = self.userInfoDictionary[@"realname"];
                initInfo.avatarUrl = self.userInfoDictionary[@"face"];
                initInfo.weiBo = self.userInfoDictionary[@"weibo"];
                initInfo.weChat = self.userInfoDictionary[@"weixin"];
                initInfo.qqNumber = self.userInfoDictionary[@"qq"];
                initInfo.userSex = self.userInfoDictionary[@"sex"];
                initInfo.userBirthday = self.userInfoDictionary[@"birthday"];
                initInfo.userRemark = self.userInfoDictionary[@"remark"];
                initInfo.customInfo = self.userInfoDictionary[@"params"];
            }@catch(NSException *e) {
                NSLog(@"[智齿]设置用户信息异常:\n%@",e);
            }
        }
        
        CDVPluginResult* result = nil;
        
        NSDictionary *openArgument = command.arguments.firstObject;
        if (nil == openArgument ) {
            initInfo = nil;
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"没有参数"];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            NSLog(@"[智齿]%@",@"没有使用参数调用open接口");
            return;
        }
        
        //设置来源
        NSDictionary *sourceArgument = [openArgument objectForKey:@"source"];
        if (nil != sourceArgument  && sourceArgument.count > 0) {
            @try {
                initInfo.sourceURL = [sourceArgument objectForKey:@"uri"];
                initInfo.sourceTitle = [sourceArgument objectForKey:@"title"];
            }@catch(NSException *e) {
                NSLog(@"[智齿]设置来源异常:\n%@",e);
            }
        }else {
            NSLog(@"[智齿]未设置来源");
        }
        
        //配置UI
        ZCKitInfo *uiInfo= [ZCKitInfo new];
        uiInfo.customBannerColor = [UIColor colorWithRed:233.0/255.0 green:69.0/255.0 blue:63.0/255.0 alpha:1.0];
        uiInfo.imagePickerColor = uiInfo.customBannerColor;
        uiInfo.socketStatusButtonBgColor = uiInfo.customBannerColor;
        uiInfo.isOpenRecord = YES;
        uiInfo.isShowNickName = YES;
        
        //设置商品信息
        ZCProductInfo *productInfo = nil;
        NSDictionary *productArgument = [openArgument objectForKey:@"product"];
        if (nil != productArgument && productArgument.count > 0) {
            @try {
                productInfo = [ZCProductInfo new];
                productInfo.thumbUrl = [productArgument objectForKey:@"picture"];
                productInfo.title = [productArgument objectForKey:@"title"];
                productInfo.desc = [productArgument objectForKey:@"desc"];
                productInfo.label = [productArgument objectForKey:@"note"];
                productInfo.link = [productArgument objectForKey:@"url"];
                uiInfo.productInfo = productInfo;
            }@catch(NSException *e) {
                NSLog(@"[智齿]设置产品信息异常:\n%@",e);
            }
        }else {
            NSLog(@"[智齿]未设置商品信息");
        }
        
        UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
        [ZCSobot startZCChatView:uiInfo with:viewController target:nil pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
            // 点击返回
            if(type==ZCPageBlockGoBack){
                NSLog(@"点击了关闭按钮");
            }
            
            // 页面UI初始化完成，可以获取UIView，自定义UI
            if(type==ZCPageBlockLoadFinish){
                
            }
        } messageLinkClick:^(NSString *link){
            NSLog(@"[智齿]点击链接:%@息",link);
        }];
    }@catch(NSException *e) {
        NSLog(@"[智齿]调用open方法异常:\n%@",e);
    }
}

- (void)logout:(CDVInvokedUrlCommand *)command
{
    NSLog(@"[智齿]方法:logout:, 参数:%@",command.arguments.firstObject);
}

@end
