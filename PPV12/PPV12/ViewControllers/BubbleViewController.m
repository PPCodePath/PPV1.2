//
//  BubbleViewController.m
//  PPV12
//
//  Created by Chris Mamuad on 3/14/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//
#define IMAGE_SIZE 80
#define LARGE_IMAGE_SIZE 90

#import "BubbleViewController.h"
#import "Venmo+Enhanced.h"

@interface BubbleViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) UIView *currentParent;
@property (strong, nonatomic) IBOutlet UILabel *displayName;
@property CGPoint location;
@property CGFloat zPosition;

@end

@implementation BubbleViewController


-(id) initWithUser:(User*) user withPosition:(int) position{
    self = [self init];
    if(self){
        self.user = user;
        double x;
        double y;
        if((position/6) %2 == 1){
            x = 90 * (position%6) + 50;
        }else{
            x = 90 * (position%6)+10;
        }
        y = 90 * (position/6) +10 ;
        
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x,y, IMAGE_SIZE, IMAGE_SIZE)];
        self.location = self.userImageView.center;
        [self.userImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
        [self setRoundedCornersWithBubbleView];
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
        
        [self.userImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [self.userImageView.layer setBorderWidth:1.0];
        
        self.displayName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        self.displayName.textColor = [UIColor greenColor];
        self.displayName.backgroundColor = [UIColor clearColor];
        self.displayName.text = self.user.displayName;
        self.displayName.alpha = 0;
        self.displayName.font = [UIFont fontWithName:@"ProximaNovaSemibold" size:10];
        CGRect frame = self.displayName.frame;
        frame.origin = CGPointMake(0,40);
        self.displayName.frame = frame;
        
        [self.userImageView addSubview:self.displayName];
        self.view = self.userImageView;
        [self.view addGestureRecognizer:self.tapRecognizer];
        [self.view addGestureRecognizer:self.panRecognizer];
        [self.view setUserInteractionEnabled:YES];
        [self.view setExclusiveTouch:YES];
        self.zPosition = self.view.layer.zPosition;
        //support the Pay functionality
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePayNotification:)
                                                     name:@"PayNotification"
                                                   object:nil];
        //support the Pan functionality
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(panScrollViewNotification:)
                                                     name:@"PanScrollViewNotification"
                                                   object:nil];
        //support the UnTap functionality
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(unTapNotification:)
                                                     name:@"UnTapNotification"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    NSLog(@"onTap for BubbleViewController triggered.");
    [self selectIcon];
    //Send Notification
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.user.venmoId forKey:@"venmoId"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UnTapNotification"
     object:self
     userInfo:dict];

}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"On Pan Gesture called for bubbleView");
    CGPoint point = [self.panRecognizer locationInView:self.view.superview];

    if (self.panRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"start friendIcon Panning");
        self.currentParent = self.userImageView.superview;
        UIView* grandparent = self.currentParent.superview;
        UIView* greatgrandparent = grandparent.superview;
        [self selectIcon];
        [greatgrandparent addSubview: self.userImageView];
        self.userImageView.layer.zPosition = MAXFLOAT;
        

    } else if (self.panRecognizer.state ==UIGestureRecognizerStateChanged) {
        self.userImageView.center = CGPointMake(point.x, point.y);
    } else if (self.panRecognizer.state == UIGestureRecognizerStateEnded) {
        //send notification
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.user.venmoId forKey:@"venmoId"];
        [dict setValue:self.user.displayName forKey:@"venmoDisplayName"];
        [dict setValue: [NSValue valueWithCGPoint:self.userImageView.center] forKey:@"location"];

        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"RequestNotification"
         object:self
         userInfo:dict];

        [self resetIcon];
        [self.currentParent addSubview:self.userImageView];
        self.userImageView.center = self.location;
        self.userImageView.layer.zPosition = self.zPosition;
    }
}



- (void) unTapNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"UnTapNotification"]){
        NSLog (@"Successfully received the UnTap notification!");
    
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSString* venmoId = [userInfo valueForKey:@"venmoId"];
    
    if(! [self.user.venmoId isEqualToString:venmoId]){
        [self resetIcon];
    }
}


- (void) receivePayNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"PayNotification"]){
        NSLog (@"Successfully received the pay notification!");
    NSDictionary *userInfo = notification.userInfo;
    CGPoint points = [[userInfo valueForKey:@"location"] CGPointValue];
    NSLog(@"Dropped Position: X:%f Y:%f", points.x, points.y);
    NSLog(@"Image Position: X: %f, Y:%f", self.userImageView.frame.origin.x, self.userImageView.frame.origin.y);
    NSLog(@"Name: %@", self.user.displayName);
    double x = self.userImageView.frame.origin.x;
    double y = self.userImageView.frame.origin.y;
    if(points.x >= x
       && points.x <= (x+IMAGE_SIZE)
       && points.y >= y
       && points.y <= y + IMAGE_SIZE){
        NSString* amount = [userInfo valueForKey:@"amount"];
        NSString* message = [userInfo valueForKey:@"message"];
    
        NSLog(@"Amount: %@, Message: %@, name: %@", amount, message, self.user.displayName);
//     [[Venmo sharedInstance] sendPaymentTo:self.user.venmoId
//                                   amount:amount
//                                     note:message
//                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
//                            if (success) {
//                                NSLog(@"Transaction succeeded!");
//                            }
//                            else {
//                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
//                            }
//                        }];
        
        [self selectIcon:YES];
        }

      
    }
}

- (void) panScrollViewNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"PanScrollViewNotification"])
        NSLog (@"Successfully received the pan scroll Notification!");
 
    UIView* gp = self.userImageView.superview;
    UIView* ggp = gp.superview;
    
    CGPoint pointInCurrentView = [ggp convertPoint:self.userImageView.center fromView:gp];
    NSLog(@"Name: %@, X: %f, Y:%f", self.user.displayName, pointInCurrentView.x, pointInCurrentView.y);
    if(pointInCurrentView.x < 50 || pointInCurrentView.y < 50 || pointInCurrentView.x > 320 || pointInCurrentView.y > 482){
        [self fadeOutIcon];
    }else{
        [self fadeInIcon];
    }
    
    
}



-(void) setRoundedCornersWithBubbleView{
    CALayer* layer = [self.userImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:40.0];
    
}

-(void) fadeOutIcon{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.userImageView setAlpha:0.2];                         }
                     completion:^(BOOL finished){
                     }];
}

-(void) fadeInIcon{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.userImageView setAlpha:1];
                     }
                     completion:^(BOOL finished){
                     }];
    

}

-(void) resetIcon{
    [self.userImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.userImageView.layer setBorderWidth:1.0];
    [UIView animateWithDuration:1.0f
                     animations:^{
                         CGRect frame = self.userImageView.frame;
                         frame.size.width = IMAGE_SIZE;
                         frame.size.height = IMAGE_SIZE;
                         self.userImageView.frame = frame;
                         self.displayName.alpha = 0;
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void) selectIcon{
    [self selectIcon:NO];
}

-(void) selectIcon: (BOOL) reset{
    [self.userImageView.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [self.userImageView.layer setBorderWidth:2.0];
    [UIView animateWithDuration:1.0f
                     animations:^{
                         CGRect frame = self.userImageView.frame;
                         frame.size.width = LARGE_IMAGE_SIZE;
                         frame.size.height = LARGE_IMAGE_SIZE;
                         self.userImageView.frame = frame;
                         self.displayName.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         if(reset){
                             [self resetIcon];
                         }
                     }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
