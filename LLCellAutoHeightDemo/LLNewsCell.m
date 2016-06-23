//
//  LLNewsCell.m
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import "LLNewsCell.h"
#import "LLNewsModel.h"
#import "Masonry.h"

//建议放在pch文件中
#import "UITableViewCell+LLMasonryAutoCellHeight.h"

@interface LLNewsCell()

@property (nonatomic,strong)UILabel *mainLabel;
@property (nonatomic,strong)UILabel *descriptionLabel;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,assign)BOOL isExpandedNow;
@end

@implementation LLNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.mainLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.mainLabel];
        self.mainLabel.numberOfLines = 0;
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-15);
            make.height.mas_lessThanOrEqualTo(80);
        }];
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        //应该始终要加上这一句，不然在6/6puls上就不准确了
        self.mainLabel.preferredMaxLayoutWidth = w-30;
        
        self.descriptionLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.descriptionLabel];
        self.descriptionLabel.numberOfLines = 0;
        [self.descriptionLabel sizeToFit];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.mainLabel.mas_bottom).offset(15);
        }];
         //应该始终要加上这一句，不然在6/6puls上就不准确了
        self.descriptionLabel.preferredMaxLayoutWidth = w-30;
        self.descriptionLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
        [self.descriptionLabel addGestureRecognizer:tap];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:self.button];
        [self.button setTitle:@"做中国的公务员好不好" forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor yellowColor]];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(45);
            make.top.mas_equalTo(self.descriptionLabel.mas_bottom).offset(40);
        }];
        //必须加上这句
        self.ll_lastViewsInCell = @[self.button];
        
        self.ll_bottomOffsetToCell = 20;
        self.isExpandedNow = YES;
    }
    return self;
}

- (void)configCellWithModel:(LLNewsModel *)model{
    NSLog(@"正在配置数据");
    self.mainLabel.text = model.title;
    self.descriptionLabel.text = model.desc;
    if (model.isExpand != self.isExpandedNow) {
        self.isExpandedNow = model.isExpand;
        if (self.isExpandedNow) {
            [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.top.mas_equalTo(self.mainLabel.mas_bottom).offset(15);
            }];
        } else {
            [self.descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make){
                make.height.mas_lessThanOrEqualTo(60);
            }];
        }
    }
}

- (void)onTap{
    if (self.expandBlock) {
        self.expandBlock(!self.isExpandedNow);
    }
}

@end
