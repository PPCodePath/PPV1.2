//
//  Transaction.m
//  PPV12
//
//  Created by Mamuad, Christian on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "Transaction.h"
#import "User.h"
#import "CoreDataHelper.h"
#import "Venmo+Enhanced.h"

@implementation Transaction

@dynamic amount;
@dynamic sendDate;
@dynamic status;
@dynamic transactionType;
@dynamic receiver;
@dynamic sender;
@dynamic paymentId;
@dynamic message;


-(id) initWithDictionary:(NSDictionary*) dictionary{
    CoreDataHelper* dataHelper = [CoreDataHelper getInstance];
    self = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:dataHelper.context];
    if(self){
        [self setAmount:[NSDecimalNumber decimalNumberWithString:dictionary[@"amount"]]];
        [self setStatus:dictionary[@"status"]];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yyyy"];
        
        [self setPaymentId:dictionary[@"payment_id"]];
        [self setSendDate:[df dateFromString:dictionary[@"date_completed"]]];
        User* receiver = [[User alloc] initWithDictionary:dictionary[@"target"][@"user"]];
        NSMutableOrderedSet* receiverSet = [[NSMutableOrderedSet alloc] initWithObject:receiver ];
        [self setReceiver: receiverSet];
        [self setMessage:dictionary[@"note"]];
        User* sender = [[User alloc] initWithDictionary:dictionary[@"actor"]];
        NSMutableOrderedSet* senderSet = [[NSMutableOrderedSet alloc] initWithObject:sender];
        [self setSender: senderSet];
    }
    return self;
}


+(NSMutableArray*) initWithArrayOfDictionary:(NSArray*) arr{
    NSMutableArray* transactions = [[NSMutableArray alloc] init];
    for (NSDictionary* obj in arr) {
        Transaction* trans = [[Transaction alloc] initWithDictionary:obj];
        [transactions addObject:trans];
    }
 
    CoreDataHelper* dataHelper = [CoreDataHelper getInstance];
    NSError *error = nil;
    [dataHelper.context save:&error];

    return transactions;
}
@end
