//
//  LYUserListCell.m
//  liangyiju
//
//  Created by JTom on 2017/5/17.
//  Copyright © 2017年 云翌康. All rights reserved.
//

#import "LYUserListCell.h"
#import "LYFollowersResultModel.h"

static NSString *CellID =@"LYNewCommeLYUserListCellntCell";


@implementation LYUserListCell

-(UIImageView *)headImgView{
	if (!_headImgView) {
		_headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
		_headImgView.contentMode = UIViewContentModeScaleAspectFill;
//		_headImgView.userInteractionEnabled = YES;
		_headImgView.image = [UIImage imageNamed:kPlaceholderHeadImgName];
//		UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewAction)];
//		[_headImgView addGestureRecognizer:tag];
		
	}
	return _headImgView;
}

-(UILabel *)nameLab{
	if (!_nameLab) {
		_nameLab = [[UILabel alloc]init];
		_nameLab.font = LYFont(18);
		_nameLab.text = @"杨教授-雷电领主";
		_nameLab.textAlignment = NSTextAlignmentLeft;
	}
	return _nameLab;
}

-(UILabel *)hospitalNameLab{
	if (!_hospitalNameLab) {
		_hospitalNameLab = [[UILabel alloc]init];
		_hospitalNameLab.font = LYFont(15);
		_hospitalNameLab.numberOfLines = 0;
		_hospitalNameLab.textColor = [UIColor grayColor];
		_hospitalNameLab.text = @"广州王者荣耀戒毒中心-天河分部";
		_hospitalNameLab.textAlignment = NSTextAlignmentLeft;
	}
	return _hospitalNameLab;
}
-(UIImageView *)flagImgView{
	if (!_flagImgView) {
		_flagImgView = [[UIImageView alloc]init];
		_flagImgView.image = [UIImage imageNamed:@"my_more"];
	}
	return _flagImgView;
}

-(UIView *)headView{
	if (!_headView) {
		_headView = [[UIView alloc]init];
	}
	return _headView;
}
-(UIView *)flagView{
	if (!_flagView) {
		_flagView = [[UIView alloc]init];
	}
	return _flagView;
}
-(void)headerViewAction{
	
}

-(void)createView{
	//居中的view需要先放到一个父view里面。才可以正常autolayout
	//NSLog(@"[FDTemplateLayoutCell] Warning once only: Cannot get a proper cell height (now 0) from '- systemFittingSize:'(AutoLayout). You should check how constraints are built in cell, making it into 'self-sizing' cell.");
	
	[self.headView addSubview:self.headImgView];
	[self.flagView addSubview:self.flagImgView];
	
	[self.contentView addSubview:self.headView];
	[self.contentView addSubview:self.flagView];
	[self.contentView addSubview:self.nameLab];

	[self.contentView addSubview:self.hospitalNameLab];
}

-(void)setViewAutoLayout{
	UIView *sv = self.contentView;
	static CGFloat margin =8;
	[self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(40+margin+margin);
		make.top.left.and.bottom.equalTo(sv);
		make.right.mas_equalTo(self.nameLab.mas_left).offset(-margin);
	}];
	
	[self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(20+margin+margin);
		make.top.right.and.bottom.equalTo(sv);
		make.left.mas_equalTo(self.nameLab.mas_right).offset(-margin);
	}];
	
	[self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(40, 40));
		make.centerY.mas_equalTo(self.headView.mas_centerY);
		make.centerX.mas_equalTo(self.headView.mas_centerX);
	}];
	
	[self.flagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(8, 20));
		make.centerY.mas_equalTo(self.flagView.mas_centerY);
		make.centerX.mas_equalTo(self.flagView.mas_centerX);
	}];
	
	
	[self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(sv).offset(margin);
		make.bottom.mas_equalTo(self.hospitalNameLab.mas_top).offset(-margin);
	}];

	[self.hospitalNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.right.equalTo(self.nameLab);
		make.bottom.equalTo(sv).offset(-margin);
	}];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		[self createView];
		[self setViewAutoLayout];
	}
	return self;
}


+(void)registerCellWithTableView:(UITableView *)tableView{
	[tableView registerClass:[LYUserListCell class] forCellReuseIdentifier:CellID];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
	LYUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
	if (cell == nil) {
		cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
	}
	cell.separatorInset =UIEdgeInsetsMake(0, 0, 0, 0);
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

+(NSString *)CellID{
	return CellID;
}


-(void)setEntity:(LYFollowersEntity *)entity{
	_entity = entity;
	[self.headImgView downloadImage:entity.focusfrom.headimg placeholder:kPlaceholderHeadImgName];
	self.headImgView = [LYUIViewUtils createFilletWithImgView:self.headImgView];
	
	self.nameLab.text = [NSString stringWithFormat:@"%@-%@",entity.focusfrom.docname,entity.focusfrom.level.levelname];
	self.hospitalNameLab.text = entity.hospitalName;
}

@end
