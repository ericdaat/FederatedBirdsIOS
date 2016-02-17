//
//  FBSession.m
//  DataTest
//
//  Created by Yoann Gini on 16/02/2016.
//  Copyright © 2016 Yoann Gini. All rights reserved.
//

#import "FBSession.h"

@interface FBSession()
@property (readwrite) BOOL authenticated;
@property (readwrite) NSString *username;
@property (readwrite) NSString *servername;
@property (readwrite) NSString *token;
@end

@implementation FBSession


+ (NSString*)usernameNameForHandle:(NSString*)handle{
    
    return [[handle componentsSeparatedByString:@"@"] firstObject];
}


+ (NSString*)serverNameForHandle:(NSString*)handle{
    
    return [[handle componentsSeparatedByString:@"@"] lastObject];
}


#pragma mark Unauthenticated actions
+ (void)followersForHandle:(NSString*)handle
     withCompletionHandler:(FBSessionCompletionHandlerWithArray)completionHandler{
    
    NSString *username = [FBSession usernameNameForHandle:handle];
    NSString *servername = [FBSession serverNameForHandle:handle];
    
    NSURLRequest *request = [FBSession getRequestForServer:servername
                                                   andPath:[NSString stringWithFormat:@"%@/followers.json",username]];
    
    [FBSession startJSONTaskWithRequest:request
                   andCompletionHandler:^(NSDictionary *result, NSError *error) {
                       if (error){
                           completionHandler(nil,error);
                       } else {
                           NSArray *followers = [result valueForKey:@"followers"];
                           completionHandler(followers,nil);
                       }
                   }];
}


+ (void)followingsForHandle:(NSString*)handle
      withCompletionHandler:(FBSessionCompletionHandlerWithArray)completionHandler{
    
    NSString *username = [FBSession usernameNameForHandle:handle];
    NSString *servername = [FBSession serverNameForHandle:handle];
    
    NSURLRequest *request = [FBSession getRequestForServer:servername
                                                   andPath:[NSString stringWithFormat:@"%@/followings.json",username]];
    
    [FBSession startJSONTaskWithRequest:request
                   andCompletionHandler:^(NSDictionary *result, NSError *error) {
                       if (error){
                           completionHandler(nil,error);
                       } else {
                           NSArray *followings = [result valueForKey:@"followings"];
                           completionHandler(followings,nil);
                       }
                   }];
}


+ (void)publicMessagesForHandle:(NSString*)handle
          withCompletionHandler:(FBSessionCompletionHandlerWithArray)completionHandler{
    
    NSString *username = [FBSession usernameNameForHandle:handle];
    NSString *servername = [FBSession serverNameForHandle:handle];
    
    NSURLRequest *request = [FBSession getRequestForServer:servername
                                                   andPath:[NSString stringWithFormat:@"%@/tweets.json",username]];
    
    [FBSession startJSONTaskWithRequest:request
                   andCompletionHandler:^(NSDictionary *result, NSError *error) {
                       if (error){
                           completionHandler(nil,error);
                       } else {
                           NSArray *tweets = [result valueForKey:@"tweets"];
                           completionHandler(tweets,nil);
                       }
                   }];
}


+ (void)createAccountWithHandle:(NSString*)handle andPassword:(NSString*)password
          withCompletionHandler:(FBSessionCompletionHandlerWithDictionary)completionHandler{
    
    NSString *username = [FBSession usernameNameForHandle:handle];
    NSString *servername = [FBSession serverNameForHandle:handle];
    
    NSDictionary *body = @{@"handle": username,
                           @"password": password};
    
    NSURLRequest *request = [FBSession postRequestForServer:servername
                                                withContent:body
                                                    andPath:[NSString stringWithFormat:@"users.json"]];
    
    [FBSession startJSONTaskWithRequest:request
                   andCompletionHandler:completionHandler];
}

