//
//  SubTableViewCell.m
//  PropertyManagement
//
//  Created by mac on 15/10/12.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SubTableViewCell.h"

@implementation SubTableViewCell
@synthesize nameLabel,infoLabel,setBTN;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20,5,200,20)];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameLabel];
        
        infoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20,25,200,10)];
        infoLabel.font = [UIFont fontWithName:@"Arial" size:10];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:infoLabel];
        
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
