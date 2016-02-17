//
//  FBDataProvider.m
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 17/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import "FBDataProvider.h"


@implementation FBDataProvider

- (void) authenticateWithHandle:(NSString *)handle andPassword:(NSString *)password {
    self.session = [FBSession prepareSessionForHandle:handle];
    
    [self.session authenticateWithPassword:password withCompletionHandler:^(NSError *error) {
        if (!error) {
            //post a notification saying we are authenticated
            [[NSNotificationCenter defaultCenter] postNotificationName:kFBDataProviderAuthenticated
                                                                object:nil];
        }
    }];
}

+ (instancetype) sharedInstance {
    static id sharedInstanceFBDataProvider = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstanceFBDataProvider = [self new];
    });
    return sharedInstanceFBDataProvider;
}

@end
