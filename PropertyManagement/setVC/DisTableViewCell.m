//
//  DisTableViewCell.m
//  PropertyManagement
//
//  Created by admin on 15/3/9.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "DisTableViewCell.h"

@implementation DisTableViewCell
@synthesize nameLabel,agreeBTN,timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10,5,120,20)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [self.contentView addSubview:nameLabel];
        
        timeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(130,5,self.contentView.frame.size.width -130,20)];
        timeLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:timeLabel];
        
        agreeBTN =[[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:agreeBTN];
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
