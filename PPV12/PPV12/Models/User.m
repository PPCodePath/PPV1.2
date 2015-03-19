//
//  User.m
//  PPV12
//
//  Created by Mamuad, Christian on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//
#import "CoreDataHelper.h"
#import "User.h"
#import "Transaction.h"


@implementation User

@dynamic backgroundImageUrl;
@dynamic displayName;
@dynamic emailAddress;
@dynamic facebookId;
@dynamic firstName;
@dynamic lastName;
@dynamic phoneNumber;
@dynamic profileImageUrl;
@dynamic venmoId;
@dynamic transactionsReceived;
@dynamic transactionsSent;

-(id) initWithDictionary:(NSDictionary*) dictionary{
    CoreDataHelper* dataHelper = [CoreDataHelper getInstance];
    self = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:dataHelper.context];
    if(self){
        [self setFirstName:dictionary[@"first_name"]];
        [self setLastName:dictionary[@"last_name"]];
        [self setVenmoId:dictionary[@"id"]];
        [self setDisplayName:dictionary[@"display_name"]];
        [self setProfileImageUrl:dictionary[@"profile_picture_url"]];
    }
    NSError* error;
    [dataHelper.context save:&error];
    return self;
}

+(NSMutableArray*) initWithArrayOfDictionary:(NSArray*) arr{
    NSMutableArray* users = [[NSMutableArray alloc] init];
    for (NSDictionary* obj in arr) {
        User* user = [[User alloc] initWithDictionary:obj];
        [users addObject:user];
    }
    return users;
}
@end
