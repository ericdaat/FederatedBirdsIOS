//
//  FBDataProvider.h
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 17/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSession.h"

#define kFBDataProviderAuthenticated @"kFBDataProviderAuthenticated"
#define serverURL @"@sio.lab.corp.abelionni.com"
#define robohash @"https://robohash.org/"

@interface FBDataProvider : NSObject

@property FBSession *session;

+ (instancetype) sharedInstance;

- (void) authenticateWithHandle:(NSString *)handle andPassword:(NSString *)password;

@end
