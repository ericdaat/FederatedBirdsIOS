//
//  UserDetailViewController.h
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 18/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBDataProvider.h"

@interface UserDetailViewController : UIViewController <UITableViewDataSource>
@property NSString *username;
@property UIImage *avatar;
@property NSArray *tweets;


@end
