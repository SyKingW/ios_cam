
#import "CameraViewController.h"
#import "CameraEditViewController.h"
#import "CameraPushViewController.h"
#import "CameraMessageViewController.h"
#import "CameraListCell.h"
#import "IpCameraClientAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PPPPDefine.h"
#import "mytoast.h"
#include "MyAudioSession.h"
#import "SettingViewController.h"
#import "AddCameraCell.h"
#import "PushCameraCell.h"
#import "MessageCameraCell.h"
#import "CameraEditViewController.h"
#import "CustomTableAlert.h"
#import "UserPwdSetViewController.h"

#import "VSNet.h"
#include "cmdhead.h"
#import "APICommon.h"

@interface CameraViewController()
@property (nonatomic, retain) CustomTableAlert* customTalert;
@end
@implementation CameraViewController

@synthesize cameraList;
@synthesize navigationBar;
@synthesize actionPop = _actionPop;
@synthesize btnAddCamera;
@synthesize setPushCamera;
@synthesize cameraListMgt;
@synthesize m_pPicPathMgt;
@synthesize PicNotifyEventDelegate;
@synthesize RecordNotifyEventDelegate;
@synthesize m_pRecPathMgt;
@synthesize indPath;

#define spliteBtn @"SpliteButton"
#pragma mark -
#pragma mark button presss handle

#define warnBtnTag  55555
#define warnBtnAlertTag  66666

#define CAMERA_DEFAULT_PWD @"888888"



- (void) StartPlayView: (NSInteger)index
{    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    NSString *strName = [cameraDic objectForKey:@STR_NAME];
    NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
  
    IpCameraClientAppDelegate *IPCamDelegate =  (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate] ;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView_iPad" bundle:nil];
    }else{
          _playViewController = [[PlayViewController alloc] initWithNibName:@"PlayView" bundle:nil];
    }
   //_playViewController.m_pPPPPChannelMgt = pPPPPChannelMgt;
    _playViewController.strDID = strDID;
    _playViewController.cameraName = strName;
    _playViewController.m_nP2PMode = [nPPPPMode intValue];
    _playViewController.b_split = NO;
    [IPCamDelegate switchPlayView:_playViewController];
    
   // [playViewController release];

}


#define ADD_CAMERA_RED 200
#define ADD_CAMERA_GREED 200
#define ADD_CAMERA_BLUE 200

#define ADD_CAMERA_NORMAL_RED 230
#define ADD_CAMERA_NORMAL_GREEN 230
#define ADD_CAMERA_NORMAL_BLUE 230

#define TalkMark @"IsTalking"//用于记录上次是监听还是对讲
#define AudioMark @"IsAudioing"

- (IBAction)btnAddCameraTouchDown:(id)sender
{
    NSLog(@"btnAddCameraTouchDown");
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_RED/255.0f green:ADD_CAMERA_GREED/255.0f blue:ADD_CAMERA_BLUE/255.0f alpha:1.0];
}

- (IBAction)btnAddCameraTouchUp:(id)sender
{
    NSLog(@"btnAddCameraTouchUp");
    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
    
    CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
    cameraEditViewController.editCameraDelegate = self;
    cameraEditViewController.bAddCamera = YES;
    [self.navigationController pushViewController:cameraEditViewController animated:YES]; 
    [cameraEditViewController release];
    
}

- (IBAction)setPushCameraTouchDown:(id)sender
{
       NSLog(@"setPushCameraTouchDown");
    setPushCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_RED/255.0f green:ADD_CAMERA_GREED/255.0f blue:ADD_CAMERA_BLUE/255.0f alpha:1.0];
}

- (IBAction)setPushCameraTouchUp:(id)sender
{
      NSLog(@"setPushCameraTouchUp");
    setPushCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
    
    CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
    cameraEditViewController.editCameraDelegate = self;
    cameraEditViewController.bAddCamera = YES;
    [self.navigationController pushViewController:cameraEditViewController animated:YES];
    [cameraEditViewController release];
   
}

- (void) btnEdit:(id)sender
{
    bEditMode = ! bEditMode;
    [cameraList reloadData];
}

