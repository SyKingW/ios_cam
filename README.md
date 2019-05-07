# ios_cam  

ipcam   
支持vste、vstd

20171117  
Xcode8 权限的问题
针对Xcode8 对接异常http://www.jianshu.com/p/39184c765f73



20180724     
添加PnPCcam2，底层封装了vsnet.a库
底层实现获取串   

20190322    
更新vsnet.a修复TF 拖动问题    

20190423     
支持全景展开  
1.通过get_status.cgi得到correctModel 和installType值做设备机型的判断（考虑cgi文档）
2.实现化对象
FisheyeView* fishView;         //C60摄像机
FisheyeC61SView *fishC61SView; //C61s摄像机 






