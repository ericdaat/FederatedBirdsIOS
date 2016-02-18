//
//  CommonTableViewController.h
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 17/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSession.h"
#import "FBDataProvider.h"
#import "UserDetailViewController.h"

#define robohash @"https://robohash.org/"
#define serverURL @"@sio.lab.corp.abelionni.com"

@interface CommonTableViewController : UITableViewController

@property NSArray *tweets;

- (void)reloadTweetsForDisplay;
@end