- (void) setNavigationBarItem: (BOOL) abEditMode
{
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil)];  
    NSString *strText;    
    UIBarButtonItem *btnEdit;
    UIBarButtonItem* left;
    if (!abEditMode) {
        strText = NSLocalizedStringFromTable(@"Edit", @STR_LOCALIZED_FILE_NAME, nil);
        btnEdit = [[UIBarButtonItem alloc] initWithTitle:strText  style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit:)];
        
        btnEdit.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddCamera:)];
        left.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1.0];
        left.width = 50.0f;
    }else {
        strText = NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil);
        btnEdit = [[UIBarButtonItem alloc] initWithTitle:strText  style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit:)];
        
        btnEdit.tintColor = [UIColor colorWithRed:BTN_DONE_RED/255.0f green:BTN_DONE_GREEN/255.0f blue:BTN_DONE_BLUE/255.0f alpha:1.0];
        
        left = nil;
    }
    
    [btnEdit release];
    [left release];
    NSArray *array = [NSArray arrayWithObjects:naviItem, nil];
    [self.navigationBar setItems:array];
    [naviItem release];

}

-(void)AddCamera:(id)sender
{
    NSLog(@"addcamera");
    CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] init];
    cameraEditViewController.editCameraDelegate = self;
    cameraEditViewController.bAddCamera = YES;
    [self.navigationController pushViewController:cameraEditViewController animated:YES];
    [cameraEditViewController release];
}

#pragma mark -
#pragma mark TableViewDelegate

//删除设备的处理
- (NSString*)PathForDocumentStrDID:(NSString*)strDID{
    NSString* documentPath = nil;
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    documentPath = [path objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:strDID];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    int index = indexPath.row ;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    NSString *strDID = [cameraDic objectForKey:@STR_DID];
    
    NSFileManager* fileMng = [NSFileManager   defaultManager];
    NSString* imagepath = [self PathForDocumentStrDID:strDID];
    if ([fileMng fileExistsAtPath:imagepath]) {
        if ([fileMng removeItemAtPath:imagepath error:nil]) {
            NSLog(@"remove success");
        }
    }
    
    
    if(YES == [cameraListMgt RemoveCameraAtIndex:index ]){
        if ([cameraListMgt GetCount] > 0) {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            [cameraList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        //停止P2P
        //pPPPPChannelMgt->Stop([strDID UTF8String]);
        [[VSNet shareinstance] stop:strDID];
        [m_pPicPathMgt RemovePicPathByID:strDID];
        [m_pRecPathMgt RemovePathByID:strDID];
        
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
        
        if ([cameraListMgt GetCount] == 0) {
            [self btnEdit:nil];
        }
        
    }    
} 

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //if (indexPath.row == [cameraListMgt GetCount]) {
        return UITableViewCellEditingStyleNone;
    //}
  
    
   // return UITableViewCellEditingStyleDelete;
    
    
    
} 

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)anIndexPath
{
    self.indPath = anIndexPath;
    cellRow = anIndexPath.row ;
}


