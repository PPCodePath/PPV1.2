//
//  ContainerViewController.m
//  PPV12
//
//  Created by Mamuad, Christian on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "TransactionViewController.h"

@interface ContainerViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) CGPoint originalCenter;

@end

@implementation ContainerViewController

-(id) initWithContentController: (UIViewController*) contentController withMenu: (UIViewController*) menuController {
    self = [self init];
    if(self){
        self.menuViewController = menuController;
        self.contentViewController = contentController;
        self.menuView = self.menuViewController.view;
        self.contentView = self.contentViewController.view;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.menuView addSubview:self.menuViewController.view];
    [self addChildViewController:self.menuViewController];
    [self.menuViewController didMoveToParentViewController:self];
    
    [self.contentView addSubview:self.contentViewController.view];
    [self addChildViewController:self.contentViewController];
    [self.contentViewController didMoveToParentViewController:self];

    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.contentView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0){
            [self openMenu];
        }else if(velocity.x<=0){
            [self closeMenu:nil];
        }
    }
    
}


- (void)openMenu{
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.x = [UIScreen mainScreen].bounds.size.width - 50;
                         self.contentView.frame = frame;
                     } completion:^(BOOL finished){
                         if(finished){
                             NSLog(@"Animation finished.");
                         }
                     }];
}



-(void) closeMenu:(NSString*) page{
    if(page ==nil){
        
    }else if([page isEqualToString:@"profile"]){
        ProfileViewController *pvc = [[ProfileViewController alloc] init];
        pvc.delegate = self;
        UINavigationController *nav = (UINavigationController*)self.contentViewController;
        [nav setViewControllers:[NSArray arrayWithObject:pvc] animated:NO];
        self.contentViewController = nav;
    }else if([page isEqualToString:@"main"]){
        MainViewController *mainViewController = [[MainViewController alloc] initWithNewCanvasController];
        mainViewController.delegate = self;
        UINavigationController *nav = (UINavigationController*)self.contentViewController;
        [nav setViewControllers:[NSArray arrayWithObject:mainViewController] animated:NO];
        self.contentViewController = nav;
    }else if([page isEqualToString:@"transaction"]){
        TransactionViewController *tvc = [[TransactionViewController alloc] init];
        tvc.delegate = self;
        UINavigationController *nav = (UINavigationController*) self.contentViewController;
        [nav setViewControllers:[NSArray arrayWithObject:tvc] animated:NO];
        self.contentViewController = nav;
    }
    
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.x = 0;
                         self.contentView.frame = frame;
                     } completion:^(BOOL finished) {
                         if(finished){
                             
                         }
                     }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
