//
//  LiveView.m
//  LiveDemo
//
//  Created by 刘清 on 2016/12/16.
//  Copyright © 2016年 刘清. All rights reserved.
//

#import "LiveView.h"
#import "LFLiveKit.h"

//直播回调
@interface LiveView ()<LFLiveSessionDelegate>

@end

@implementation LiveView
{
    UIView *_liveView;//直播预览界面
    UIButton *_startBt;//开播、关播按钮
    UIButton *_changeCamera;//切换摄像头
    
    LFLiveSession *_session;//直播会话
    LFLiveDebug *_debug;//直播调试
}

//参数初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self requestAccessForVideo];
        [self requestAccessForAudio];
        [self addSubview:[self gLiveView]];
        [_liveView addSubview:[self gStartBt]];
        [_liveView addSubview:[self gChangeCamera]];
    }
    return self;
}

//请求采集音视频
- (void)requestAccessForVideo {
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            //授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[_self gSession] setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            //已授权
            dispatch_async(dispatch_get_main_queue(), ^{
                [[_self gSession] setRunning:YES];
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            //拒绝
            break;
        default:
            break;
    }
}
- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

//初始化控件
- (UIView *)gLiveView
{
    if (_liveView == nil) {
        _liveView = [[UIView alloc] initWithFrame:self.bounds];
        _liveView.backgroundColor = [UIColor clearColor];
    }
    return _liveView;
}
- (UIButton *)gStartBt
{
    if (!_startBt) {
        _startBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBt.bounds = CGRectMake(0, 0, 200, 44);
        _startBt.center = CGPointMake(M_WIDTH / 2, M_HEIGHT - 60);
        [_startBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startBt setTitle:@"开始" forState:UIControlStateNormal];
        [_startBt addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBt;
}
- (void)startClick:(UIButton *)bt
{
    _startBt.selected = !_startBt.selected;
    if (_startBt.selected) {
        [_startBt setTitle:@"停止" forState:UIControlStateNormal];
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        stream.url = @"rtmp://www.marrymin.com:1935/hls/test";
        [_session startLive:stream];
    } else {
        [_startBt setTitle:@"开始" forState:UIControlStateNormal];
        [_session stopLive];
    }
}
- (UIButton *)gChangeCamera
{
    if (!_changeCamera) {
        _changeCamera = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeCamera.bounds = CGRectMake(0, 0, 44, 44);
        _changeCamera.center = CGPointMake(M_WIDTH - 60, 60);
        [_changeCamera setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        [_changeCamera addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCamera;
}
- (void)changeClick:(UIButton *)bt
{
    AVCaptureDevicePosition devicePositon = _session.captureDevicePosition;
    _session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}
- (LFLiveSession *)gSession
{
    if (!_session) {

        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
        videoConfiguration.videoSize = CGSizeMake(540, 960);
        videoConfiguration.videoBitRate = 800*1024;
        videoConfiguration.videoMaxBitRate = 1000*1024;
        videoConfiguration.videoMinBitRate = 500*1024;
        videoConfiguration.videoFrameRate = 24;
        videoConfiguration.videoMaxKeyframeInterval = 48;
        videoConfiguration.outputImageOrientation = UIDeviceOrientationPortrait;
        videoConfiguration.autorotate = NO;
        videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:videoConfiguration captureType:LFLiveCaptureDefaultMask];
        _session.delegate = self;
        _session.showDebugInfo = NO;
        _session.preView = self;
    
    }
    return _session;
}

@end
