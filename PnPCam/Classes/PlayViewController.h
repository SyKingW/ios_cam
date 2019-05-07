//
//  PlayViewController.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "PPPPStatusProtocol.h"
//#import "PPPPChannelManagement.h"
//#import "ParamNotifyProtocol.h"
//#import "ImageNotifyProtocol.h"
#import "PicPathManagement.h"

#import "RecPathManagement.h"
#import "NotifyEventProtocol.h"
#import "MyGLViewController.h"
#import "PopupListComponent.h"
#import "FPPopoverController.h"
#import "DemoTableController.h"
#import "Split-screenViewController.h"
#import "CameraListMgt.h"
#import "CustomToolBar.h"
#import "VSNetProtocol.h"
#import "vsFisheye.h"

@interface PlayViewController : UIViewController <UINavigationBarDelegate,FPPopoverControllerDelegate,PopupListComponentDelegate,UIScrollViewDelegate,CustomToolBarItemDelegate,VSNetDataProtocol,VSNetStatueProtocol,VSNetControlProtocol>
{
    IBOutlet UIImageView *imgView;
    IBOutlet UIActivityIndicatorView *progressView;
    IBOutlet UILabel *LblProgress;
    IBOutlet UIToolbar *playToolBar;
    IBOutlet UIBarButtonItem *btnItemResolution;
    IBOutlet UIBarButtonItem *btnTitle;
    IBOutlet UILabel *timeoutLabel;
    IBOutlet UIToolbar *toolBarTop;
    IBOutlet UIBarButtonItem *btnUpDown;
    IBOutlet UIBarButtonItem *btnLeftRight;
    IBOutlet UIBarButtonItem *btnUpDownMirror;
    IBOutlet UIBarButtonItem *btnLeftRightMirror;
    IBOutlet UIBarButtonItem *btnAudioControl;
    IBOutlet UIBarButtonItem *btnTalkControl;
    IBOutlet UIBarButtonItem *btnSetContrast;
    IBOutlet UIBarButtonItem *btnSetBrightness;
    //IBOutlet UIBarButtonItem *btnSwitchDisplayMode;//
    IBOutlet UIBarButtonItem *btnRecord;
    IBOutlet UIBarButtonItem *btnStop;
    
    IBOutlet UIImageView *imageUp;
    IBOutlet UIImageView *imageDown;
    IBOutlet UIImageView *imageLeft;
    IBOutlet UIImageView *imageRight;
    
    IBOutlet UIBarButtonItem *btnSnapshot;
    
    
    UILabel *labelContrast;
    UISlider *sliderContrast;
    UILabel *labelBrightness;
    UISlider *sliderBrightness;
    UIImage *imgVGA;
    UIImage *imgQVGA;
    UIImage *img720P;
    UIImage *imgNormal;
    UIImage *imgEnlarge;
    UIImage *imgFullScreen;
    UIImage *ImageBrightness;
    UIImage *ImageContrast;
    NSString *cameraName;
    NSString *strDID;
    UIImage *imageSnapshot;
    NSTimer* timer;
    CGSize labelsize;
    CGPoint beginPoint;
    int m_Contrast;
    int m_Brightness;
    BOOL bGetVideoParams;
    BOOL bPlaying;
    BOOL bManualStop;
    BOOL bCameramark;
    UIImageView* _cameramarkimgView;
    //CPPPPChannelManagement *m_pPPPPChannelMgt;
    int nResolution;
    UILabel *OSDLabel;
    UILabel *TimeStampLabel;
    NSTimer* timeStampTimer;
    NSInteger nUpdataImageCount;
    NSTimer *timeoutTimer;
    BOOL m_bAudioStarted;
    BOOL m_bTalkStarted;
    BOOL m_bGetStreamCodecType;
    int m_StreamCodecType;
    int m_nP2PMode;
    int m_nTimeoutSec;
    BOOL m_bToolBarShow;
    BOOL m_bPtzIsUpDown;
    BOOL m_bPtzIsLeftRight;
    BOOL m_bUpDownMirror;
    BOOL m_bLeftRightMirror;
    int m_nFlip;
    BOOL m_bBrightnessShow;
    BOOL m_bContrastShow;
    
