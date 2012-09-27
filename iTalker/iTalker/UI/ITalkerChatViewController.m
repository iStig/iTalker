//
//  ITalkerChatRoomViewController.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-17.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerChatViewController.h"
#import "ITalkerUdpNetworkEngine.h"
#import "ITalkerUserInfo.h"

@implementation ITalkerChatViewController

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
    [_chatTableView setDelegate:self];
    [_chatTableView setDataSource:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)handleSpeechButtonClicked:(id)sender
{

}

- (IBAction)handleSendButtonClicked:(id)sender
{
    if (_chatToUserInfo != nil) {
        ITalkerChatEngine * chatEngine = [ITalkerChatEngine getInstance];
        [chatEngine startChatWith:_chatToUserInfo];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_chatContentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * chatContentListCellIdentifier = @"ChatContentListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatContentListCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatContentListCellIdentifier];
    }
    
    return cell;
}

@end
