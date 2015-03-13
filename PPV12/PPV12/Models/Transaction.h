//
//  Transaction.h
//  PPV12
//
//  Created by Mamuad, Christian on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * transactionType;
@property (nonatomic, retain) NSOrderedSet *receiver;
@property (nonatomic, retain) NSOrderedSet *sender;
@property (nonatomic, retain) NSString *paymentId;
@property (nonatomic, retain) NSString* message;
@end

@interface Transaction (CoreDataGeneratedAccessors)

- (void)insertObject:(User *)value inReceiverAtIndex:(NSUInteger)idx;
- (void)removeObjectFromReceiverAtIndex:(NSUInteger)idx;
- (void)insertReceiver:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeReceiverAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInReceiverAtIndex:(NSUInteger)idx withObject:(User *)value;
- (void)replaceReceiverAtIndexes:(NSIndexSet *)indexes withReceiver:(NSArray *)values;
- (void)addReceiverObject:(User *)value;
- (void)removeReceiverObject:(User *)value;
- (void)addReceiver:(NSOrderedSet *)values;
- (void)removeReceiver:(NSOrderedSet *)values;
- (void)insertObject:(User *)value inSenderAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSenderAtIndex:(NSUInteger)idx;
- (void)insertSender:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSenderAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSenderAtIndex:(NSUInteger)idx withObject:(User *)value;
- (void)replaceSenderAtIndexes:(NSIndexSet *)indexes withSender:(NSArray *)values;
- (void)addSenderObject:(User *)value;
- (void)removeSenderObject:(User *)value;
- (void)addSender:(NSOrderedSet *)values;
- (void)removeSender:(NSOrderedSet *)values;

/*
 Helper methods
 */

-(id) initWithDictionary:(NSDictionary*) dictionary;
+(NSMutableArray*) initWithArrayOfDictionary:(NSArray*) arr;
@end
