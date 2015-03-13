//
//  User.h
//  PPV12
//
//  Created by Mamuad, Christian on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * backgroundImageUrl;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * facebookId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * profileImageUrl;
@property (nonatomic, retain) NSString * venmoId;
@property (nonatomic, retain) Transaction *transactionsReceived;
@property (nonatomic, retain) Transaction *transactionsSent;


-(id) initWithDictionary:(NSDictionary*) dictionary;
+(NSMutableArray*) initWithArrayOfDictionary:(NSArray*) arr;
@end
