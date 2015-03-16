//
//  ProfileViewController.m
//  PPV12
//
//  Created by Chris Mamuad on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "ProfileViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import "UIImageView+AFNetworking.h"
#import "Venmo+Enhanced.h"
#import "Transaction.h"
#import "TransactionCell.h"
#import "FXBlurView.h"
#import "User.h"
#import "SVPullToRefresh.h"
#import <CMDQueryStringSerialization/CMDQueryStringSerialization.h>


@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *userTransactionTableView;
@property (strong, nonatomic) NSMutableArray *transactions;
@property (strong, nonatomic) NSString *beforeDate;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userTransactionTableView.dataSource = self;
    self.userTransactionTableView.delegate = self;
    
    self.title = @"Profile";
    
    [self.userTransactionTableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    self.userTransactionTableView.rowHeight =UITableViewAutomaticDimension;
    self.userTransactionTableView.estimatedRowHeight = 105;
    
    UIImage *bgImg = [UIImage imageNamed:@"simScreen"];
    [self.backGroundImageView setImage:[bgImg blurredImageWithRadius:10 iterations:20 tintColor:[UIColor clearColor]]];
    
    self.userTransactionTableView.backgroundColor = [UIColor clearColor];
    
    VENUser *user = [[Venmo sharedInstance] session].user;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@, %@", user.firstName, user.lastName];
    
    [self loadData:nil];
    
    [self.userTransactionTableView addPullToRefreshWithActionHandler:^{
        [self loadData:nil];
    }];
    
    [self.userTransactionTableView addInfiniteScrollingWithActionHandler:^{
        // TODO: replace hard code date with the right info
        [self loadData:@"2014-12-19T20:54:46"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData:(NSString *)beforeDate {
    NSLog(@"loadData triggered");
    [[Venmo sharedInstance] getTransactionsWithLimit:[NSNumber numberWithInt:30] before:beforeDate after:nil completionHandler:^(id object, BOOL success, NSError *error) {
        if (success) {
            [self.userTransactionTableView.pullToRefreshView stopAnimating];
            [self.userTransactionTableView.infiniteScrollingView stopAnimating];
            NSArray *data = object[@"data"];
            NSString *nextString = object[@"pagination"][@"next"];
            
            NSMutableArray *transactionList = [Transaction initWithArrayOfDictionary:data];
            self.transactions = [NSMutableArray arrayWithArray:transactionList];
            [self.userTransactionTableView reloadData];
        } else {
            NSLog(@"fetch transaction list failed with error %@", error);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [self.userTransactionTableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
    cell.backgroundColor = [UIColor clearColor];
    Transaction *txn = self.transactions[indexPath.row];
    cell.amount.text = [NSString stringWithFormat:@"%@",txn.amount];
    cell.message.text = [NSString stringWithFormat:@"%@", txn.message];
    if ([txn.transactionType isEqualToString:@"pay"]) {
        cell.transactionDisplay.attributedText = [self transactionDetailAtIndexPath:indexPath forAction:@"paid"];
        cell.amount.textColor = [UIColor greenColor];
    } else if ([txn.transactionType isEqualToString:@"charge"]) {
        cell.transactionDisplay.attributedText = [self transactionDetailAtIndexPath:indexPath forAction:@"charged"];
        cell.amount.textColor = [UIColor redColor];
    }
    return cell;
}

- (NSMutableAttributedString *)transactionDetailAtIndexPath:(NSIndexPath *)indexPath forAction:(NSString *)action {
    Transaction *txn = self.transactions[indexPath.row];
    User *sender = [txn.sender objectAtIndex:0];
    User *receiver = [txn.receiver objectAtIndex:0];
    NSString *string = [NSString stringWithFormat:@"%@ %@ %@", sender.firstName, action, receiver.firstName];
    NSRange senderRange = [string rangeOfString:sender.firstName];
    NSRange receiverRange = [string rangeOfString:receiver.firstName];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]} range:senderRange];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]} range:receiverRange];
    return attributedText;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transactions.count;
}

@end
