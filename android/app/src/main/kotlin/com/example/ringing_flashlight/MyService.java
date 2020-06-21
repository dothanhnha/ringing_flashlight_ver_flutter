package com.example.ringing_flashlight;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraManager;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import java.util.ArrayList;
import java.util.List;

public class MyService extends Service {
    static final String FIELD_ACTION = "FIELD_ACTION";
    static final String CALL_ACTION = "android.intent.action.PHONE_STATE";
    static final String SMS_ACTION = "android.provider.Telephony.SMS_RECEIVED";
    static final String FIELD_IS_ACTIVE = "FIELD_IS_ACTIVE";
    public static List<UserData> userData = new ArrayList<>();
    public static final String CHANNEL_ID = "ForegroundServiceChannel";
    private ReceiverCall receiverCall;
    private ReceiverSMS receiverSMS;

    @Override
    public void onCreate() {
        super.onCreate();

        createNotificationChannel();
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,
                0, notificationIntent, 0);
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Foreground Service")
                .setContentText("test")
                .setContentIntent(pendingIntent)
                .build();

        IntentFilter filter = new IntentFilter();
        this.receiverCall = new ReceiverCall();
        registerReceiver(this.receiverCall, filter);

        startForeground(1, notification);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
//        filter.addAction("android.provider.Telephony.SMS_RECEIVED");
//        filter.addAction("android.intent.action.PHONE_STATE");
        String action = intent.getStringExtra(FIELD_ACTION);
        boolean isActive = intent.getBooleanExtra(FIELD_IS_ACTIVE, false);
        IntentFilter filter = new IntentFilter();
        filter.addAction(action);
        if (isActive) {
            register(filter, action);
        } else {
            unregister(action);
        }
        return START_NOT_STICKY;
    }

    private void unregister(String action) {
        switch (action) {
            case CALL_ACTION:
                unregisterReceiver(this.receiverCall);
                break;
            case SMS_ACTION:
                unregisterReceiver(this.receiverSMS);
                break;
        }
    }

    private void register(IntentFilter filter, String action) {
        switch (action) {
            case CALL_ACTION:
                this.receiverCall = new ReceiverCall();
                registerReceiver(this.receiverCall, filter);
                break;
            case SMS_ACTION:
                this.receiverSMS = new ReceiverSMS();
                registerReceiver(this.receiverSMS, filter);
                break;
        }
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "Foreground Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    public static void saveUserData(String key, String value){
        String[] keySplited = key.split("_");
        for(UserData item: MyService.userData){
            if(item.key.equals(key)){
                item.value = value;
                return;
            }
        }
        MyService.userData.add(new UserData(key,value));
    }

    public static int getIntUserData(String key){
        for(UserData record : MyService.userData){
            if(record.key.equals(key)){
                return Integer.parseInt(record.value);
            }
        }
        return 0;
    }

    public static double getDoubleUserData(String key){
        for(UserData record : MyService.userData){
            if(record.key.equals(key)){
                return Double.parseDouble(record.value);
            }
        }
        return 0;
    }

    public static boolean getBoolUserData(String key){
        for(UserData record : MyService.userData){
            if(record.key.equals(key)){
                return Boolean.parseBoolean(record.value);
            }
        }
        return false;
    }

    public static String getStringUserData(String key){
        for(UserData record : MyService.userData){
            if(record.key.equals(key)){
                return record.value;
            }
        }
        return null;
    }

    public static List<String> getListStringUserData(String key){
        List<String> result = new ArrayList<>();
        for(UserData record : MyService.userData){
            String[] keySplitted = record.key.split("_");
            if((keySplitted[0]+'_'+keySplitted[1]).equals(key)){
                result.add(record.value);
            }
        }
        return result;
    }


    public void flashLightOn() {
        CameraManager cameraManager = (CameraManager) getSystemService(Context.CAMERA_SERVICE);

        try {
            String cameraId = cameraManager.getCameraIdList()[0];
            cameraManager.setTorchMode(cameraId, true);
        } catch (CameraAccessException e) {
        }
    }

}
