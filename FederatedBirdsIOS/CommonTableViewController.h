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


@interface CommonTableViewController : UITableViewController

@property NSArray *tweets;

- (void)reloadTweetsForDisplay;
@end


