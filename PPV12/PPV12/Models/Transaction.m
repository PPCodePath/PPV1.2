//
//  Transaction.m
//  PPV12
//
//  Created by Mamuad, Christian on 3/8/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction
+ (NSString*) primaryKey{
    return @"id";
}



+(void) save: (Transaction *) obj {
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [Transaction createOrUpdateInRealm:realm withObject:obj];
    [realm commitWriteTransaction];
}

+(void) delete: (Transaction*) obj{
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject: obj];
    [realm commitWriteTransaction];
}



@end
