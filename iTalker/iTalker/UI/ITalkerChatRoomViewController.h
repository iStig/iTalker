//
//  ITalkerChatRoomViewController.h
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITalkerChatRoomViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField * chatInputField;

- (IBAction)handleSendButtonClicked:(id)sender;

@end
