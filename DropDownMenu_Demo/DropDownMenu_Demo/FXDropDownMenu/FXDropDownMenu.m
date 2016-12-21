//
//  FXDropDownMenu.m
//  DropDownMenu_Demo
//
//  Created by Fxxx on 2016/11/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "FXDropDownMenu.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface FXDropDownMenu()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>{
    NSInteger _selectedColumn;
    CGFloat _originHeight;
    
}

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * selectedRows;

@end


@implementation FXDropDownMenu


- (void)drawRect:(CGRect)rect {
    // Drawing code
}
#pragma mark- 数据懒加载
- (CGFloat) rowHeight{
    if (!_rowHeight) {
        _rowHeight = 40;
    }
    return _rowHeight;
}
- (CGFloat) columnWidth{
    if (!_columnWidth) {
        NSInteger columnCounter = [self.dataSource theColumnTitlesArrayWithMenu:self].count;
        CGFloat menuWidth = self.bounds.size.width;
        _columnWidth = menuWidth / columnCounter;
    }
    return _columnWidth;
}
- (UIFont *) columnTextFont{
    if (!_columnTextFont) {
        _columnTextFont = [UIFont systemFontOfSize:14];
    }
    return _columnTextFont;
}
- (UIFont *) rowTextFont{
    if (!_rowTextFont) {
        _rowTextFont = [UIFont systemFontOfSize:14];
    }
    return _rowTextFont;
}
- (UIColor *) selectedColor{
    if (!_selectedColor) {
        _selectedColor = [UIColor blueColor];
    }
    return _selectedColor;
}
- (NSMutableArray *)selectedRows{
    if (_selectedRows.count == 0) {
        _selectedRows = [NSMutableArray array];
        for (NSInteger i = 0; i < [self.dataSource theColumnTitlesArrayWithMenu:self].count; i++) {
            [_selectedRows addObject:[NSNumber numberWithInteger:-1]];
        }
    }
    return _selectedRows;
}
#pragma mark- 初始化方法
-(instancetype)init{
    return [self initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    //self.layer.masksToBounds = YES;
    _originHeight = frame.size.height;
    _selectedColumn = 0;
    //创建collecView
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [self addSubview:self.collectionView];
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:[self tabelViewOriginFrame]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    //self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tableView];
    
    //添加点击空白回收手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    return self;
}

#pragma merk- frame
- (CGRect) dropDowmFrame{
    return CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kScreenHeight);
}
- (CGRect) tabelViewFrame{
    return CGRectMake(0, [self originFrame].size.height, self.bounds.size.width, kScreenHeight - 49 - [self originFrame].origin.y - _originHeight);
}
- (CGRect) originFrame{
    return CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _originHeight);
}
- (CGRect) tabelViewOriginFrame{
    return CGRectMake(0, [self originFrame].size.height, self.bounds.size.width, 0);
}
#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    return [self.dataSource theColumnTitlesArrayWithMenu:self].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width -10, cell.contentView.bounds.size.height)];
    label.font = self.columnTextFont;
    label.textAlignment = NSTextAlignmentCenter;
    NSArray * titles = [self.dataSource theColumnTitlesArrayWithMenu:self];
    label.text = titles[indexPath.item];
    label.textColor = [UIColor blackColor];
    label.tag = 100;
    [cell.contentView addSubview:label];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_unselected"]];
    imgView.frame = CGRectMake(cell.contentView.bounds.size.width - 10, cell.contentView.bounds.size.height / 2 - 2, 7, 4);
    imgView.tag = 101;
    [cell.contentView addSubview:imgView];
    
    if (indexPath.item == _selectedColumn) {
        label.textColor = self.selectedColor;
        imgView.image = [UIImage imageNamed:@"pic_selected"];
    }
    return cell;
}
#pragma mark- collectionView delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    CGFloat menuHeight = self.bounds.size.height;
    return CGSizeMake(self.columnWidth, menuHeight);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectedColumn == indexPath.item) {
        if (self.frame.size.height > _originHeight) {
            
            UIImageView * imgView = [[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:101];
            [UIView animateWithDuration:.35 animations:^{
                self.tableView.frame = [self tabelViewOriginFrame];
                imgView.image = [UIImage imageNamed:@"pic_selected"];
            }];
            self.frame = [self originFrame];
            return;
        }
    }
    _selectedColumn = indexPath.item;
    NSInteger count = [self.dataSource theColumnTitlesArrayWithMenu:self].count;
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        UILabel * label = [cell viewWithTag:100];
        UIImageView * imgViwe = [cell viewWithTag:101];
        if (indexPath.row == i) {
            label.textColor = self.selectedColor;
            imgViwe.image = [UIImage imageNamed:@"pic_up"];
        }else{
            label.textColor = [UIColor blackColor];
            imgViwe.image = [UIImage imageNamed:@"pic_unselected"];
        }
    }
    
    self.frame = [self dropDowmFrame];
    [UIView animateWithDuration:.35 animations:^{
        self.tableView.frame = [self tabelViewFrame];
        [self.tableView reloadData];
    }];
    
}

#pragma mark- tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return [self.dataSource theRowTitlesArrayWithColumn:_selectedColumn].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tintColor = self.selectedColor;
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSArray * titles = [self.dataSource theRowTitlesArrayWithColumn:_selectedColumn];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = self.rowTextFont;
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == [self.selectedRows[_selectedColumn] integerValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = self.selectedColor;
    }
    return cell;
}
#pragma mark- tableView delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_selectedRows setObject:[NSNumber numberWithInteger:indexPath.row] atIndexedSubscript:_selectedColumn];
    //[tableView reloadData];
    NSInteger count = [self.dataSource theRowTitlesArrayWithColumn:_selectedColumn].count;
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell * tablecell = [tableView cellForRowAtIndexPath:index];
        if ([index isEqual:indexPath]) {
            tablecell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            tablecell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedColumn inSection:0]];
    UIImageView * imgView = [cell viewWithTag:101];
    [self.delegate menu:self didSelectColumn:_selectedColumn andRow:[self.selectedRows[_selectedColumn] integerValue]];
    UILabel * label = [cell viewWithTag:100];
    NSArray * arr = [self.dataSource theRowTitlesArrayWithColumn:_selectedColumn];
    label.text = arr[indexPath.row];
    
    [UIView animateWithDuration:.35 animations:^{
        self.tableView.frame = [self tabelViewOriginFrame];
        imgView.image = [UIImage imageNamed:@"pic_selected"];
    }];
    self.frame = [self originFrame];
}

#pragma mark- reload
- (void) reload{
    _selectedColumn = 0;
    _selectedRows = [NSMutableArray array];
    //[self.collectionView reloadData];
    //[self.tableView reloadData];
}

#pragma mark- 回收手势
- (void) tapAction:(UITapGestureRecognizer *)tap{
    
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedColumn inSection:0]];
    UIImageView * imgView = [cell viewWithTag:101];
    [UIView animateWithDuration:.35 animations:^{
        self.tableView.frame = [self tabelViewOriginFrame];
        imgView.image = [UIImage imageNamed:@"pic_selected"];
    }];
    self.frame = [self originFrame];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;{
    //NSLog(@"%@", touch.view);
    if ([touch.view isEqual:self.tableView]) {
        return YES;
    }
    return NO;
}

@end
