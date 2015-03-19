//
//  LoginViewController.m
//  PPV12
//
//  Created by Xiaolong Zhang on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "LoginViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import "MainViewController.h"
#import "ContainerViewController.h"
#import "MenuViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile,
                                                 VENPermissionAccessFriends]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                 NSLog(@"success");
                                 MainViewController *mainViewController = [[MainViewController alloc] initWithNewCanvasController];
                                 MenuViewController *menuViewController = [[MenuViewController alloc] init];
                                 
                                 UINavigationController *mainViewNavigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
                                 UINavigationController *menuViewNavigation = [[UINavigationController alloc] initWithRootViewController:menuViewController];
                                 
                                 ContainerViewController *containerViewController = [[ContainerViewController alloc] initWithContentController:mainViewNavigation withMenu:menuViewNavigation];
                                 
                                 mainViewController.delegate = containerViewController;
                                 menuViewController.delegate = containerViewController;
                        
                                 [self presentViewController:containerViewController animated:YES completion:nil];
                             }
                             else {
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization failed"
                                                                                     message:error.localizedDescription
                                                                                    delegate:self
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                 [alertView show];
                             }
                         }];

}

@end