#pragma mark UIActionSheetDelegate Method
- (void) NotifyReloadData{
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    return  NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil); 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    int count = [cameraListMgt GetCount];
    return count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"cellForRowAtIndexPath");  
    
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    
    NSInteger index = anIndexPath.row ;    
    
    //-----------------------------------------------------------------------------------
        
    //index = 0显示添加摄像机
    if (index == [cameraListMgt GetCount]) {
        NSLog(@"AddCameraCell %d",0);
        NSString *cellIdentifier = @"AddCameraCell";       
        //当状态为显示当前的设备列表信息时
        AddCameraCell *cell =  (AddCameraCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddCameraCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.labelAddCamera.text = NSLocalizedStringFromTable(@"TouchAddCamera", @STR_LOCALIZED_FILE_NAME, nil);
        
        float cellHeight = cell.frame.size.height;
       // float cellWidth = cell.frame.size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 0, winsize.width, cellHeight - 1)];
        label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
        
        UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, winsize.width, cellHeight - 1)];
        [cellBgView addSubview:label];
        [label release];
        
        cell.backgroundView = cellBgView;
        
        return cell;
    }
    if (index == [cameraListMgt GetCount ]+1)
    {
        NSString *cellIdentifier = @"PushCameraCell";
        //当状态为显示当前的设备列表信息时
        NSLog(@"PushCameraCell %d",1);
        PushCameraCell *cell =  (PushCameraCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PushCameraCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.labelAddCamera.text = NSLocalizedStringFromTable(@"TouchPushCamera", @STR_LOCALIZED_FILE_NAME, nil);
        
        float cellHeight = cell.frame.size.height;
        // float cellWidth = cell.frame.size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 0, winsize.width, cellHeight - 1)];
        label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
        
        UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, winsize.width, cellHeight - 1)];
        [cellBgView addSubview:label];
        [label release];
        
        cell.backgroundView = cellBgView;
        
        return cell;
    }
    
    if (index == [cameraListMgt GetCount ]+2)
    {
        NSString *cellIdentifier = @"MessageCameraCell";
        NSLog(@"MessageCameraCell %d",1);
        MessageCameraCell *cell =  (MessageCameraCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCameraCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.labelAddCamera.text = NSLocalizedStringFromTable(@"TouchMessageCamera", @STR_LOCALIZED_FILE_NAME, nil);
        
        float cellHeight = cell.frame.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, 0, winsize.width, cellHeight - 1)];
        label.backgroundColor = [UIColor colorWithRed:CELL_SEPERATOR_RED/255.0f green:CELL_SEPERATOR_GREEN/255.0f blue:CELL_SEPERATOR_BLUE/255.0f alpha:1.0];
        
        UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, winsize.width, cellHeight - 1)];
        [cellBgView addSubview:label];
        [label release];
        
        cell.backgroundView = cellBgView;
        
        return cell;
    }
    
    //index -= 1;
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    NSString *name = [cameraDic objectForKey:@STR_NAME];
    UIImage *img = [cameraDic objectForKey:@STR_IMG];    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
    //NSNumber *nPPPPMode = [cameraDic objectForKey:@STR_PPPP_MODE];
    NSString *did = [cameraDic objectForKey:@STR_DID];
    NSString *pwd=[cameraDic objectForKey:@STR_PWD];
    
    
    NSLog(@"摄像机信息%@",cameraDic);
    

    NSString *cellIdentifier = @"CameraListCell";       
    //当状态为显示当前的设备列表信息时
    CameraListCell *cell =  (CameraListCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.button.tag = index;
    //cell.button.titleLabel.text = NSLocalizedStringFromTable(@"Menu", @STR_LOCALIZED_FILE_NAME, nil);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGSize winsize = [[UIScreen mainScreen] bounds].size;
        CGRect aFrame = cell.button.frame;
        aFrame.origin = CGPointMake(winsize.width - aFrame.size.width - 20, aFrame.origin.y);
        cell.button.frame = aFrame;
    }
    [cell.button setTitle:NSLocalizedStringFromTable(@"Menu", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(cameraset:) forControlEvents:UIControlEventTouchUpInside];
    
    //MZY  显示危险按钮
    cell.warnBtn.tag = anIndexPath.row + warnBtnTag ;
    [cell.warnBtn addTarget:self action:@selector(clickWarn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.warnBtn setHidden:YES];
    if ([nPPPPStatus integerValue] == PPPP_STATUS_ON_LINE && [pwd isEqualToString:CAMERA_DEFAULT_PWD]) {
        [cell.warnBtn setHidden:NO];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    int PPPPStatus = [nPPPPStatus intValue];
    //int PPPPMode = [nPPPPMode intValue];
    //NSLog(@"name: %@, index: %d, PPPPStatus: %d, PPPPMode: %d", name, index, PPPPStatus, PPPPMode);
        
    if (img != nil) {
        cell.imageCamera.image = img;
    }
        
    cell.NameLable.text = name;
    cell.PPPPIDLable.text = did; 
           
    NSString *strPPPPStatus = nil;
    switch (PPPPStatus) {
        case PPPP_STATUS_UNKNOWN:    
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;    
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
        break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    cell.PPPPStatusLable.text = strPPPPStatus;
    
         
   	return cell;
}

- (CGFloat)tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath*)indexpath
{
    if (indexpath.row == [cameraListMgt GetCount] || indexpath.row == [cameraListMgt GetCount]+1 || indexpath.row == [cameraListMgt GetCount]+2) {
        return 44;
    }
    return 74;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    indPath = anIndexPath;
       
    if (anIndexPath.row == [cameraListMgt GetCount]) {
        NSLog(@"table did selec addcamera");
        CameraEditViewController *cameraEditViewController = [[CameraEditViewController alloc] initWithNibName:@"CameraEditView" bundle:nil];
        cameraEditViewController.editCameraDelegate = self;
        cameraEditViewController.bAddCamera = YES;
        [self.navigationController pushViewController:cameraEditViewController animated:YES]; 
        [cameraEditViewController release];
        return;
    }
    
    //Pushview 进入推送设置界面
    if (anIndexPath.row == [cameraListMgt GetCount]+1) {
        NSLog(@"table did selec Pushview");
        CameraPushViewController *cameraPushViewController = [[CameraPushViewController alloc] initWithNibName:@"CameraEditView" bundle:nil];
        cameraPushViewController.editCameraDelegate = self;
        cameraPushViewController.bAddCamera = YES;
        [self.navigationController pushViewController:cameraPushViewController animated:YES];
        [cameraPushViewController release];
        return;
    }
    //Messageview 进入消息记录界面
    if (anIndexPath.row == [cameraListMgt GetCount]+2) {
        NSLog(@"table did selec Pushview");
        CameraMessageViewController *cameraMViewController = [[CameraMessageViewController alloc] initWithNibName:@"CameraEditView" bundle:nil];
        cameraMViewController.editCameraDelegate = self;
        cameraMViewController.bAddCamera = YES;
        [self.navigationController pushViewController:cameraMViewController animated:YES];
        [cameraMViewController release];
        return;
    }
    
    NSInteger index = anIndexPath.row;
    //index -= 1;
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:index];
    if (cameraDic == nil) {
        return;
    }
    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];        
    if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
        return;
    }
    
    if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
        return;
    }
    
    
    [self StartPlayView:index];

}

