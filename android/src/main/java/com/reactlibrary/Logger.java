package com.reactlibrary;

import android.util.Log;

public class Logger {

    public static boolean ENABLE = true;

    public static final String TAG = "Logger";

    public static void log(String message){
        if (ENABLE){
            Log.d(TAG, message);
        }
    }
}
