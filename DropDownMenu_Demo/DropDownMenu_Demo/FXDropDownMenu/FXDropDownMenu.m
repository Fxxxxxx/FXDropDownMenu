//
//  FXDropDownMenu.m
//  DropDownMenu_Demo
//
//  Created by Fxxx on 2016/11/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface ColumnCell : UICollectionViewCell

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UIImageView * imageView;

@end

@implementation ColumnCell
@end

#import "FXDropDownMenu.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface FXDropDownMenu()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>{
    
    NSInteger _selectedColumn;
    CGFloat _originHeight;
    Boolean _isDropDown;
    
}

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * selectedRows;
@property (strong, nonatomic) NSBundle * imageBundle;

@end


@implementation FXDropDownMenu


- (void)drawRect:(CGRect)rect {
    // Drawing code
}
#pragma mark- 数据懒加载

- (NSBundle *)imageBundle {
    
    if (!_imageBundle) {
        
        NSString * path = [[NSBundle bundleForClass:[FXDropDownMenu class]] pathForResource:@"FXDropDownMenu" ofType:@"bundle"];
        _imageBundle = [NSBundle bundleWithPath:path];
        
    }
    return _imageBundle;
    
}

- (CGFloat) rowHeight{
    if (!_rowHeight) {
        _rowHeight = 40;
    }
    return _rowHeight;
}

- (CGFloat) columnWidth{
    if (!_columnWidth) {
        _columnWidth = kScreenWidth / 5;
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
        _selectedColor = [UIColor colorWithRed:34.0/255 green:208.0/255 blue:177.0/255 alpha:1];
    }
    return _selectedColor;
}

- (UIColor *)unSelectedColor {
    
    if (!_unSelectedColor) {
        _unSelectedColor = [UIColor grayColor];
    }
    return _unSelectedColor;
    
}

- (UIImage *)selectUpImage {
    
    if (!_selectUpImage) {
        _selectUpImage = [UIImage imageNamed:@"pic_up" inBundle:self.imageBundle compatibleWithTraitCollection:nil];
    }
    return _selectUpImage;
    
}

- (UIImage *)selectDownImage {
    
    if (!_selectDownImage) {
        _selectDownImage = [UIImage imageNamed:@"pic_selected" inBundle:self.imageBundle compatibleWithTraitCollection:nil];
    }
    return _selectDownImage;
    
}

- (UIImage *)unSelectImage {
    
    if (!_unSelectImage) {
        _unSelectImage = [UIImage imageNamed:@"pic_unselected" inBundle:self.imageBundle compatibleWithTraitCollection:nil];
    }
    return _unSelectImage;
    
}


- (NSMutableArray *)selectedRows{
    if (_selectedRows.count == 0) {
        
        _selectedRows = [NSMutableArray array];
        
        if (!self.dataSource) {
            return _selectedRows;
        }
        
        for (NSInteger i = 0; i < [self.dataSource theColumnTitlesArrayWithMenu:self].count; i++) {
            [_selectedRows addObject:[NSNumber numberWithInteger:0]];
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
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    //self.layer.masksToBounds = YES;
    _originHeight = frame.size.height;
    _selectedColumn = 0;
    _isDropDown = false;
    
    return self;
}

- (void)showWithView:(UIView *) view{
    
    [view addSubview:self];
    //创建collecView
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.columnWidth, _originHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ColumnCell class] forCellWithReuseIdentifier:@"ColumnCell"];
    [self addSubview:self.collectionView];
    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:[self tabelViewOriginFrame]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    //self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tableView];
    
    //添加点击空白回收手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
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

- (void) changeDropStaue{
    
    if (_isDropDown) {
        
        [self.tableView reloadData];
        self.frame = [self dropDowmFrame];
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = [self tabelViewFrame];
        }];
        
    }else {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = [self originFrame];
        } completion:^(BOOL finished) {
            self.tableView.frame = [self tabelViewOriginFrame];
        }];
        
    }
    
}

#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    if (!self.dataSource) {
        return 0;
    }
    
    return [self.dataSource theColumnTitlesArrayWithMenu:self].count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    ColumnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColumnCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (!cell.titleLabel) {
        
        cell.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width - 15, cell.contentView.bounds.size.height)];
        [cell.contentView addSubview:cell.titleLabel];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.titleLabel.font = self.columnTextFont;
        
    }
    
    if (!cell.imageView) {
        
        cell.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.bounds.size.width- 13, 0, 10, cell.contentView.bounds.size.height)];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:cell.imageView];
        
    }
    
    NSArray * titles = [self.dataSource theColumnTitlesArrayWithMenu:self];
    cell.titleLabel.text = titles[indexPath.item];
    
    if (indexPath.item == _selectedColumn) {
        
        cell.titleLabel.textColor = self.selectedColor;
        cell.imageView.image = _isDropDown ? self.selectDownImage : self.selectUpImage;
        
    }else {
        
        cell.titleLabel.textColor = self.unSelectedColor;
        cell.imageView.image = self.unSelectImage;
        
    }
    
    return cell;
}
#pragma mark- collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_selectedColumn == indexPath.item) {
        _isDropDown = !_isDropDown;
    }else {
        _isDropDown = true;
        _selectedColumn = indexPath.item;
    }
    [self.collectionView reloadData];
    
    [self changeDropStaue];
    
}

#pragma mark- tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    
    if (!self.dataSource) {
        return 0;
    }
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
    cell.textLabel.textColor = self.unSelectedColor;
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
    [tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menu:didSelectColumn:andRow:)]) {
        [self.delegate menu:self didSelectColumn:_selectedColumn andRow:indexPath.row];
    }
    
    _isDropDown = false;
    [self changeDropStaue];
    
}

#pragma mark- reload
- (void) reload{
    _selectedColumn = 0;
    _selectedRows = nil;
    [self.collectionView reloadData];
}

#pragma mark- 回收手势
- (void) tapAction:(UITapGestureRecognizer *)tap{
    
    _isDropDown = false;
    [self changeDropStaue];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;{
    //NSLog(@"%@", touch.view);
    if ([touch.view isEqual:self.tableView]) {
        return YES;
    }
    return NO;
}

@end