-(void)cameraset:(id)sender{
    cellRow = [(UIButton*)sender tag];

    _customTalert = [[CustomTableAlert alloc] initWithTitle:nil cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) numberOfRows:^NSInteger{
        return 4;
    }tablecell:^UITableViewCell*(CustomTableAlert* table, NSIndexPath* indexPath){

        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [table.contentTable dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"ic_setting_camera"];
                cell.textLabel.text = NSLocalizedStringFromTable(@"Setting", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"ic_menu_album_inverse"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"LocalPic", @STR_LOCALIZED_FILE_NAME, nil)];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"ic_menu_checkvideo"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"LocalRec", @STR_LOCALIZED_FILE_NAME, nil)];
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"remotetfcard"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"TFRecord", @STR_LOCALIZED_FILE_NAME, nil)];
                break;
            default:
                break;
        }
        
        
        
        return cell;

    }];
    [_customTalert configureTableViewSelectionRowBlock:^(NSIndexPath* indexPath){

        NSDictionary* cameraDic = [cameraListMgt GetCameraAtIndex:[(UIButton*)sender tag]];
        if (cameraDic == nil) {
            return;
        }
        
        NSString* strDID = [cameraDic objectForKey:@STR_DID];
        NSString* strName = [cameraDic objectForKey:@STR_NAME];
        NSString* status = [cameraDic objectForKey:@STR_PPPP_STATUS];
        NSString* strPwd = [cameraDic objectForKey:@STR_PWD];
        switch (indexPath.row) {
            case 0:
            {
                SettingViewController* settingViewCtr = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                settingViewCtr.cameraListMgt = cameraListMgt;
                //settingViewCtr.m_pPPPPChannelMgt = self.pPPPPChannelMgt;
                settingViewCtr.hidesBottomBarWhenPushed = YES;
                settingViewCtr.delegate = self;
                settingViewCtr.editCamerDelegate = self;
                settingViewCtr.SetCamIndex = [(UIButton*)sender tag];
                settingViewCtr.m_strDID = strDID;
                settingViewCtr.cameraDic = cameraDic;
                [self.navigationController pushViewController:settingViewCtr animated:YES];
                [settingViewCtr release];
                settingViewCtr = nil;
            }
                break;
            case 1:
            {
                PictrueDateViewController* picDataViewCtr = [[PictrueDateViewController alloc] init];
                picDataViewCtr.cameraListMgt = cameraListMgt;
                picDataViewCtr.m_pPicPathMgt = self.m_pPicPathMgt;
                picDataViewCtr.picMgt = self.m_pPicPathMgt;
                picDataViewCtr.NotifyReloadDataDelegate = self.PicNotifyEventDelegate;
                picDataViewCtr.strDID = strDID;
                picDataViewCtr.strName = strName;
                [self pushtoView:picDataViewCtr];
                [picDataViewCtr release];
                picDataViewCtr = nil;
            }
                break;
            case 2:
            {
                RecordDateViewController* recDateViewCtr = [[RecordDateViewController alloc] init];
                recDateViewCtr.m_pRecPathMgt = self.m_pRecPathMgt;
                recDateViewCtr.RecReloadDelegate = self.RecordNotifyEventDelegate;
                recDateViewCtr.strDID = strDID;
                recDateViewCtr.strName = strName;
                //recDateViewCtr.m_PpppchannelMgt = self.pPPPPChannelMgt;
                recDateViewCtr.camListMgt = self.cameraListMgt;
                recDateViewCtr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self pushtoView:recDateViewCtr];
                [recDateViewCtr release];
                recDateViewCtr = nil;
            }
                break;
            case 3:
            {
                if ([status intValue] != PPPP_STATUS_ON_LINE) {
                    [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
                    return;
                }
                RemoteRecordFileListViewController* remoterecFileListViewCtr = [[RemoteRecordFileListViewController alloc] init];
                //remoterecFileListViewCtr.m_pPPPPChannelMgt = self.pPPPPChannelMgt;
                remoterecFileListViewCtr.m_strDID = strDID;
                remoterecFileListViewCtr.m_strName = strName;
                remoterecFileListViewCtr.cameraListMgt = self.cameraListMgt;
                remoterecFileListViewCtr.recPathMgt = self.m_pRecPathMgt;
                remoterecFileListViewCtr.m_strPWD = strPwd;
                [self pushtoView:remoterecFileListViewCtr];
                [remoterecFileListViewCtr release];
                remoterecFileListViewCtr = nil;
            }
                break;
//            case 4:
//            {
//                [self deleteCamera];
//            }
               // break;
            default:
                break;
        }

    }Completion:^{
        ;
    }];
    self.customTalert.height = 296;
    
    
    [_customTalert show];

}

