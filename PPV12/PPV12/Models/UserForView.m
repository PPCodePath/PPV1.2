//
//  UserForView.m
//  PPV12
//
//  Created by Xiaolong Zhang on 3/11/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "UserForView.h"

@implementation UserForView

- (id)initWithDictionary:(NSDictionary *)dictionary :(int)count {
    self = [super init];
    if (self) {
        self.userName = dictionary[@"username"];
        self.userId = dictionary[@"id"];
        self.profileImageURL = dictionary[@"profile_picture_url"];
        double xLocation = 50 * (count%6) + 10;
        double yLocation = 60 * (count/6 + 1) + 85;
        self.xLocation = xLocation;
        self.yLocation = yLocation;
    }
    return self;
}

@end
