//
//  CommonTableViewController.m
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 17/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import "CommonTableViewController.h"
#import "FBDataProvider.h"

@interface CommonTableViewController ()
@property id notificationCenterObject;
@end

@implementation CommonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)vieWillAppear:(BOOL)animated {
    self.notificationCenterObject = [[NSNotificationCenter defaultCenter] addObserverForName:kFBDataProviderAuthenticated
                                                                                      object:nil
                                                                                       queue:nil
                                                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                                                      [self reloadTweetsForDisplay];
                                                                                  }];
}


-(void)viewDidAppear:(BOOL)animated {
    [self reloadTweetsForDisplay];
}


-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self.notificationCenterObject];
    self.notificationCenterObject = nil;
}


- (void)reloadTweetsForDisplay {
    self.tweets = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //returns the number of sections. Will stay to one.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of tweets
    return [self.tweets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stdcell" forIndexPath:indexPath];
    
    NSString *tweet = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"content"];
    NSString *user = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"by"];
    
    cell.textLabel.text = tweet;
    cell.detailTextLabel.text = user;
    
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
