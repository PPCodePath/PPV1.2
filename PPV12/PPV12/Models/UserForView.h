//
//  UserForView.h
//  PPV12
//
//  Created by Xiaolong Zhang on 3/11/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserForView : NSObject

@property (nonatomic, assign) double xLocation;
@property (nonatomic, assign) double yLocation;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *profileImageURL;

- (id)initWithDictionary:(NSDictionary *)dictionary :(int)count;
@end