#pragma mark SettingViewControllerDelegate
- (void) deletecam:(int) camIndex{
    self.setCamIndex = camIndex;
    [self deleteCamera];
}

- (void) rebootCam:(int) camIndex{
    self.setCamIndex = camIndex;
    NSDictionary* camdic = [cameraListMgt GetCameraAtIndex:self.setCamIndex];
    
    if (camdic == nil) {
        return;
    }
    NSString* status = [camdic objectForKey:@STR_PPPP_STATUS];
    if ([status intValue] != PPPP_STATUS_ON_LINE) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil)];
    }else{
        UIAlertView* rebootAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"RebootCam", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"CameraName", @STR_LOCALIZED_FILE_NAME, nil),[camdic objectForKey:@STR_NAME]] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
        rebootAlert.tag = 11;
        [rebootAlert show];
        [rebootAlert release];
    }
    
}


#pragma mark -
#pragma mark CamerasetViewControllerDelegate
- (void)pushtoView:(UIViewController*)ViewCtr{
    [self.navigationController pushViewController:ViewCtr animated:YES];
}
- (void)deleteCamera{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Whetherdelete", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"CameraName", @STR_LOCALIZED_FILE_NAME, nil),[[cameraListMgt GetCameraAtIndex:self.setCamIndex] objectForKey:@STR_NAME]] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alert.tag = 10;
    [alert show];
    [alert release];
    
}

