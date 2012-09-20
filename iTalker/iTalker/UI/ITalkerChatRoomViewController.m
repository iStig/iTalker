//
//  ITalkerChatRoomViewController.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatRoomViewController.h"
#import "ITalkerUdpNetworkEngine.h"

@interface ITalkerChatRoomViewController ()

@end

@implementation ITalkerChatRoomViewController

@synthesize chatInputField = _chatInputField;
@synthesize chatDisplayView = _chatDisplayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)handleSendButtonClicked:(id)sender
{

}

- (void)handleUdpData:(NSData *)data
{
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    _chatDisplayView.text = [NSString stringWithFormat:@"%@\n%@", _chatDisplayView.text, dataStr];
}

@end
