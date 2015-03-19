//
//  BubbleViewController.h
//  PPV12
//
//  Created by Chris Mamuad on 3/14/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface BubbleViewController : UIViewController
//Properties

//Method Signatures
-(id) initWithUser:(User*) user withPosition:(int) position;

@end
