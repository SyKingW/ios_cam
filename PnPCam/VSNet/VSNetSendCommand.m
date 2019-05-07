//
//  VSNetSendCommand.m
//  Eye4
//
//  Created by 莫晓文 on 16/6/27.
//  Copyright © 2016年 莫晓文. All rights reserved.
//

#import "VSNetSendCommand.h"
#import "VSNet.h"

@implementation VSNetSendCommand
//设置设备的日期时间
/*
 did: 设备UID
 now: 表示从 1970-1-1 0:0:0 到指定时间所流逝的秒数，如附加该参数，设备则依据此时间进行校时
 tz: 时区设置
 ntp:表示 ntp 校时 0:禁止 1:允许
 ntp_svr:ntp 服务器地址
 */
+ (void) VSNetCommandSetDateTime:(NSString*) did
                          isNow :(NSInteger) now
                        timeZone:(NSInteger) tz
                             npt:(NSInteger) ntp
                       netServer:(NSString*)server
{ 
    
    NSString*  cmd = nil;
    if (now)
    {
        cmd = [NSString stringWithFormat:@"set_datetime.cgi?now=%ld&tz=%ld&ntp_enable=%ld&ntp_svr=%@&" , (long)now , (long)tz , (long)ntp , server];
    }
    else
    {
        cmd = [NSString stringWithFormat:@"set_datetime.cgi?tz=%ld&ntp_enable=%ld&ntp_svr=%@&" , (long)tz , (long)ntp , server];
    }
    
    [[VSNet shareinstance] sendCgiCommand:cmd withIdentity:did];
}

+ (void) VSNetCommandSetSensorStatusWithDID:(NSString *)did
                                        cmd:(NSInteger )cmd
                                   doorbell:(NSInteger )doorbell
                                       user:(NSString *)user
                                   password:(NSString *)pwd
{
    NSString *command = [NSString stringWithFormat:@"set_sensorstatus.cgi?cmd=%ld&doorbell=%ld&loginuse=%@&loginpas=%@&",(long)cmd,(long)doorbell,user,pwd];
    
    [[VSNet shareinstance] sendCgiCommand:command withIdentity:did];
}

+ (void)VSNetCommandGetRecordFileWithDID:(NSString *)did
                                    user:(NSString *)user
                                     pwd:(NSString *)pwd
                                loginuse:(NSString *)loginuse
                                loginpas:(NSString *)loginpas
                                pageSize:(NSInteger )pageSize
                               pageIndex:(NSInteger )pageIndex
{
    NSString *cmd = [NSString stringWithFormat:@"get_record_file.cgi?loginuse=%@&loginpas=%@&user=%@&pwd=%@&PageSize=%ld&PageIndex=%ld",user,pwd,loginuse,loginpas,(long)pageSize,(long)pageIndex];
    

    [[VSNet shareinstance] sendCgiCommand:cmd withIdentity:did];
}


+ (void)VSNetCommandPlayVedioWithStreamid:(NSInteger)streamid
                                     user:(NSString *)user
                                      pwd:(NSString *)pwd
                                 loginuse:(NSString *)loginuse
                                 loginpas:(NSString *)loginpas
                                    audio:(NSInteger)audio
                                      res:(NSInteger)res
                                substream:(NSInteger)substream
                                 filename:(NSString *)filename
                                   offset:(NSInteger )offset
                                      did:(NSString *)did
{
    NSString *cmd = [NSString stringWithFormat:@"livestream.cgi?streamid=%ld&user=%@&pwd=%@&loginuse=%@&loginpas=%@&audio=%ld&res=%ld&substream=%ld&filename=%@&offset=%ld&",(long)streamid,user,pwd,loginuse,loginpas,audio,res,substream,filename,(long)offset];
    

    
    [[VSNet shareinstance] sendCgiCommand:cmd withIdentity:did];

}


@end
