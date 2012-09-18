//
//  ITalkerChatRoomViewController.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatRoomViewController.h"
#import "ITalkerNetworkEngine.h"

@interface ITalkerChatRoomViewController ()

@end

@implementation ITalkerChatRoomViewController

@synthesize chatInputField = _chatInputField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[ITalkerNetworkEngine getInstance] bindPort:12345];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)handleSendButtonClicked:(id)sender
{
    NSString * content = _chatInputField.text;
    
    [[ITalkerNetworkEngine getInstance] broadcastUdpData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
