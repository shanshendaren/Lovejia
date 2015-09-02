//
//  PersonTableViewCell.m
//  PropertyManagement
//
//  Created by admin on 14/12/16.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell
@synthesize nameLabel,infoLabel,im;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0,10,60,20)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        nameLabel.font = [UIFont fontWithName:nil size:14];
        nameLabel.textAlignment = 1;
        [self.contentView addSubview:nameLabel];
        
        infoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(70,10,200,20)];
        infoLabel.font = [UIFont fontWithName:nil size:12];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:infoLabel];
        
        im = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-15, 15, 10, 10)];
        [im setImage:[UIImage imageNamed:@"go-list"]];
        [self.contentView  addSubview:im];

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
