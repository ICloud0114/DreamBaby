//
//  SubmitAudioViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CL_VoiceEngine.h"

@class AppDelegate;

#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]

@class SubmitAudioViewController;
@protocol SubmitAudioViewControllerDelegate <NSObject>

- (void)SubmitAudioViewController:(SubmitAudioViewController *)controller didFinishUpload:(NSDictionary *)dictionary;

@end
@interface SubmitAudioViewController : UIViewController
{
    CL_AudioRecorder* audioRecoder;
    

    BOOL              m_isRecording;

}
@property (nonatomic ,retain) id<SubmitAudioViewControllerDelegate> delegate;
@end
