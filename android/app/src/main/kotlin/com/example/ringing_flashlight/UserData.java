package com.example.ringing_flashlight;

public class UserData {

    static final String CALL_SPEED = "D_CALL_SPEED";
    static final String NOTIF_SPEED = "D_NOTIF_SPEED";
    static final String NOTIF_STROBE = "I_NOTIF_STROBE";
    static final String MESSAGE_SPEED = "D_MESSAGE_SPEED";
    static final String MESSAGE_STROBE = "I_MESSAGE_STROBE";
    static final String SETTING_PERCENT = "D_SETTING_PERCENT";
    static final String SETTING_TIME_TO = "S_SETTING_TIME_TO";
    static final String SETTING_TIME_FROM = "S_SETTING_TIME_FROM";
    static final String SETTING_BATTERY_MODE = "B_SETTING_BATTERY_MODE";
    static final String SETTING_TIME_MODE = "B_SETTING_TIME_MODE";
    static final String INCOMING_CALL_MODE = "B_INCOMING_CALL_MODE";
    static final String NOTIF_MODE = "B_NOTIF_MODE";
    static final String MESSAGE_MODE = "B_MESSAGE_MODE";
    static final String LIST_PACKAGE_NAME_CHECKED = "SL_LIST_PACKAGE_NAME_CHECKED";
    
    String key;
    String value;

    public UserData(String key, String value) {
        this.key = key;
        this.value = value;
    }
}
