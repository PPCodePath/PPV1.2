//
//  Venmo+Enhanced.h
//  PPV12
//
//  Created by Chris Mamuad on 3/11/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "Venmo.h"

@interface Venmo (Enhanced)
/**
 + * get the complete list of all friends
 + */
- (void)validateAPIRequestWithCompletionHandler:(VENGenericRequestCompletionHandler)handler;

- (void)getFriendsWithLimit:(NSNumber *)limit beforeUserID:(NSString *)beforeUserID afterUserID:(NSString *)afterUserID completionHandler:(VENGenericRequestCompletionHandler) handler;
- (void) getTransactionsWithLimit:(NSNumber *)limit before:(NSString *)beforeDate after:(NSString *)afterDate completionHandler:(VENGenericRequestCompletionHandler)handler;
@end