    int m_nDisplayMode;
    int m_nVideoWidth;
    int m_nVideoHeight;
    
    int m_nScreenWidth;
    int m_nScreenHeight;
    
    PicPathManagement *m_pPicPathMgt;
    RecPathManagement *m_pRecPathMgt;
    
    //CCustomAVRecorder *m_pCustomRecorder;
    NSCondition *m_RecordLock;
    
    id<NotifyEventProtocol> PicNotifyDelegate;
    id<NotifyEventProtocol> RecNotifyDelegate;
    
    MyGLViewController *myGLViewController;
    FisheyeView* fishView;         //C60摄像机
    FisheyeC61SView *fishC61SView; //C61s摄像机
    
    int m_videoFormat;
    
    Byte *m_pYUVData;
    NSCondition *m_YUVDataLock;
    int m_nWidth;
    int m_nHeight;
    
    UIImageView *imageBg;
    
    CGRect winsize;
    
    UIImage* resetimage;
    
    DemoTableController* tableCtr;
    FPPopoverController* fppoverCtr;
    
    PopupListComponent* _resolutionPopup;
    PopupListComponent* _menuPopup;
    NSArray* _listitems ;
    
    UIButton* _resolutionbutton;
}
@property (nonatomic, retain) PopupListComponent* menuPopup;
@property (nonatomic, retain) IBOutlet UIButton* resolutionbutton;
@property (nonatomic, retain) NSArray* listitems;
@property (nonatomic, retain) PopupListComponent* resolutionPopup;

@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, copy) NSString *cameraName;
@property (nonatomic, copy) NSString *strDID;
@property (nonatomic, retain) UIActivityIndicatorView *progressView;
@property (nonatomic, retain) UILabel *LblProgress;
@property (nonatomic, retain) UIToolbar *playToolBar;
@property (nonatomic, retain) UIBarButtonItem *btnItemResolution;
@property (nonatomic, retain) UIBarButtonItem *btnTitle;
@property (nonatomic, retain) UILabel *timeoutLabel;
@property int m_nP2PMode;
@property (nonatomic, retain) UIToolbar *toolBarTop;
@property (nonatomic, retain) UIBarButtonItem *btnUpDown;
@property (nonatomic, retain) UIBarButtonItem *btnLeftDown;
@property (nonatomic, retain) UIBarButtonItem *btnUpDownMirror;
@property (nonatomic, retain) UIBarButtonItem *btnLeftRightMirror;
@property (nonatomic, retain) UIBarButtonItem *btnAudioControl;
@property (nonatomic, retain) UIBarButtonItem *btnTalkControl;
@property (nonatomic, retain) UIBarButtonItem *btnSetContrast;
@property (nonatomic, retain) UIBarButtonItem *btnSetBrightness;
@property (nonatomic, retain) UIBarButtonItem *btnStop;
@property (nonatomic, retain) IBOutlet UIButton* ButtonStop;
@property (nonatomic, retain) UIImage *imgVGA;
@property (nonatomic, retain) UIImage *imgQVGA;
@property (nonatomic, retain) UIImage *img720P;
//@property (nonatomic, retain) UIBarButtonItem *btnSwitchDisplayMode;
@property (nonatomic, retain) UIImage *imgNormal;
@property (nonatomic, retain) UIImage *imgEnlarge;
@property (nonatomic, retain) UIImage *imgFullScreen;
@property (nonatomic, retain) UIImage *imageSnapshot;
@property (nonatomic, assign) PicPathManagement *m_pPicPathMgt;
@property (nonatomic, retain) UIBarButtonItem *btnRecord;

