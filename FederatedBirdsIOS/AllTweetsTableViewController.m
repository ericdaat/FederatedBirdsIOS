//
//  AllTweetsTableViewController.m
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 17/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import "AllTweetsTableViewController.h"


@interface AllTweetsTableViewController ()

@end

@implementation AllTweetsTableViewController

-(void)reloadTweetsForDisplay {
    
    [FBSession allPublicMessagesFromServer:[FBDataProvider sharedInstance].session.servername
                     withCompletionHandler:^(NSArray *result, NSError *error) {
                         
                         self.tweets = result;
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.refreshControl endRefreshing];
                             [self.tableView reloadData];
                         });
                     }];
}

@end
