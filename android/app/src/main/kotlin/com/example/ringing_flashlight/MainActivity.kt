package com.example.ringing_flashlight

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val REQUEST_SETTING = 123
    private val CHANNEL = "samples.flutter.dev/service"
    var isFromSettingActivity:Boolean = false



    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "runService") {
                runService(call.argument<String>("action"),call.argument<Boolean>("isActive"))
            }else if (call.method == "pushDataUserToService") {
                pushDataUserToService(call.argument<String>("key"),call.argument<String>("value"))
            }
            else if (call.method == "openSettingActivity") {
                openSettingActivity()
            }
            else if (call.method == "checkIsFromSettingActivity") {
                checkIsFromSettingActivity()
            }else {
                result.notImplemented()
            }
        }
    }

    fun runService(action: String?, isActive: Boolean?) {
        Intent(this, MyService::class.java).also { intent ->
            intent.putExtra(MyService.FIELD_ACTION,action);
            intent.putExtra(MyService.FIELD_IS_ACTIVE,isActive);
            startForegroundService(intent)
        }
    }

    fun pushDataUserToService(key:String?, value: String?) {
        MyService.saveUserData(key,value);
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == REQUEST_SETTING){
            isFromSettingActivity = true;
        }
    }

    fun checkIsFromSettingActivity(): Boolean {
        return isFromSettingActivity
    }

    fun openSettingActivity(){
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        val uri: Uri = Uri.fromParts("package", packageName, null)
        intent.data = uri
        startActivityForResult(intent,REQUEST_SETTING)
        while(!isFromSettingActivity){
        }
        isFromSettingActivity = false;
    }

}
