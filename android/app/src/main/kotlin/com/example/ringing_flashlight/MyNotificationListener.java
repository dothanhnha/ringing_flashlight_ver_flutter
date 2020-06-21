package com.example.ringing_flashlight;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;

public class MyNotificationListener extends NotificationListenerService {

    public static String TAG = MyNotificationListener.class.getSimpleName();

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        Log.d("nhadt receiver", " call");

    }

}
