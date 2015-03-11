//
//  ContainerViewController.h
//  PPV12
//
//  Created by Mamuad, Christian on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewDelegate.h"

@interface ContainerViewController : UIViewController <ContainerViewDelegate>

@property (nonatomic) UIViewController* menuViewController;
@property (nonatomic) UIViewController* contentViewController;

-(id) initWithContentController: (UIViewController*) contentController withMenu: (UIViewController*) menuController;
@end