@property (nonatomic, retain) UIImageView *imageUp;
@property (nonatomic, retain) UIImageView *imageDown;
@property (nonatomic, retain) UIImageView *imageLeft;
@property (nonatomic, retain) UIImageView *imageRight;

@property (nonatomic, assign) RecPathManagement *m_pRecPathMgt;
@property (nonatomic, assign) id<NotifyEventProtocol> PicNotifyDelegate;
@property (nonatomic, assign) id<NotifyEventProtocol> RecNotifyDelegate;
@property (nonatomic, retain) UIBarButtonItem *btnSnapshot;
@property (nonatomic, retain) IBOutlet UIButton* resetButton;
@property (nonatomic, retain) IBOutlet UIButton* menuButton;
@property (nonatomic, retain) IBOutlet UIImageView* cameramarkimgView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* rotationItem;
@property (nonatomic, retain) IBOutlet UIButton* rotationBtn;
@property (nonatomic, retain) UIImage* recordImgOn;
@property (nonatomic, retain) UIImage* recordImgOff;
@property (nonatomic, retain) UIImage* audioImgOn;
@property (nonatomic, retain) UIImage* audioImgOff;
@property (nonatomic, retain) UIImage* talkImgOn;
@property (nonatomic, retain) UIImage* talkImgOff;
@property (nonatomic, retain) IBOutlet UIButton* recordBtn;
@property (nonatomic, retain) IBOutlet UIButton* audioBtn;
@property (nonatomic, retain) IBOutlet UIButton* talkBtn;
@property (nonatomic, retain) IBOutlet UIButton* upDownBtn;
@property (nonatomic, retain) IBOutlet UIButton* leftRightBtn;
@property (nonatomic, retain) IBOutlet UIButton* snapshotBtn;
@property (nonatomic, retain) IBOutlet UIButton* resolutionBtn;
@property (nonatomic, retain) UIImage* arrowUpDownImg;
@property (nonatomic, retain) UIImage* arrowLeftRightImg;
@property (nonatomic, retain) UIImage* arrowUpDownImgOn;
@property (nonatomic, retain) UIImage* arrowLeftRightImgOn;

@property (nonatomic, retain) IBOutlet UIButton* muscreenBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* muscreenItem;

@property (nonatomic, retain) NSString* currentAcc;

@property (assign) BOOL b_split;//用了确定返回到那个界面

@property (nonatomic, retain) UIScrollView* disPlayScrollView;
@property (nonatomic, retain) UIScrollView* subDisplayScrollView;

@property (nonatomic, retain) CameraListMgt* m_PCameraListMgt;


- (IBAction) btnItemResolutionPressed:(id)sender;
//- (IBAction) btnItemDefaultVideoParamsPressed:(id)sender;//
- (void)StopPlay: (int) bForce;
- (IBAction) btnAudioControl: (id) sender;
- (IBAction) btnTalkControl:(id)sender;
- (IBAction) btnStop:(id)sender;
- (IBAction) btnUpDown:(id)sender;
- (IBAction) btnLeftRight:(id)sender;
- (IBAction) btnUpDownMirror:(id)sender;
- (IBAction) btnLeftRightMirror:(id)sender;
- (IBAction) btnSetContrast:(id)sender;
- (IBAction) btnSetBrightness:(id)sender;
//- (IBAction) btnSwitchDisplayMode:(id)sender;//
- (IBAction) btnSnapshot:(id)sender;
- (IBAction) btnRecord:(id)sender;

- (IBAction) Preset:(id)sender;

- (IBAction) menu:(id)sender;

- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height;

- (IBAction)rotationView:(id)sender;

- (IBAction)SplitScreen:(id)sender;


- (void) saveSnapshot: (UIImage*) image DID: (NSString*) _strDID;

- (void)PlayViewtouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)PlayViewtouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)PlayViewtouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)PlayViewtouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end
