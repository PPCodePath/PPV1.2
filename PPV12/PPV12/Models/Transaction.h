//
//  Transaction.h
//  PPV12
//
//  Created by Mamuad, Christian on 3/8/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "RLMObject.h"
#import "User.h"
#import <Realm/Realm.h>

@interface Transaction : RLMObject
@property NSInteger id;
@property User* sender;
@property User* receiver;
@property double amount;
@property NSDate* sendDate;
@property NSString* status; //pending, done, cancelled, settled
@property NSString* transactionType; //SendMoney/RequestMoney
@end
