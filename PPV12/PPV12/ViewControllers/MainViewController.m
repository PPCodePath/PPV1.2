//
//  MainViewController.m
//  PPV12
//
//  Created by Xiaolong Zhang on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Venmo+Enhanced.h"
#import "UserForView.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) NSMutableArray *friendsList;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *moneyPanGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImageView;
@property (strong, nonatomic) NSMutableArray *friendsObjList;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add pan gesture to pay friend
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragToPay:)];
    [self.moneyImageView addGestureRecognizer:panGes];
    
    // Setup logout bar button
    UIBarButtonItem* rightNavButton=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = rightNavButton;
    
    if (![Venmo isVenmoAppInstalled]) {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    }
    else {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
    }
    self.friendsObjList = [NSMutableArray array];
    
    // Get list of friends
    [[Venmo sharedInstance] getFriendsWithLimit:[NSNumber numberWithInt:100] beforeUserID:nil afterUserID:nil completionHandler:^(id object, BOOL success, NSError *error) {
        if (success) {
            self.friendsList = object[@"data"];
            NSLog(@"%@", object);
            int count = 0;
            for (NSDictionary *userDict in self.friendsList) {
                UserForView *user = [[UserForView alloc] initWithDictionary:userDict :count];
                [self.friendsObjList addObject:user];
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(user.xLocation, user.yLocation, 48, 48)];
                [imgView setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
                [self.view addSubview:imgView];
                ++count;
            }
            
        }
    }];
}

- (void)dragToPay:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"start");
    } else if (recognizer.state ==UIGestureRecognizerStateChanged) {
        self.moneyImageView.center = CGPointMake(point.x, point.y);
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        for (UserForView *user in self.friendsObjList) {
            if (self.moneyImageView.center.x >= user.xLocation
                && self.moneyImageView.center.x <= (user.xLocation+48)
                && self.moneyImageView.center.y >= user.yLocation
                && self.moneyImageView.center.y <= (user.yLocation+48)) {
                [self sendMoneyTo:user];
            }
        }
    }
}

// Logout
- (IBAction)logout:(id)sender {
    [[Venmo sharedInstance] logout];
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

// Send money
- (void)sendMoneyTo:(UserForView *)user{
    // dismiss keyboard
    [self.view endEditing:YES];
    
    [[Venmo sharedInstance] sendPaymentTo:user.userId
                                   amount:self.amountTextField.text.floatValue*100 // this is in cents!
                                     note:@"payment sent again"
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful payment"
                                                                                message:[NSString stringWithFormat:(@"%@ has received %@ from you"), user.userName, self.amountTextField.text]
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Transaction succeeded!");
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
}

// Request money
- (IBAction)requestAction:(id)sender {
    // replace this user with a prameter
    UserForView *user = [[UserForView alloc] init];
    // dismiss keyboard
    [self.view endEditing:YES];
    [[Venmo sharedInstance] sendRequestTo:user.userName
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
