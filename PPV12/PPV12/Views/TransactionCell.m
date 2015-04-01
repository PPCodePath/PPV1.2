//
//  TransactionCell.m
//  PPV12
//
//  Created by Chris Mamuad on 3/10/15.
//  Copyright (c) 2015 Mamuad, Christian. All rights reserved.
//

#import "TransactionCell.h"
#import "UIImageView+AFNetworking.h"
#import <Venmo-iOS-SDK/Venmo.h>

@implementation TransactionCell

- (void)awakeFromNib {
    VENUser *user = [[Venmo sharedInstance] session].user;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    self.message.preferredMaxLayoutWidth = self.message.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.message.preferredMaxLayoutWidth = self.message.frame.size.width;
}

@end
