/*
 *  obj_common.h
 *  IpCameraClient
 *
 *  Created by jiyonglong on 12-4-26.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */

#define STR_MAC "mac"
#define STR_NAME "name"
#define STR_IPADDR "ipaddr"
#define STR_PORT "port"
#define STR_USER "user"
#define STR_PWD "pwd"
#define STR_IMG "img"
#define STR_DID "did"
#define STR_PPPP_STATUS "ppppstatus"
#define STR_PPPP_MODE "ppppmode"
#define STR_AUTHORITY "authority"

#define STR_SSID "ssid"
#define STR_MAC "mac"
#define STR_SECURITY "security"
#define STR_DB0 "db0"
#define STR_CHANNEL "channel"

#define STR_LOCALIZED_FILE_NAME "IpCameraClient"

#define COLOR_BASE_RED  119.0
#define COLOR_BASE_GREEN 119.0
#define COLOR_BASE_BLUE 119.0

#define COLOR_HIGH_LIGHT_RED 120
#define COLOR_HIGH_LIGHT_GREEN 120
#define COLOR_HIGH_LIGHT_BLUE 120

#define COLOR_IMAGEVIEW_RED 255
#define COLOR_IMAGEVIEW_GREEN 160
#define COLOR_IMAGEVIEW_BLUE 0


#define BTN_NORMAL_RED 0
#define BTN_NORMAL_GREEN 0x4e
#define BTN_NORMAL_BLUE 0x93

#define BTN_DONE_RED 0x13
#define BTN_DONE_GREEN 0x45
#define BTN_DONE_BLUE 0x70

#define CELL_SEPERATOR_RED 220
#define CELL_SEPERATOR_GREEN 220
#define CELL_SEPERATOR_BLUE 220

//报警信息头
#define ALARM_INFO_PUT_ALARM_INFO   0x01//报警
#define ALARM_LINK_SNAP_PICTURE     0x02//抓图
#define ALARM_STATUS_INFO_RETURN    0x03//操作
#define ALARM_MOTION_INFO           0x04//移动侦测

#define STR_VERSION_NO "1.8.2"

typedef struct _STRU_REC_FILE_HEAD
{
    int head;
    int version;
    int videoformat;
    int audioformat;
    int reserved;
    char szosd[44];
    
}STRU_REC_FILE_HEAD, *PSTRU_REC_FILE_HEAD;

typedef struct _STRU_DATA_HEAD
{
    int head;
    int format;
    int dataformat;
    int datalen;
    int timestamp;
}STRU_DATA_HEAD,*PSTRU_DATA_HEAD;

typedef enum {
    CorrectModelD93 = 2,
    CorrectModelC60 = 3,
    CorrectModelC61S = 4,
    CorrectModelOther = 5,
}FactoryParamCorrectModel;

#define FactoryParamCorrectModelTag "FactoryParamCorrectModel"

