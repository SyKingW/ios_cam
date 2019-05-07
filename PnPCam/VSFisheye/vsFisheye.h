//
//  vsFisheye.h
//  vsFisheye
//
//  Created by ricky on 2018/8/1.
//  Copyright © 2018年 Ricky. All rights reserved.
//

//注意依赖Foundation，UIKit，QuartzCore，OpenGLES,GLKit

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
enum
{
    DEVICE_TYPE_A, //D93
    DEVICE_TYPE_B, //C60
};
enum
{
    VIEW_TYPE_ONE, //1屏
    VIEW_TYPE_FOUR,//4屏
};

enum{
    EYE_POSITION_NOT = -1,
    EYE_TOP_LEFT_VIEW,
    EYE_TOP_RIGHT_VIEW,
    EYE_BOTTOM_LEFT_VIEW,
    EYE_BOTTOM_RIGHT_VIEW,
};

typedef void (^SingleTapBlock)();
typedef void (^IsStartCruiseBlock)(BOOL isCruise,BOOL isSpread);
typedef void (^IsSplitScreenBlock)(BOOL isSplit,BOOL isSpread);

#pragma mark--------C60全景用的接口------------------------------------------------
@interface FisheyeView : UIView
- (id)  initWithFrame:(CGRect)frame Type:(int)nTpye;
- (void) setDeviceTpye:(int)nTpye;
- (void) setViewTpye:(int)nType;

- (void) display:(void*)yBuff  u:(void*)uBuff v:(void*)vBuff Size:(CGSize) size;
- (void) ChangeViewSizeNotify;
//巡航
- (void) StartCruise;
- (void) StopCruise;
- (BOOL) IsCruise;

-(void) RefresVideo;
-(void) FreeObject;

/**
 启用展示的位置记录
 @param strKey 为本地保存的关键字唯一的(最好是UID+使用地方)
 */
-(void) EnableLastOperateRecord:(NSString*) strKey;

/**
 还原上次展示的位置
 @return YES 操作成功 NO 失败
 */
-(BOOL) RestoreLastOperateRecord;

@property (nonatomic, assign) BOOL     is180Open; //展开标志yes:展开  no: 默认
@property (nonatomic, copy) SingleTapBlock singleTapBlock;
@property (nonatomic, copy) IsStartCruiseBlock isStartCruiseBlock;
@end
#pragma mark--------c60 End-----------------------------------------------------

#pragma mark--------C61全景用的接口------------------------------------------------
@interface FisheyeC61SView : UIView
- (id)   initWithFrame:(CGRect)frame Type:(int)nTpye;
- (void) setViewTpye:(int)nType;
- (void) display:(void*)yBuff  u:(void*)uBuff v:(void*)vBuff Size:(CGSize) size;
//
- (void) SetFullPlay:(BOOL)bFull;
- (void) ChangeViewSizeNotify;
//巡航
- (void) StartCruise;
- (void) StopCruise;
- (BOOL) IsCruise;

//4画面
- (void)StartSplitScreen;
- (void)StopSplitScreen;

//刷新
-(void) RefresVideo;

-(void) FreeObject;

-(void) handleDoubleTap:(UITapGestureRecognizer *)doubleTap;

/**
 启用展示的位置记录
 @param strKey 为本地保存的关键字唯一的(最好是UID+使用地方)
 */
-(void) EnableLastOperateRecord:(NSString*) strKey;

/**
 还原上次展示的位置
 @return YES 操作成功 NO 失败
 */
-(BOOL) RestoreLastOperateRecord;

@property (nonatomic, assign) BOOL     is180Open; //展开标志yes:展开  no: 默认
@property (nonatomic, copy) SingleTapBlock singleTapBlock;
@property (nonatomic, copy) IsStartCruiseBlock isStartCruiseBlock;
@property (nonatomic, copy) IsSplitScreenBlock isSplitScreenBlock;
@end
#pragma mark--------c61 End-----------------------------------------------------