- (void)clickWarn:(UIButton *)btn {
    NSLog(@"危险Index:%ld",(long)btn.tag);
    self.setCamIndex = btn.tag - warnBtnTag;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"Warn_AlertMessage", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alert.tag = warnBtnAlertTag;
    [alert show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.setCamIndex < 0 || self.setCamIndex >= [cameraListMgt GetCount]) {
        return;
    }
    
    NSDictionary* camdic = [cameraListMgt GetCameraAtIndex:self.setCamIndex];
    if (camdic == nil) {
        return;
    }
    NSString* strUID = (NSString*)[camdic objectForKey:@STR_DID];
    if (strUID == nil) {
        return;
    }
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            if (YES == [cameraListMgt RemoveCamerea:strUID]) {
            }
        
            [[VSNet shareinstance] stop:strUID];
            [m_pPicPathMgt RemovePicPathByID:strUID];
            [m_pRecPathMgt RemovePathByID:strUID];
            [PicNotifyEventDelegate NotifyReloadData];
            [RecordNotifyEventDelegate NotifyReloadData];
            [self.cameraList reloadData];
            
            
            NSFileManager* fileMng = [NSFileManager   defaultManager];
            NSString* imagepath = [self PathForDocumentStrDID:strUID];
            if ([fileMng fileExistsAtPath:imagepath]) {
                if ([fileMng removeItemAtPath:imagepath error:nil]) {
                    NSLog(@"remove success");
                    
                    
                }
                
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@itemId",strUID]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@",strUID,TalkMark]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@",strUID,AudioMark]];
            
        }

    }else if (alertView.tag == 11){
        if (buttonIndex == 1) {
            [[VSNet shareinstance] sendCgiCommand:@"reboot.cgi?" withIdentity:strUID];
        }

    }else if (alertView.tag == warnBtnAlertTag){
        if (buttonIndex == 1) {
            NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:self.setCamIndex];

            UserPwdSetViewController *UserPwdSettingView = [[UserPwdSetViewController alloc] init];

            UserPwdSettingView.m_strDID = [cameraDic objectForKey:@STR_DID];
            UserPwdSettingView.cameraListMgt = cameraListMgt;
            UserPwdSettingView.cameraName = [cameraDic objectForKey:@STR_NAME];
            
            [self.navigationController pushViewController:UserPwdSettingView animated:YES];
        }
        
    }
    self.setCamIndex = 100000;
}

#pragma mark system
- (void) refresh: (id) sender
{
    [self UpdateCameraSnapshot];
}

- (void) UpdateCameraSnapshot
{   
    int count = [cameraListMgt GetCount];    
    if (count == 0) {
        [self hideLoadingIndicator];
        return;
    }   
    
    //NSLog(@"UpdateCameraSnapshot...count: %d", count);
    int i;
    for (i = 0; i < count; i++)
    {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
        if (cameraDic == nil) {
            return ;
        }        
            
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];    
        if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
            continue;
        }
        
        NSString *did = [cameraDic objectForKey:@STR_DID];
        [[VSNet shareinstance] setControlDelegate:did withDelegate:self];
        [[VSNet shareinstance] sendCgiCommand:@"snapshot.cgi?res=1&" withIdentity:did];
    }    
    
    [self showLoadingIndicator];    
    [self performSelector:@selector(hideLoadingIndicator) withObject:nil afterDelay:10.0];
    
}

- (void)showLoadingIndicator
{
	UIActivityIndicatorView *indicator =
    [[[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
     autorelease];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[[UIBarButtonItem alloc] initWithCustomView:indicator] autorelease];
	[self.navigationItem setLeftBarButtonItem:progress animated:YES]; 
}


- (void)hideLoadingIndicator
{
	UIActivityIndicatorView *indicator =
    (UIActivityIndicatorView *)self.navigationItem.leftBarButtonItem;
	if ([indicator isKindOfClass:[UIActivityIndicatorView class]])
	{
		[indicator stopAnimating];
	}
	UIBarButtonItem *refreshButton =
    [[[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
      target:self
      action:@selector(refresh:)]
     autorelease];
	[self.navigationItem setLeftBarButtonItem:refreshButton animated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    //UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void) StartPPPP:(id) param
{
    sleep(1);
    int count = [cameraListMgt GetCount];
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
        
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];        
        if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
            continue;
        }
        
        usleep(100000);
        int nRet = [[VSNet shareinstance] start:strDID  withUser:strUser withPassWord:strPwd initializeStr:nil LanSearch:1];
        if(nRet == 0){
            //连接不成功，3秒后再试一次
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[VSNet shareinstance] start:strDID  withUser:strUser withPassWord:strPwd initializeStr:nil LanSearch:1];
                [[VSNet shareinstance] setStatusDelegate:strDID withDelegate:self];
                [[VSNet shareinstance] setControlDelegate:strDID withDelegate:self];
            });
        }
        else
        {
            [[VSNet shareinstance] setStatusDelegate:strDID withDelegate:self];
            [[VSNet shareinstance] setControlDelegate:strDID withDelegate:self];
        }
    }
}

