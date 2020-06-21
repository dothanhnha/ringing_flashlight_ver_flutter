package com.example.ringing_flashlight;

import android.content.Context;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraManager;
import android.os.CountDownTimer;

public class FlashLight {
    static boolean isRunning = false;

    private void flashLightOn(Context context, double speed, int strobes) {
        CameraManager cameraManager = (CameraManager) context.getSystemService(Context.CAMERA_SERVICE);
//        try {
//            String cameraId = cameraManager.getCameraIdList()[0];
//            CountDownTimer countDown = new CountDownTimer(30000, 1000) {
//
//                public void onTick(long millisUntilFinished) {
//                    cameraManager.setTorchMode(cameraId, true);
//                }
//
//                public void onFinish() {
//                    mTextField.setText("done!");
//                }
//            };
//
//        } catch (CameraAccessException e) {
//        }
    }
}
