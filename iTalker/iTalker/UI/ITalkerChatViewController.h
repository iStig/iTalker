//
//  ITalkerChatRoomViewController.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITalkerChatEngine.h"

@class ITalkerUserInfo;

@interface ITalkerChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ITalkerChatDelegate> {
    NSMutableArray * _chatContentArray;
}

@property (strong, nonatomic) ITalkerUserInfo * chatToUserInfo;

@property (strong, nonatomic) IBOutlet UITableView * chatTableView;

@property (strong, nonatomic) IBOutlet UITextField * chatInputField;

- (IBAction)handleSendButtonClicked:(id)sender;

- (IBAction)handleSpeechButtonClicked:(id)sender;

@end
