// ReactNativeGetuiLatestModule.java

package com.reactlibrary;

import android.content.Context;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import com.igexin.sdk.PushManager;

public class ReactNativeGetuiLatestModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    private static ReactNativeGetuiLatestModule mModule;

    private static Context mContext;

    public ReactNativeGetuiLatestModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "ReactNativeGetuiLatest";
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }

    @Override
    public void initialize() {
        super.initialize();
        mModule = this;
    }

    @Override
    public void onCatalystInstanceDestroy() {
        super.onCatalystInstanceDestroy();
        mModule = null;
    }
    /**
     * 导入this指向
     */
    public static void setMainApplication(Context context){
        mContext = context;
    }
    /**
     * 初始化推送服务
     */
    public static void initPush(Context context){
        mContext = context;
        Logger.log("initPush, mContext = " + mContext);
        PushManager.getInstance().initialize(mContext);
    }
    /**
     * 启动sdk
     * @return 启动状态
     */
    @ReactMethod
    public void startSdk(Callback callback){
        Logger.log("will start getui-sdk");
        PushManager.getInstance().initialize(mContext);
        Boolean isStart = PushManager.getInstance().isPushTurnedOn(mContext);
        callback.invoke(isStart);
    }
    /**
     * 获取SDK的Cid
     *
     * @return Cid值
     */
    @ReactMethod
    public void clientId(Callback callback){
        String clientId = PushManager.getInstance().getClientid(mContext);
        Logger.log("clientId = " + clientId);
        callback.invoke(clientId);
    }

    @ReactMethod
    public void version(Callback callback){
        String version1 = PushManager.getInstance().getVersion(mContext);
        // Logger.log("clientId = " + clientId);
        callback.invoke(version1);
    }

    @ReactMethod
    public void isPushTurnedOn(Callback callback){
        Boolean isPushTurnedOn1 = PushManager.getInstance().isPushTurnedOn(mContext);
        // Logger.log("clientId = " + clientId);
        callback.invoke(isPushTurnedOn1);
    }
}
