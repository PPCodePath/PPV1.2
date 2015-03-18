//
//  Venmo+Enhanced.m
//  PPV12
//
//  Created by Chris Mamuad on 3/11/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "Venmo+Enhanced.h"
#import "AFNetworking.h"

@implementation Venmo (Enhanced)


#pragma mark - Friends

- (void) getFriendsWithLimit:(NSNumber *)limit beforeUserID:(NSString *)beforeUserID afterUserID:(NSString *)afterUserID completionHandler:(VENGenericRequestCompletionHandler)handler {
    
    [self validateAPIRequestWithCompletionHandler:handler];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (limit)
        parameters[@"limit"] = [limit stringValue];
    if (beforeUserID)
        parameters[@"before"] = beforeUserID;
    if (afterUserID)
        parameters[@"after"] = afterUserID;
    
    [[VENCore defaultCore].httpClient GET:[NSString stringWithFormat:@"users/%@/friends", self.session.user.externalId] parameters:parameters success:^(VENHTTPResponse *response) {
        handler(response.object, YES, nil);
    } failure:^(VENHTTPResponse *response, NSError *error) {
        handler(response, NO, error);
    }];
}


- (void) getTransactionsWithLimit:(NSNumber *)limit before:(NSString *)beforeDate after:(NSString *)afterDate completionHandler:(VENGenericRequestCompletionHandler)handler {
    
    [self validateAPIRequestWithCompletionHandler:handler];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (limit)
        parameters[@"limit"] = [limit stringValue];
    if (beforeDate)
        parameters[@"before"] = beforeDate;
    if (afterDate)
        parameters[@"after"] = afterDate;
    
    [[VENCore defaultCore].httpClient GET:@"payments" parameters:parameters success:^(VENHTTPResponse *response) {
        handler(response.object, YES, nil);
    } failure:^(VENHTTPResponse *response, NSError *error) {
        handler(response, NO, error);
    }];
}

-(void)GetTransactionListWithLimit:(int)limit before:(NSString *)beforeDate after:(NSString *)afterDate
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *accessToken = [NSString stringWithFormat:@"Bearer %@", [[Venmo sharedInstance] session].accessToken];
    NSString *baseUrl = @"https://api.venmo.com/v1/payments";
    NSString *url;
    if (beforeDate) {
        url = [NSString stringWithFormat:@"%@?limit=%d&before=%@", baseUrl, limit, beforeDate];
    } else {
        url = [NSString stringWithFormat:@"%@?limit=%d", baseUrl, limit];
    }
    
    [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"Authorization"];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             success(operation, responseObject);
             NSLog(@"JSON: %@", responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(operation, error);
             NSLog(@"Error: %@", error);
         }];
}




@end
