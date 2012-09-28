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
#import "ITalkerTextChatContent.h"

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
    
    _chatContentArray = [[NSMutableArray alloc] init];
    
    [[ITalkerChatEngine getInstance] setChatDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)handleSpeechButtonHold:(id)sender
{

}

- (IBAction)handleSendButtonClicked:(id)sender
{
    ITalkerTextChatContent * content = [[ITalkerTextChatContent alloc] initWithString:@"Test"];
    [[ITalkerChatEngine getInstance] talk:content];
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
    
    ITalkerBaseChatContent * content = [_chatContentArray objectAtIndex:indexPath.row];
    switch (content.contentType) {
        case ITalkerChatContentTypeText:
        {
            ITalkerTextChatContent * textContent = (ITalkerTextChatContent *)content;
            cell.textLabel.text = textContent.text;
            break;
        }
        default:
            break;
    }

    return cell;
}

- (void)handleNewMessage:(ITalkerBaseChatContent *)message From:(ITalkerUserInfo *)userInfo
{
    switch (message.contentType) {
        case ITalkerChatContentTypeText:
        {
            [_chatContentArray addObject:message];
            NSArray * array = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(_chatContentArray.count - 1) inSection:0], nil];
            
            [_chatTableView beginUpdates];
            [_chatTableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            [_chatTableView endUpdates];
        }
        default:
            break;
    }
}

@end
