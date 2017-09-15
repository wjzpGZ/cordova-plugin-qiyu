# wjzp-cordova-qiyu

A cordova plugin, a JS version of Qiyu SDK


# Install

1. ```cordova plugin add url  --variable QIYU_APP_KEY=YOUR_QIYU_APPID```, or using [plugman](https://npmjs.org/package/plugman), [phonegap](https://npmjs.org/package/phonegap), [ionic](http://ionicframework.com/)
   ``` cordova plugin add QiyuPlugin  --variable QIYU_APP_KEY=ba19873656bb36c98c6e81c90923069d```
2. ```cordova build ios``` or ```cordova build android```


# Usage

##  设置用户信息
```Javascript
    Qiyu.setUserInfo(
            {
            userId : '1442286211167',
	        authToken:"",
            avatar :"http://www.jf258.com/uploads/2015-05-16/082449359.jpg",
            data :[
                {"key":"real_name", "value":"土豪"},
                {"key":"mobile_phone", "hidden":true},
                {"key":"email", "value":"13800000000@163.com"},
                {"key":"avatar", "value": "http://www.jf258.com/uploads/2015-05-16/082449359.jpg"},
                {"index":0, "key":"account", "label":"账号", "value":"zhangsan" , "href":"http://example.domain/user/zhangsan"},
                {"index":1, "key":"sex", "label":"性别", "value":"先生"},
                {"index":5, "key":"reg_date", "label":"注册日期", "value":"2015-11-16"},
                {"index":6, "key":"last_login", "label":"上次登录时间", "value":"2015-12-22 15:38:54"}
        ]
        },function () {
            alert(" setUser  Success")
        },function (msg) {
            alert(msg);
        });
```
## 注销用户信息
```Javascript
    Qiyu.logout();

```

## 打开聊天界面
```Javascript
 Qiyu.open(
            {
                title: "在线客服",
                source: {
                    uri: "www.baidu.com",//咨询页面的uri，可以是url，也可以任意能标识来源的字符串
                    title: "Iphone X 预定",//咨询页面的title
                    custom: "Iphone X 预定",//可自定义传入的字符串，比如商品详细信息，用户操作状态等等, 在分配客服时该字段会传递给客服。
                    //   groupId:123,//请求分配客服时，指定客服分组。
                    //   staffId:123,//请求分配客服时，指定客服ID。如果指定了此参数，则groupId会被忽略。
                    // robotFirst:false,//如果指定了 groupId 或者 staffId 时，该参数有效。表示会先进机器人，之后如果用户转人工服务，再分配给上面指定的groupId 或者 staffId
                    //faqGroupId: 123,//机器人热门问题组 ID 如果指定了此参数，且请求客服为机器人客服，则会下发该 ID 对应的热门问题。<br>
                    //shopId: "234234ae",//要咨询的商家 ID
                    //vipLevel: -1, //用户VIP等级
                },
                product: // 访客发起会话时所带的商品消息信息
                {
                    show: 1, // 1为打开， 其他参数为隐藏（包括非零元素）
                    title: 'iPhone X 来了',
                    desc: 'iPhone X 来了',
                    picture: 'https://store.storeimages.cdn-apple.com/8750/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone/x/iphone-x-select-2017_FMT_WHH?wid=290&hei=574&fmt=png-alpha&qlt=95&.v=1504378257986',
                    note: '备注',
                    url: 'https://www.apple.com/cn/shop/buy-iphone/iphone-x',

                }
            },function () {
            console.log( " Success ");
        },function (msg) {
            alert(msg);
        });
```

