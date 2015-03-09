//
//  User.h
//  PPV12
//
//  Created by Mamuad, Christian on 3/8/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "RLMObject.h"
#import <Realm/Realm.h>

@interface User : RLMObject
@property NSInteger id;
@property NSString* firstName;
@property NSString* lastName;
@property NSString* displayName;
@property NSString* emailAddress;
@property NSString* phoneNumber;
@property NSString* facebookId;
@property NSString* venmoId;
@property NSString* backgroundImageUrl;
@property NSString* profileImageUrl;
@property NSDate* creationDate;

//not sure about these
@property User* userFriend;
@property (readonly) NSArray *transactionsSent;
@property (readonly) NSArray *transactionsReceived;
@end