- (void) StopPPPP
{
    [[VSNet shareinstance] stopAll];
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.title = NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);
        self.tabBarItem.image = [UIImage imageNamed:@"ipc30.png"];
    }
        
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    bEditMode = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    self.navigationItem.title = NSLocalizedStringFromTable(@"IPCamera", @STR_LOCALIZED_FILE_NAME, nil);

    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    leftBtn.frame = CGRectMake(0, 0, 40, 30);
    [leftBtn addTarget:self action:@selector(About:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem= leftBar;
    [leftBar release];

    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"muscreen"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(splite:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn release];

    [self.cameraList setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    btnAddCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
    
    setPushCamera.backgroundColor = [UIColor colorWithRed:ADD_CAMERA_NORMAL_RED/255.0f green:ADD_CAMERA_NORMAL_GREEN/255.0f blue:ADD_CAMERA_NORMAL_BLUE/255.0f alpha:1.0];
  
    [self StartPPPPThread];
    InitAudioSession();
}


- (void)splite:(id)sender{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    Split_screenViewController* splitvc = [[Split_screenViewController alloc] init];
    
    IpCameraClientAppDelegate *IPCAMDelegate = (IpCameraClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    [IPCAMDelegate switchSpliteScreen:splitvc];
    [splitvc release];
    
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    NSLog(@"aaaa");
    return YES;
}

-(void)pushrec:(id)sender{
    RecordViewController* recViewController = [[RecordViewController alloc] init];
    recViewController.m_pCameraListMgt = cameraListMgt;
    recViewController.m_pRecPathMgt = m_pRecPathMgt;
    [self.navigationController pushViewController:recViewController animated:YES];
    [recViewController release];

}

-(void)About:(id)sender{
    AboutViewController* aboutViewCtr = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewCtr animated:YES];
    [aboutViewCtr release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [cameraList reloadData];

    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) StartPPPPThread{
    [NSThread detachNewThreadSelector:@selector(StartPPPP:) toTarget:self withObject:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    self.cameraList = nil;
    [_playViewController release];
    _playViewController = nil;
    self.navigationBar = nil;
    self.cameraListMgt = nil;
    self.PicNotifyEventDelegate = nil;
    self.RecordNotifyEventDelegate = nil;
    self.m_pPicPathMgt = nil;
    [super dealloc];
}

#pragma mark EditCameraProtocol
- (BOOL) EditP2PCameraInfo:(BOOL)bAdd Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid
{
    NSLog(@"EditP2PCameraInfo  bAdd: %d, name: %@, did: %@, user: %@, pwd: %@, olddid: %@", bAdd, name, did, user, pwd, olddid);
    
    BOOL bRet;
    
    if (bAdd == YES) {
        bRet = [cameraListMgt AddCamera:name DID:did User:user Pwd:pwd Snapshot:nil];
    }else {
        bRet = [cameraListMgt EditCamera:olddid Name:name DID:did User:user Pwd:pwd];
    }
    
    if (bRet == YES) {
        if (bAdd) {//添加成功，增加P2P连接
            int nRet = [[VSNet shareinstance] start:did  withUser:user withPassWord:pwd initializeStr:nil LanSearch:1];
            if(nRet == 0){
                //连接不成功，3秒后再试一次
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[VSNet shareinstance] start:did  withUser:user withPassWord:user initializeStr:nil LanSearch:1];
                    [[VSNet shareinstance] setStatusDelegate:did withDelegate:self];
                    [[VSNet shareinstance] setControlDelegate:did withDelegate:self];
                });
            }
            else
            {
                [[VSNet shareinstance] setStatusDelegate:did withDelegate:self];
                [[VSNet shareinstance] setControlDelegate:did withDelegate:self];
            }
        }else {//修改成功，重新启动P2P连接
            [[VSNet shareinstance] stop:did];
            [[VSNet shareinstance] start:did withUser:user withPassWord:pwd initializeStr:nil LanSearch:1];
            [[VSNet shareinstance] setStatusDelegate:did withDelegate:self];
            [[VSNet shareinstance] setControlDelegate:did withDelegate:self];
            [self btnEdit:nil];
        }
        
        if (bEditMode && [olddid caseInsensitiveCompare:did] != NSOrderedSame) {
            [m_pPicPathMgt RemovePicPathByID:olddid];
        }
        
        //添加或修改设备成功，重新加载设备列表
        [cameraList reloadData];
        [PicNotifyEventDelegate NotifyReloadData];
        [RecordNotifyEventDelegate NotifyReloadData];
    }
    
    NSLog(@"bRet: %d", bRet);
    return bRet;
}

#pragma mark -
#pragma mark  VSNetStatueProtocol
- (void) VSNetStatus: (NSString*) deviceIdentity statusType:(NSInteger) statusType status:(NSInteger) status
{
    NSLog(@"PPPPStatus ..... strDID: %@, statusType: %ld, status: %ld", deviceIdentity, statusType, status);
    if (statusType == MSG_NOTIFY_TYPE_PPPP_MODE) {        
        NSInteger index = [cameraListMgt UpdatePPPPMode:deviceIdentity mode:status];
        if ( index >= 0){
            int Camindex = [cameraListMgt GetIndexFromDID:deviceIdentity];
            [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:Camindex] waitUntilDone:NO];
        }
        return;
    }
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        NSInteger index = [cameraListMgt UpdatePPPPStatus:deviceIdentity status:status];
        
        if ( index >= 0){
            int Camindex = [cameraListMgt GetIndexFromDID:deviceIdentity];
            [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:Camindex] waitUntilDone:NO];
        }
        
        if(status == 2){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *strCMD = @"get_factory_param.cgi?";
                 [[VSNet shareinstance] sendCgiCommand:strCMD withIdentity:deviceIdentity];
            });
        }
        
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID 
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED
            || status == PPPP_STATUS_INVALID_USER_PWD) {
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:deviceIdentity waitUntilDone:NO];
        }
        [RecordNotifyEventDelegate NotifyReloadData];
        return;        
    }    
}