+ (void)usernamesFromServer:(NSString*)servername
      withCompletionHandler:(FBSessionCompletionHandlerWithArray)completionHandler{
    
    NSURLRequest *request = [FBSession getRequestForServer:servername andPath:[NSString stringWithFormat:@"users.json"]];
    
    
    [FBSession startJSONTaskWithRequest:request andCompletionHandler:^(NSDictionary *result, NSError *error) {
        if (error){
            completionHandler(nil,error);
        } else {
            NSArray *users = [result valueForKey:@"users"];
            completionHandler(users, nil);
        }
    }];
}


+ (void)allPublicMessagesFromServer:(NSString*)servername
              withCompletionHandler:(FBSessionCompletionHandlerWithArray)completionHandler{
    
    NSURLRequest *request = [FBSession getRequestForServer:servername andPath:[NSString stringWithFormat:@"tweets.json"]];
    
    [FBSession startJSONTaskWithRequest:request andCompletionHandler:^(NSDictionary *result, NSError *error) {
        if (error){
            completionHandler(nil,error);
        } else {
            NSArray *tweets = [result valueForKey:@"tweets"];
            completionHandler(tweets, nil);
        }
    }];
}

#pragma mark User session related
- (void)authenticateWithPassword:(NSString*)password
           withCompletionHandler:(FBSessionCompletionHandler)completionHandler{
    
    NSDictionary *body = @{@"handle": self.username,
                           @"password": password};
    
    NSURLRequest *request = [FBSession postRequestForServer:self.servername
                                                withContent:body
                                                    andPath:[NSString stringWithFormat:@"sessions.json"]];
    
    [FBSession startJSONTaskWithRequest:request andCompletionHandler:^(NSDictionary *result, NSError *error) {
        if (error){
            completionHandler(error);
        } else {
            self.token = [result valueForKey:@"token"];
            
            if ([self.token length] > 0){
                self.authenticated = YES;
                
                completionHandler(nil);
            } else {
                completionHandler([[NSError alloc] initWithDomain:@"no token no error" code:0 userInfo:nil]);
            }
        }
    }];
}


- (void)follow:(NSString*)username
        withCompletionHandler:(FBSessionCompletionHandlerWithDictionary)completionHandler{
    
    NSDictionary *body = @{@"handle": username,
                           @"token": self.token};
    
    if ([self.token length] > 0){
        
        NSURLRequest *request = [FBSession postRequestForServer:self.servername
                                                    withContent:body
                                                        andPath:[NSString stringWithFormat:@"%@/followings.json",self.username]];
        
        [FBSession startJSONTaskWithRequest:request
                       andCompletionHandler:completionHandler];
    } else {
        completionHandler(nil, [[NSError alloc] initWithDomain:@"no token, no post"
                                                          code:0
                                                      userInfo:nil]);
    }
    
    
}

- (void)unfollow:(NSString*)username withCompletionHandler:(FBSessionCompletionHandlerWithDictionary)completionHandler{
    NSDictionary *body = @{@"handle": username,
                           @"token": self.token};
    
    if ([self.token length] > 0){
        
        NSURLRequest *request = [FBSession deleteRequestForServer:self.servername
                                                      withContent:body
                                                          andPath:[NSString stringWithFormat:@"%@/followings.json",self.username]];
        
        [FBSession startJSONTaskWithRequest:request
                       andCompletionHandler:completionHandler];
    } else {
        completionHandler(nil, [[NSError alloc] initWithDomain:@"no token, no post"
                                                          code:0
                                                      userInfo:nil]);
    }
}


- (void)postPublicMessage:(NSString*)message
    withCompletionHandler:(FBSessionCompletionHandler)completionHandler {
    
    if ([self.token length] > 0){
        NSDictionary *body = @{@"handle": self.username,
                               @"token": self.token,
                               @"content": message};
        
        NSURLRequest *request = [FBSession postRequestForServer:self.servername
                                                    withContent:body
                                                        andPath:[NSString stringWithFormat:@"%@/tweets.json",self.username]];
        
        [FBSession startJSONTaskWithRequest:request andCompletionHandler:^(NSDictionary *result, NSError *error) {
            if (error){
                completionHandler(error);
            } else {
                completionHandler(nil);
            }
        }];
    } else {
        completionHandler([[NSError alloc] initWithDomain:@"no token" code:0 userInfo:nil]);
    }
}

