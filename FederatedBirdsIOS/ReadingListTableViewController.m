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

- (void)viewDidLoad {

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadTweetsForDisplay {
    
    [[FBDataProvider sharedInstance].session readingListWithCompletionHandler:^(NSArray *result, NSError *error) {
        
        self.tweets = [[NSMutableArray alloc] init];
        
        for (NSDictionary *tweet in result){
            NSMutableDictionary *mutableTweet = [tweet mutableCopy];
            
            [self loadImageForUserName:[tweet objectForKey:@"by"]
                 withCompletionHandler:^(NSDictionary *result, NSError *error) {
                     [mutableTweet addEntriesFromDictionary:result];
                     [self.tweets addObject:mutableTweet];
            }];
        }
        
        [self.tableView reloadData];
    }];
    
    
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
