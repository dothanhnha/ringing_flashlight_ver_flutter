package com.example.ringing_flashlight

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class ReceiverCall : BroadcastReceiver() {



    override fun onReceive(context: Context, intent: Intent) {
        Log.d("nhadt receiver", " call");
    }
}

