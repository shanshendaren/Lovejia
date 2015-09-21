//
//  NoticeTableViewCell.m
//  PropertyManagement
//
//  Created by admin on 15/1/16.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell
@synthesize nameLabel,infoLabel,timeLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(15,5,self.bounds.size.width-15,20)];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        timeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(210,25,100,20)];
        timeLabel.font = [UIFont fontWithName:@"Arial" size:10];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        timeLabel.textColor =[UIColor grayColor];
        [self.contentView addSubview:timeLabel];
        
        infoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(15,25,185,20)];
        infoLabel.font = [UIFont fontWithName:@"Arial" size:13];
        infoLabel.textColor =[UIColor grayColor];
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
