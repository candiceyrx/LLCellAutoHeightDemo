//
//  ViewController.m
//  LLCellAutoHeightDemo
//
//  Created by Candice on 16/6/23.
//  Copyright © 2016年 Candice. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "Masonry/View+MASAdditions.h"
#import "UITableViewCell+LLMasonryAutoCellHeight.h"
#import "LLNewsModel.h"
#import "LLNewsCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
        
        int titleTotalLength = (int)[[self titleAll] length];
        int descTotalLength = (int)[[self descriptionAll] length];
        for (NSUInteger i = 0; i < 40; i++) {
            int titleLength = rand() % titleTotalLength + 15;
            if (titleLength > titleTotalLength - 1) {
                titleLength = titleTotalLength;
            }
            LLNewsModel *model = [[LLNewsModel alloc]init];
            model.title = [[self titleAll] substringToIndex:titleLength];
            model.uid = (int)i + 1;
            model.isExpand = YES;
            
            int descLength = rand() % descTotalLength + 20;
            if (descLength >= descTotalLength) {
                descLength = descTotalLength;
            }
            model.desc = [[self descriptionAll] substringToIndex:descLength];
            
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (NSString *)titleAll{
    return @"在资源相对稀缺的背景下，如果公务员数量过多，不仅占用大量资源、影响经济建设，而且大大地提高了纳税人的供养成本。";
}

- (NSString *)descriptionAll{
    return @"任何关于公务员的风吹草动，都能引发公众的强烈关注。近日，人社部发布了《2015年度人力资源和社会保障事业发展统计公报》，其中关于公务员部分成为关注的焦点，据悉，这是国家权威部门首次披露“中国的公务员到底有多少”。根据数据，截至2015年年底，全国共有公务员716.7万人。";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    LLNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LLNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LLNewsModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = [self.dataSource objectAtIndex:indexPath.row];
    }
    [cell configCellWithModel:model];
    
    cell.expandBlock = ^(BOOL isExpand){
        model.isExpand = isExpand;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLNewsModel *model = nil;
    if (indexPath.row < self.dataSource.count) {
        model = [self.dataSource objectAtIndex:indexPath.row];
    }
    NSString *stateKey = nil;
    if (model.isExpand) {
        stateKey = @"expanded";
    } else {
        stateKey = @"unexpanded";
    }
    
    return [LLNewsCell ll_heightForTableView:tableView config:^(UITableViewCell *sourceCell){
        LLNewsCell *cell = (LLNewsCell *)sourceCell;
        //配置数据
        [cell configCellWithModel:model];
    
    } cache:^NSDictionary *{
        return @{kLLCacheUniqueKey:[NSString stringWithFormat:@"%d",model.uid],
                 kLLCacheStateKey:stateKey,
                 // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
                 kLLRecalculateForStateKey:@(NO)//标识不用重新更新
                 };
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
