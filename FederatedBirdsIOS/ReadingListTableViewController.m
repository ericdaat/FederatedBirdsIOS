//
//  ReadingListViewController.m
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 17/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import "ReadingListTableViewController.h"

@interface ReadingListTableViewController ()

@end

@implementation ReadingListTableViewController


- (void) reloadTweetsForDisplay {
    
    [[FBDataProvider sharedInstance].session readingListWithCompletionHandler:^(NSArray *result, NSError *error) {
        self.tweets = result;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

@end
