//
//  SubscripTableViewCell.m
//  PropertyManagement
//
//  Created by admin on 14/11/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "SubscripTableViewCell.h"

@implementation SubscripTableViewCell
@synthesize imview,nameLabel,infoLabel,setBTN;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 60, 50)];
        [self.contentView addSubview:imview];
        
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(80,10,200,20)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        infoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(80,35,200,20)];
        infoLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:infoLabel];
        
        setBTN = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [setBTN setFrame:CGRectMake(self.contentView.frame.size.width - 60, 15, 40, 30)];
        [setBTN setTintColor:[UIColor whiteColor]];
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
