//
//  MainViewController.h
//  PPV12
//
//  Created by Xiaolong Zhang on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewDelegate.h"

@interface MainViewController : UIViewController
@property (nonatomic, weak) id<ContainerViewDelegate> delegate;
@end
