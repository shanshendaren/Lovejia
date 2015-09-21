//
//  AdressTableViewCell.m
//  PropertyManagement
//
//  Created by admin on 14/12/16.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "AdressTableViewCell.h"

@implementation AdressTableViewCell
@synthesize nameLabel,infoLabel,im;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0,15,60,20)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [self.contentView addSubview:nameLabel];
        
        infoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(70,10,200,40)];
        infoLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:infoLabel];
        
        im = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-15, 12, 20, 20)];
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
