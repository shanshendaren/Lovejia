//
//  ComplainTableViewCell.m
//  PropertyManagement
//
//  Created by admin on 14/11/21.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "ComplainTableViewCell.h"

@implementation ComplainTableViewCell
@synthesize nameLabel,infoLabel;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10,10,200,20)];
        nameLabel.font = [UIFont fontWithName:nil size:16];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        infoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10,30,200,20)];
        infoLabel.font = [UIFont fontWithName:nil size:14];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:infoLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
