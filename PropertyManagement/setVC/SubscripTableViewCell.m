//
//  SubscripTableViewCell.m
//  PropertyManagement
//
//  Created by admin on 14/11/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "SubscripTableViewCell.h"


@implementation SubscripTableViewCell
@synthesize imview,nameLabel,setBTN;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //cell的分割线长度。
    self.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    if (self) {
        // Initialization code
        imview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
        [self.contentView addSubview:imview];

        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(50,10,200,20)];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
//        infoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(80,25,200,10)];
//        infoLabel.font = [UIFont fontWithName:@"Arial" size:10];
//        [infoLabel setBackgroundColor:[UIColor clearColor]];
//        [self.contentView addSubview:infoLabel];
        
        setBTN = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [setBTN setFrame:CGRectMake(self.contentView.frame.size.width - 60, 8, 30, 25)];
        [setBTN setTintColor:[UIColor whiteColor]];
        setBTN.titleLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
        [self.contentView addSubview:setBTN];
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
