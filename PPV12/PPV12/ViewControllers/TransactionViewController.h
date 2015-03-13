//
//  TransactionViewController.h
//  PPV12
//
//  Created by Chris Mamuad on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewDelegate.h"

@interface TransactionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<ContainerViewDelegate> delegate;
@end
