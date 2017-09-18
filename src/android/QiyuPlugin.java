package com.wjzp.cordova.qiyu;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.text.TextUtils;
import android.util.Log;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.qiyukf.unicorn.api.ConsultSource;
import com.qiyukf.unicorn.api.OnMessageItemClickListener;
import com.qiyukf.unicorn.api.ProductDetail;
import com.qiyukf.unicorn.api.RequestCallback;
import com.qiyukf.unicorn.api.SavePowerConfig;
import com.qiyukf.unicorn.api.StatusBarNotificationConfig;
import com.qiyukf.unicorn.api.UICustomization;
import com.qiyukf.unicorn.api.Unicorn;
import com.qiyukf.unicorn.api.YSFOptions;
import com.qiyukf.unicorn.api.YSFUserInfo;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * 七鱼插件.
 */
public class QiyuPlugin extends CordovaPlugin {
    private static final String TAG = "QiyuPlugin";
    private static final String QIYU_APP_KEY = "QIYU_APP_KEY";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d(TAG, "execute: " + action + "  args " + args.toString());
        if (action.equals("open")) {
            try {
                openServiceActivity(args, callbackContext);
            } catch (JSONException e) {
                e.printStackTrace();
                callbackContext.error("解析错误！");
            }
            return true;
        } else if (action.equals("setUserInfo")) {
            setUserInfo(args, callbackContext);
            return true;
        } else if (action.equals("logout")) {
            Unicorn.logout();
            QiyuPreferences.saveYsfUserAvatar("");
            Unicorn.updateOptions(options());
            return true;
        }
        return false;
    }

    /**
     * 设置用户信息
     *
     * @param args
     * @param callbackContext
     */
    private void setUserInfo(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (args.length() <= 0) {
            callbackContext.error("参数不能为空");
            return;
        }
        JSONObject object = args.getJSONObject(0);
        YSFUserInfo userInfo = new YSFUserInfo();
        userInfo.authToken = object.optString("authToken");
        userInfo.userId = object.getString("userId");
        if (object.has("data")) {
            JSONObject object1 = object.optJSONObject("data");
            if (object1 != null) {
                userInfo.data = object1.toString();

            } else {
                userInfo.data = object.optString("data");
            }
        }
        if (object.has("avatar")) {
            String avatar = object.optString("avatar", "");
            String loacalAvatar = QiyuPreferences.getYsfUserAvatar();
            if (!loacalAvatar.equals(avatar)) {
                QiyuPreferences.saveYsfUserAvatar(avatar);
            }
            Unicorn.updateOptions(options());
        }


        Unicorn.setUserInfo(userInfo, new RequestCallback<Void>() {
            @Override
            public void onSuccess(Void param) {
                callbackContext.success();
            }

            @Override
            public void onFailed(int code) {
                callbackContext.error(code);
            }

            @Override
            public void onException(Throwable exception) {
                onFailed(-1);
            }
        });
    }

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Context context = cordova.getActivity().getApplicationContext();
        Fresco.initialize(context);
        QiyuPreferences.init(context);
        String appKey = webView.getPreferences().getString(QIYU_APP_KEY, "");
        Unicorn.init(context, appKey, options(), new FrescoImageLoader(context));
    }

    private void openServiceActivity(JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (args.length() <= 0) {
            callbackContext.error("参数不能为空");
            return;
        }
        if (!Unicorn.isServiceAvailable()) {
            // 当前客服服务不可用
            if (isNetworkAvailable(cordova.getActivity())) {
                callbackContext.error("网络状况不佳，请重试。");
            } else {
                callbackContext.error("未成功绑定 AppKey 无法联系客服");
            }
            return;
        }

        JSONObject object = args.getJSONObject(0);
        String title = object.getString("title");

        JSONObject sourceJson = object.getJSONObject("source");

        String sourceUrl = sourceJson.getString("uri");
        String sourceTitle = sourceJson.getString("title");
        /**
         * 设置访客来源，标识访客是从哪个页面发起咨询的，用于客服了解用户是从什么页面进入。
         * 三个参数分别为：来源页面的url，来源页面标题，来源页面额外信息（可自由定义）。
         * 设置来源后，在客服会话界面的"用户资料"栏的页面项，可以看到这里设置的值。
         */
        ConsultSource source = new ConsultSource(sourceUrl, sourceTitle, sourceJson.optString("custom"));
        // 设置其他信息
        source.faqGroupId = sourceJson.optLong("faqGroupId");
        source.groupId = sourceJson.optLong("groupId");
        source.robotFirst = sourceJson.optBoolean("robotFirst");
        source.shopId = sourceJson.optString("shopId");
        source.vipLevel = sourceJson.optInt("vipLevel");
        source.staffId = sourceJson.optInt("staffId");

        // 设置商品信息
        if (object.has("product")) {
            JSONObject productJson = object.getJSONObject("product");
            ProductDetail.Builder builder = new ProductDetail.Builder();
            builder.setUrl(productJson.getString("url"));
            builder.setDesc(productJson.optString("desc"));
            builder.setNote(productJson.optString("note"));
            builder.setShow(productJson.optInt("show"));
            builder.setTitle(productJson.optString("title"));
            builder.setPicture(productJson.optString("picture"));
            builder.setAlwaysSend(productJson.optBoolean("alwaysSend"));
            source.productDetail = builder.create();
        }
        Unicorn.openServiceActivity(this.cordova.getActivity(), title, source);
        callbackContext.success();
    }

    private YSFOptions options() {
        YSFOptions options = new YSFOptions();
        options.statusBarNotificationConfig = new StatusBarNotificationConfig();
        options.savePowerConfig = new SavePowerConfig();
        String avatar = QiyuPreferences.getYsfUserAvatar();
        if (!TextUtils.isEmpty(avatar)) {
            options.uiCustomization = new UICustomization();
            options.uiCustomization.rightAvatar = avatar;
        }
        options.onMessageItemClickListener = new OnMessageItemClickListener() {
            @Override
            public void onURLClicked(Context context, String url) {

            }
        };

        return options;
    }

    public static boolean isNetworkAvailable(Context context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivityManager != null) {
            NetworkInfo[] allNetworkInfo = connectivityManager.getAllNetworkInfo();
            if (allNetworkInfo != null) {
                for (NetworkInfo networkInfo : allNetworkInfo) {
                    if (networkInfo.getState() == NetworkInfo.State.CONNECTED) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

}
