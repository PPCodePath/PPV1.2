//
//  CanvasViewController.m
//  PPV12
//
//  Created by Mamuad, Christian on 3/12/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "CanvasViewController.h"
#import "Venmo+Enhanced.h"
#import "User.h"
#import "BubbleViewController.h"

@interface CanvasViewController ()
@property (strong, nonatomic) IBOutlet UIView *canvasView;
@property (strong, nonatomic) NSMutableArray *friendsList;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *recognizer;
@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    // Get list of friends
    [[Venmo sharedInstance] getFriendsWithLimit:[NSNumber numberWithInt:100] beforeUserID:nil afterUserID:nil completionHandler:^(id object, BOOL success, NSError *error) {
        if (success) {
            self.friendsList = object[@"data"];
            NSLog(@"%@", object);
            int count = 0;
            for (NSDictionary *userDict in self.friendsList) {
                User* user = [[User alloc] initWithDictionary:userDict];
                BubbleViewController* bubbleViewController = [[BubbleViewController alloc] initWithUser:user withPosition:count];
               [self.canvasView addSubview:bubbleViewController.view];
               [self addChildViewController:bubbleViewController];
                ++count;
            }
            int y = 90 * (count/6 + 1) + 105;
            NSLog(@"HEIGHT OF ScrollView: %d", y);
            self.canvasView.frame = CGRectMake(0, 0, 720, y);
            UIScrollView* scroll = (UIScrollView*) self.canvasView.superview;
            scroll.contentSize = CGSizeMake(720, y);
        }
    }];
   
    //long press underneath
    [self.canvasView setUserInteractionEnabled:YES];
    self.view = self.canvasView;
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"On Pan Gesture called for canvasView");
    CGPoint translation = [self.recognizer translationInView:self.canvasView];
    CGPoint point = [self.recognizer locationInView:self.canvasView.superview];
    NSLog(@"Drop Unchanged Position: X: %f, Y:%f", point.x, point.y);
    NSLog(@"CanvasView Position: X:%f, Y:%f", self.canvasView.frame.origin.x, self.canvasView.frame.origin.y);
            double x = self.recognizer.view.center.x+translation.x;
            double y = self.recognizer.view.center.y+translation.y;
            self.recognizer.view.center=CGPointMake(x, y);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue: [NSValue valueWithCGPoint:self.recognizer.view.center] forKey:@"location"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PanScrollViewNotification" object:self userInfo:dict];
    
    [self.recognizer setTranslation:CGPointMake(0, 0) inView:self.recognizer.view];
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