#pragma mark -
#pragma mark PerformInMainThread
- (void) ReloadCameraTableView
{
    [cameraList reloadData];  
}

- (void) ReloadRowDataAtIndex: (NSNumber*) indexNumber
{
    NSLog(@"indexNumber  %@",indexNumber);
    NSInteger index = [indexNumber intValue];
    if (index == [cameraListMgt GetCount]) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [cameraList cellForRowAtIndexPath:indexPath];
    if (cell != nil) {              
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [cameraList reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
} 

- (void) StopPPPPByDID:(NSString*)did
{
    [[VSNet shareinstance] stop:did];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 0.0001);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

- (void) saveSnapshot: (UIImage*) image DID: (NSString*) strDID
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    [pool release];
}

# pragma mark VSNetControlProtocol
- (void) VSNetControl: (NSString*) deviceIdentity commandType:(NSInteger) comType buffer:(NSString*)retString length:(int)length charBuffer:(char *)buffer
{
    NSLog(@"CameraViewController VSNet返回数据 UID:%@ comtype %ld",deviceIdentity,(long)comType);
    switch (comType) {
        case CGI_IESET_SNAPSHOT:{
            NSData *image = [[NSData alloc] initWithBytes:buffer length:length];
            [self SnapshotCallback:image UID:deviceIdentity];
            break;
        }
        case CGI_IEGET_FACTORY:{
            NSInteger installType = [[APICommon stringAnalysisWithFormatStr:@"installType=" AndRetString:retString] integerValue];
            NSInteger correctModel = [[APICommon stringAnalysisWithFormatStr:@"correctModel=" AndRetString:retString] integerValue];
            
            if (installType == 1 && correctModel == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:@(CorrectModelC60) forKey:[NSString stringWithFormat:@"%@%@",deviceIdentity,@FactoryParamCorrectModelTag]];
            }else if (correctModel == 2){
                [[NSUserDefaults standardUserDefaults] setObject:@(CorrectModelC61S) forKey:[NSString stringWithFormat:@"%@%@",deviceIdentity,@FactoryParamCorrectModelTag]];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:@(CorrectModelOther) forKey:[NSString stringWithFormat:@"%@%@",deviceIdentity,@FactoryParamCorrectModelTag]];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        default:
            break;
    }
}

-(void)SnapshotCallback:(NSData*)data UID:(NSString*)strDID
{
    UIImage *img = [[UIImage alloc] initWithData:data];
    if (img == nil) {
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
    int Camindex = [cameraListMgt GetIndexFromDID:strDID];
    NSInteger index = [cameraListMgt UpdateCamereaImage:strDID  Image:imgScale] ;
    if (index >= 0) {
        [self saveSnapshot:imgScale DID:strDID];
        [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:[NSNumber numberWithInt:Camindex] waitUntilDone:NO];
    }
    
    [pool release];
    [img release];
}

@end
