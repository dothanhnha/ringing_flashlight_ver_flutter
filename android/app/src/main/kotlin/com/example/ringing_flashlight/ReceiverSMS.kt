package com.example.ringing_flashlight

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.getSystemService


class ReceiverSMS  : BroadcastReceiver() {

    private fun flashLightOn(context: Context) {
        val cameraManager: CameraManager? = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager?
        try {
            val cameraId: String? = cameraManager?.getCameraIdList()?.get(0)
            cameraManager?.setTorchMode(cameraId, true)
            Log.d("cameranhadt",cameraId);
        } catch (e: CameraAccessException) {
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        flashLightOn(context);
        Log.d("nhadt receiver", MyService.getDoubleUserData(UserData.MESSAGE_SPEED).toString());
    }
}