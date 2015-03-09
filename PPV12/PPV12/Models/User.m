//
//  User.m
//  PPV12
//
//  Created by Mamuad, Christian on 3/8/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSString*) primaryKey{
    return @"id";
}


-  (NSArray*) transactionsSent{
    return [self linkingObjectsOfClass:@"Transaction" forProperty:@"sender"];
}

- (NSArray*) transactionsReceived {
    return [self linkingObjectsOfClass:@"Transaction" forProperty:@"receiver"];
}


+(void) save: (User *) obj {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [User createOrUpdateInRealm:realm withObject:obj];
    [realm commitWriteTransaction];
}

+(void) delete: (User *) obj{
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject: obj];
    [realm commitWriteTransaction];
}

@end
