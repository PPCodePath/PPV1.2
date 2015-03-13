//
//  TransactionCell.h
//  PPV12
//
//  Created by Chris Mamuad on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *transactionDisplay;

@end
