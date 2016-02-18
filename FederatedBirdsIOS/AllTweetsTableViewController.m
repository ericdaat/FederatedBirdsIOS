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

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadTweetsForDisplay {
    [FBSession allPublicMessagesFromServer:[FBDataProvider sharedInstance].session.servername
                     withCompletionHandler:^(NSArray *result, NSError *error) {
                         
                         self.tweets = [[NSMutableArray alloc] init];
                         
                         for (int i = 0; i < 2 ; i++){
                             NSDictionary *tweet = result[i];
                             NSMutableDictionary *mutableTweet = [tweet mutableCopy];
                             
                             [self loadImageForUserName:[tweet objectForKey:@"by"]
                                  withCompletionHandler:^(NSDictionary *result, NSError *error) {
                                      [mutableTweet addEntriesFromDictionary:result];
                                      [self.tweets addObject:mutableTweet];
                                  }];
                         }
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
