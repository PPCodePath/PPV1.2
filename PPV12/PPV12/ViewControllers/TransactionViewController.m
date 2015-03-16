//
//  TransactionViewController.m
//  PPV12
//
//  Created by Chris Mamuad on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "TransactionViewController.h"
#import "TransactionCell.h"
#import "Venmo+Enhanced.h"
#import "Transaction.h"
#import "User.h"

@interface TransactionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *transactionView;
@property (strong, nonatomic) NSArray* transactions;
@end

@implementation TransactionViewController

- (void)viewDidLoad {
    NSLog(@"TransactionViewController");
    [super viewDidLoad];
    self.transactionView.delegate = self;
    self.transactionView.dataSource = self;
    [self.transactionView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    self.title=@"Transactions";
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) loadData{
    [[Venmo sharedInstance] getTransactionsWithLimit:[NSNumber numberWithInt:30] before:nil after:nil completionHandler:^(id object, BOOL success, NSError *error) {
                            if (success) {
                                NSArray* data = object[@"data"];
                                NSMutableArray* transactionList = [Transaction initWithArrayOfDictionary:data];
                                self.transactions = [NSArray arrayWithArray:transactionList];
                                
                                [self.transactionView reloadData];
                                NSLog(@"Transaction succeeded!");
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View changes



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionCell *cell = [self.transactionView dequeueReusableCellWithIdentifier:@"TransactionCell"];
    Transaction* transaction = self.transactions[indexPath.row];
    if(transaction != nil){
    cell.amount.text = [NSString stringWithFormat:@"%@", transaction.amount];
    cell.amount.textColor = [UIColor greenColor];
    cell.message.text = transaction.message ;
    
    
    User* receiver = [transaction.receiver objectAtIndex:0];
    User* sender = [transaction.sender objectAtIndex:0];
    NSMutableString* transactionDisplay = [[NSMutableString alloc] init];
    [transactionDisplay appendString:[sender firstName]];
    [transactionDisplay appendString:@" paid "];
    [transactionDisplay appendString:[receiver firstName]];
    cell.transactionDisplay.text = transactionDisplay;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
