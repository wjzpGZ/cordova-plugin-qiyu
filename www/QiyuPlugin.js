var exec = require('cordova/exec');

module.exports = {
    /**
     * 设置用户信息
     *
     * @example
     * <code>
     *   Qiyu.setUserInfo(
     *   {
	 *       userId：“1442286211167”,//APP 的用户 ID, 该 ID 能唯一标识一个用户即可，
	 *       authToken:"",//当且仅当开发者在管理后台开启了 authToken 校验功能时，该字段才有效。 用于校验用户 userId 真实性，如果 authToken 无效，此次设置用户信息的请求将无效。
	 *       data :[
     *               {"key":"real_name", "value":"土豪"},
     *               {"key":"mobile_phone", "hidden":true},
     *               {"key":"email", "value":"13800000000@163.com"},
     *               {"index":0, "key":"account", "label":"账号", "value":"zhangsan" , "href":"http://example.domain/user/zhangsan"},
     *               {"index":1, "key":"sex", "label":"性别", "value":"先生"},
     *               {"index":5, "key":"reg_date", "label":"注册日期", "value":"2015-11-16"},
     *                {"index":6, "key":"last_login", "label":"上次登录时间", "value":"2015-12-22 15:38:54"}
	 *              ]
     *   }, function () {
     *     alert("Success");
     *   }, function (reason) {
     *     alert("Failed: " + reason);
     *  });
     *</code>
     */
    setUserInfo: function (data,onSuccess, onError) {
        exec(onSuccess, onError, "Qiyu", "setUserInfo", [data]);
    },
    /**
     * 打开咨询聊天界面
     *
     * @example
     * <code>
     *   Qiyu.open(
     *      {
     *    title: "",// 聊天页面的title
     *    source: //  用户发起咨询的页面信息
     *    {
     *    uri: "",//咨询页面的uri，可以是url，也可以任意能标识来源的字符串
     *     title:"",//咨询页面的title
     *    custom:"",//可自定义传入的字符串，比如商品详细信息，用户操作状态等等, 在分配客服时该字段会传递给客服。
     *    groupId:123,//请求分配客服时，指定客服分组。
     *    staffId:123,//请求分配客服时，指定客服ID。如果指定了此参数，则groupId会被忽略。
     *    robotFirst:false,//如果指定了 groupId 或者 staffId 时，该参数有效。表示会先进机器人，之后如果用户转人工服务，再分配给上面指定的groupId 或者 staffId
     *    faqGroupId:123,//机器人热门问题组 ID 如果指定了此参数，且请求客服为机器人客服，则会下发该 ID 对应的热门问题。<br>
     *    shopId:"234234ae"//要咨询的商家 ID
     *    vipLevel:-1, //用户VIP等级
     *    },
     *    product:// 访客发起会话时所带的商品消息信息
     *    {
     *        show : 1, // 1为打开， 其他参数为隐藏（包括非零元素）
     *        title : '标题',
     *        desc : '商品描述',
     *        picture : '商品图片地址',
     *        note : '备注',
     *        url : '跳转链接',
	 *     	  alwaysSend : false
     *    },
     *      }
     *   , function () {
     *     alert("Success");
     *   }, function (reason) {
     *     alert("Failed: " + reason);
     *  });
     *</code>
     */
    open: function (data, onSuccess, onError) {
        exec(onSuccess, onError, "Qiyu", "open", [data]);
    },

    /**
     * 注销用户登录
     *
     * @example
     * <code>
     * Qiyu.logout(function (response) { alert(response.code); });
     * </code>
     */
    logout: function ( onSuccess, onError) {

        return exec(onSuccess, onError, "Qiyu", "logout",[]);
    },

};

