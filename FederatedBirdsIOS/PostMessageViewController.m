//
//  PostMessageViewController.m
//  FederatedBirdsIOS
//
//  Created by Eric Daoud Attoyan on 17/02/16.
//  Copyright © 2016 Eric Daoud Attoyan. All rights reserved.
//

#import "PostMessageViewController.h"

@interface PostMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property id keyboardWillShowObserver;
@property id keyboardWillHideObserver;
@property UIEdgeInsets defaultContentInset;
@property BOOL defaultContentInsetStored;

@end

@implementation PostMessageViewController

- (void)postMessage {
    [[FBDataProvider sharedInstance].session postPublicMessage:self.messageTextView.text
                                         withCompletionHandler:^(NSError *error) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [[self navigationController ] popToRootViewControllerAnimated:YES];
                                             });
                                         }];
}


-(void)viewWillAppear:(BOOL)animated {
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(postMessage)];
}

@end
