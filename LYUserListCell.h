//
//  LYUserListCell.h
//  liangyiju
//
//  Created by JTom on 2017/5/17.
//  Copyright © 2017年 云翌康. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYFollowersEntity;
@interface LYUserListCell : UITableViewCell
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *flagView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *hospitalNameLab;
@property (nonatomic, strong) UIImageView *flagImgView;

@property (nonatomic, strong) LYFollowersEntity *entity;

+(void)registerCellWithTableView:(UITableView *)tableView;
+(instancetype)cellWithTableView:(UITableView *)tableView;
+(NSString *)CellID;

@end
