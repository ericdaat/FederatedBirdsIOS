//
//  UserDetailViewController.m
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 18/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.usernameLabel.text = self.username;
    
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stdcell" forIndexPath:indexPath];
    
    NSString *tweet = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"content"];
    
    if (![tweet isEqual:[NSNull null]]){
        cell.textLabel.text = tweet;
    } else {
        cell.textLabel.text = @"";
    }
    cell.detailTextLabel.text = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"by"];
    
    return cell;
}

- (void) loadData {
    NSString *handle = [self.username stringByAppendingString:serverURL];
    
    [FBSession publicMessagesForHandle:handle withCompletionHandler:^(NSArray *result, NSError *error) {
        self.tweets = result;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
