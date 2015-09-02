//
//  House.h
//  PropertyManagement
//
//  Created by admin on 15/2/27.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : NSObject

/*
secondarysaleInfoId:        “ID”
secondarysaleInfoTitle:	  “标题”
secondarysaleContent:	       “内容描述”
houseType：			   “房型”
houseAddress:			   “房屋地址”
housePrice:	“标价（适用卖房信息发布）或价位区间（适用于买
房信息发布）”
saleType:				   “销售类型   0-出售  1求购”
repaeaseDate:       “发帖时间”
repaeaseName:	  “发帖人姓名”
repaeaseTel:	   “发帖人电话”
Photos: 图片数组
  */


@property(strong,nonatomic)NSString *secondarysaleInfoId;
@property(strong,nonatomic)NSString *secondarysaleInfoTitle;
@property(strong,nonatomic)NSString *secondarysaleContent;
@property(strong,nonatomic)NSString *houseType;
@property(strong,nonatomic)NSString *houseAddress;
@property(strong,nonatomic)NSString *housePrice;
@property(strong,nonatomic)NSString *saleType;
@property(strong,nonatomic)NSString *repaeaseDate;
@property(strong,nonatomic)NSString *repaeaseTel;
@property(strong,nonatomic)NSString *repaeaseName;
@property(nonatomic,strong)NSArray *photos;

@end
