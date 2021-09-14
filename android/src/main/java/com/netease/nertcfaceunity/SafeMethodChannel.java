/*
 * Copyright (c) 2014-2020 NetEase, Inc.
 * All right reserved.
 */

package com.netease.nertcfaceunity;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public final class SafeMethodChannel {
    final private MethodChannel methodChannel;
    final private Handler handler = new Handler(Looper.getMainLooper());

    public SafeMethodChannel(BinaryMessenger messenger, String name) {
        this.methodChannel = new MethodChannel(messenger, name);
    }

    public void invokeMethod(@NonNull String method, @Nullable Object arguments) {
        runOnMainThread(() -> methodChannel.invokeMethod(method, arguments));
    }

    public void setMethodCallHandler(final @Nullable MethodChannel.MethodCallHandler handler) {
        runOnMainThread(() -> methodChannel.setMethodCallHandler(handler));
    }

    private void runOnMainThread(Runnable runnable) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable.run();
        } else {
            handler.post(runnable);
        }
    }
}
