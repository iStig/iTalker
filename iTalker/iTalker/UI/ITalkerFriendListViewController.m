//
//  ITalkerFriendListViewController.m
//  iTalker
//
//  Created by tuyuanlin on 12-9-20.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import "ITalkerFriendListViewController.h"
#import "ITalkerUserObserver.h"
#import "ITalkerUserInfo.h"

@interface ITalkerFriendListViewController ()

@end

@implementation ITalkerFriendListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _friendArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    ITalkerUserObserver * observer = [ITalkerUserObserver getInstance];
    [observer setUserEventDelegate:self];
    [observer startObserve];
    [observer publishUser];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleUserObserverEvent:(ITalkerUserObserverEvent)event AndUserInfo:(ITalkerUserInfo *)userInfo
{
    if (userInfo == nil) {
        return;
    }
    
    switch (event) {
        case ITalkerUserObserverUserAdded: {
            NSString * user = [NSString stringWithFormat:@"%@ : %@", userInfo.userName, userInfo.IpAddr];
            [_friendArray addObject:user];
            
            NSArray * array = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:(_friendArray.count - 1) inSection:0], nil];
            
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableView endUpdates];
            break;
        }
        default:
            break;
    }
}

#pragma mark - table view data source delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * friendListCellIdentifier = @"FriendListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendListCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendListCellIdentifier];
    }

    if (indexPath && indexPath.section == 0 && indexPath.row < _friendArray.count) {
        cell.textLabel.text = [_friendArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

@end
