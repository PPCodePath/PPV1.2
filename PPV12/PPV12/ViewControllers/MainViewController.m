//
//  MainViewController.m
//  PPV12
//
//  Created by Xiaolong Zhang on 3/9/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//
#define IMAGE_SIZE 64
#import "MainViewController.h"
#import "LoginViewController.h"
#import "Venmo+Enhanced.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "CanvasViewController.h"


@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *canvasContainerView;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cashImageView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *mainPanRecognizer;
@property CGPoint originalCenter;
@property CGPoint cashImageViewCenter;


@end

@implementation MainViewController

-(id) initWithNewCanvasController {
    self = [self init];
    if(self) {
        self.canvasController =  [[CanvasViewController alloc] init];
        self.canvasContainerView = [[UIScrollView alloc] init];
    }
    return self;
}

-(id) initWithCanvasController: (CanvasViewController*) canvasController {
    self = [self init];
    if(self){
        self.canvasController = canvasController;
        self.canvasContainerView = [[UIScrollView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.canvasContainerView addSubview:self.canvasController.view];
    [self addChildViewController:self.canvasController];
    [self.canvasController didMoveToParentViewController:self];
    
    if (![Venmo isVenmoAppInstalled]) {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    }
    else {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
    }
    self.originalCenter = self.amountTextField.center;
    self.cashImageViewCenter = self.cashImageView.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //support the Pay functionality
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestPayNotification:)
                                                 name:@"RequestNotification"
                                               object:nil];

    self.canvasContainerView.canCancelContentTouches = YES;
}

- (IBAction)logout:(id)sender {
    [[Venmo sharedInstance] logout];
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)dragToPay:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"start");
    } else if (recognizer.state ==UIGestureRecognizerStateChanged) {
        self.cashImageView.center = CGPointMake(point.x, point.y);
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint pointInCurrentView = [self.canvasContainerView convertPoint:self.cashImageView.center fromView:self.canvasContainerView.superview ];
      
        CGPoint scrollViewPoint = [self.canvasContainerView.subviews[0] convertPoint:pointInCurrentView fromView:self.canvasContainerView];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.amountTextField.text forKey:@"amount"];
        [dict setValue:@"Awesome Client" forKey:@"message"];
        [dict setValue: [NSValue valueWithCGPoint:scrollViewPoint] forKey:@"location"];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"PayNotification"
         object:self
         userInfo:dict];

        self.cashImageView.center = self.cashImageViewCenter;
    }
    
}

- (void) requestPayNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"RequestNotification"])
        NSLog (@"Successfully received the request notification!");
    NSDictionary *userInfo = notification.userInfo;
    CGPoint points = [[userInfo valueForKey:@"location"] CGPointValue];
    NSLog(@"Dropped Position: X:%f Y:%f", points.x, points.y);
    double x = self.cashImageView.frame.origin.x;
    double y = self.cashImageView.frame.origin.y;
    
    NSLog(@"Image Position: X: %f, Y:%f", x, y);
    if(points.x >= x
       && points.x <= (x+IMAGE_SIZE)
       && points.y >= y
       && points.y <= y + IMAGE_SIZE){
        NSString* venmoId = [userInfo valueForKey:@"venmoId"];
        NSString* venmoDisplayName = [userInfo valueForKey:@"venmoDisplayName"];
        NSLog(@"Amount: %@, Message: %@, VenmoId: %@, VenmoDisplayName: %@", self.amountTextField.text, @"",venmoId, venmoDisplayName);
//             [[Venmo sharedInstance] sendRequestTo:venmoId
//                                            amount:self.amountTextField.text
//                                             note:@""
//                                completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
//                                    if (success) {
//                                        NSLog(@"Request Transaction succeeded!");
//                                    }
//                                    else {
//                                        NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
//                                    }
//                                }];
    }
    NSLog(@"-------");
    NSLog(@"   ");
}


- (void)keyboardDidShow:(NSNotification *)note
{
    self.amountTextField.center = CGPointMake(self.originalCenter.x, 320);
}

- (void)keyboardDidHide:(NSNotification *)note
{
      self.amountTextField.center = self.originalCenter;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
