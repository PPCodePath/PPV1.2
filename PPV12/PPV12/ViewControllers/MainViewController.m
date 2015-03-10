//
//  MainViewController.m
//  PPV12
//
//  Created by Xiaolong Zhang on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup bar button
    UIBarButtonItem* rightNavButton=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = rightNavButton;
    
    // grab current logged in user
//    VENUser *user = [[Venmo sharedInstance] session].user;
    //    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    
    if (![Venmo isVenmoAppInstalled]) {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    }
    else {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
    }
}

- (IBAction)logout:(id)sender {
    [[Venmo sharedInstance] logout];
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}
- (IBAction)payAction:(id)sender {
    // dismiss keyboard
    [self.view endEditing:YES];
    [[Venmo sharedInstance] sendPaymentTo:self.emailPhoneNumberTextField.text
                                   amount:self.amountTextField.text.floatValue*100 // this is in cents!
                                     note:@"a better Venmo client"
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
                                
                                NSLog(@"Transaction succeeded!");
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
}

- (IBAction)requestAction:(id)sender {
    // dismiss keyboard
    [self.view endEditing:YES];
    [[Venmo sharedInstance] sendRequestTo:self.emailPhoneNumberTextField.text
                                   amount:self.amountTextField.text.floatValue*100
                                     note:@"a better Venmo client"
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
                                
                                NSLog(@"Request succeeded!");
                            }
                            else {
                                NSLog(@"Request failed with error: %@", [error localizedDescription]);
                            }
                        }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
