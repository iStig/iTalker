//
//  ITalkerChatRoomViewController.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ITalkerUdpNetworkEngine.h"

@interface ITalkerChatRoomViewController : UIViewController <ITalkerUdpNetworkDelegate>

@property (strong, nonatomic) IBOutlet UITextField * chatInputField;

@property (strong, nonatomic) IBOutlet UITextView * chatDisplayView;

- (IBAction)handleSendButtonClicked:(id)sender;

@end