- (void)readingListWithCompletionHandler:(FBSessionCompletionHandlerWithArray)completionHandler {
    if ([self.token length] > 0) {
        NSURLRequest *request = [FBSession getRequestForServer:self.servername
                                                     withToken:self.token
                                                       andPath:[NSString stringWithFormat:@"%@/reading_list.json", self.username]];
        
        [FBSession startJSONTaskWithRequest:request
                       andCompletionHandler:^(NSDictionary *result, NSError *error) {
                           NSArray *tweets = [result valueForKey:@"tweets"];
                           
                           completionHandler(tweets, nil);
                       }];
    } else {
        completionHandler(nil, [[NSError alloc] initWithDomain:@"no token, no post"
                                                          code:0
                                                      userInfo:nil]);
    }
}

#pragma mark toolbox

+ (NSURLRequest*)getRequestForServer:(NSString*)server andPath:(NSString*)path {
    return [FBSession requestWithMethod:@"GET" forServer:server withContent:nil withPath:path];
}


+ (NSURLRequest*)getRequestForServer:(NSString*)server withToken:(NSString*)token andPath:(NSString*)path {
    NSMutableURLRequest *request = [FBSession requestWithMethod:@"GET" forServer:server withContent:nil withPath:path];
    
    [request setValue:token forHTTPHeaderField:@"X-Token"];
    
    return request;
}


+ (NSURLRequest*)postRequestForServer:(NSString*)server withContent:(NSDictionary*)content andPath:(NSString*)path {
    return [FBSession requestWithMethod:@"POST" forServer:server withContent:content withPath:path];
}


+ (NSURLRequest*)deleteRequestForServer:(NSString*)server withContent:(NSDictionary*)content andPath:(NSString*)path {
    return [FBSession requestWithMethod:@"DELETE" forServer:server withContent:content withPath:path];
}


+ (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                          forServer:(NSString *)servername
                        withContent:(NSDictionary *)content
                           withPath:(NSString *) path{
    
    NSString *string = [NSString stringWithFormat:@"http://%@/api/%@",servername,path];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = method;
    
    if (content){
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content
                                                           options:0
                                                             error:nil];
        
        [request setHTTPBody:jsonData];
    }
    
    return request;
}


+ (instancetype)prepareSessionForHandle:(NSString*)handle{
    
    FBSession *session = [[FBSession alloc] init];
    session.username = [FBSession usernameNameForHandle:handle];
    session.servername = [FBSession serverNameForHandle:handle];
    
    return session;
}

+ (instancetype)sessionForHandle:(NSString*)handle withToken:(NSString *)token{
    FBSession *session = [[FBSession alloc] init];
    session.username = [FBSession usernameNameForHandle:handle];
    session.servername = [FBSession serverNameForHandle:handle];
    
    session.token = token;
    session.authenticated = YES;
    
    return session;
}



+ (void) startJSONTaskWithRequest:(NSURLRequest *)request
             andCompletionHandler:(FBSessionCompletionHandlerWithDictionary)completionHandler{
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     if (error) {
                                                                         //forward errors as much as we can until something can deal with it
                                                                         completionHandler(nil, error);
                                                                     } else if (data){
                                                                         //transform Json to dict
                                                                         NSError *jsonError;
                                                                         NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:&jsonError];
                                                                         if (jsonError){
                                                                             //check errors again
                                                                             completionHandler(nil,jsonError);
                                                                         } else {
                                                                             completionHandler(info,nil);
                                                                         }
                                                                         
                                                                     } else {
                                                                         //no error and no data
                                                                         completionHandler(nil,nil);
                                                                     }
                                                                 }];
    
    [task resume];
    
}

@end
