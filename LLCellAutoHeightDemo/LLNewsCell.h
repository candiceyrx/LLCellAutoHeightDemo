//
//  LLNewsCell.h
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLNewsModel;

typedef void (^LLExpandBlock)(BOOL isExpand);

@interface LLNewsCell : UITableViewCell

@property (nonatomic,copy)LLExpandBlock expandBlock;

- (void)configCellWithModel:(LLNewsModel *)model;

@end
