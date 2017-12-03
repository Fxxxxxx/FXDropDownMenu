//
//  ViewController.m
//  DropDownMenu_Demo
//
//  Created by Fxxx on 2016/11/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "ViewController.h"
#import "FXDropDownMenu.h"
@interface ViewController ()<FXDropDownMenuDataSource,FXDropDownMenuDelegate>{
    NSArray * _columns;
    NSArray * _rows;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _columns = @[@"时间", @"好评度", @"人气", @"销量", @"库存", @"距离", @"星级"];
    _rows = @[@"选项1", @"选项2", @"选项3", @"选项4", @"选项5", @"选项6", @"选项7", @"选项8"];
    FXDropDownMenu * menu = [[FXDropDownMenu alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 50)];
    menu.selectedColor = [UIColor colorWithRed:34.0/255 green:208.0/255 blue:177.0/255 alpha:1];
    menu.unSelectedColor = [UIColor blackColor];
    menu.columnWidth = 100;
    menu.rowHeight = 44;
    menu.columnTextFont = [UIFont systemFontOfSize:16];
    menu.rowTextFont = [UIFont systemFontOfSize:14];
    menu.delegate = self;
    menu.dataSource = self;
    [menu showWithView:self.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- datasource
-(NSArray *)theColumnTitlesArrayWithMenu:(FXDropDownMenu *)menu;{
    return _columns;
}


-(NSArray *)theRowTitlesArrayWithColumn:(NSInteger)column;{
    return _rows;
}

#pragma mark- delegate
-(void)menu:(FXDropDownMenu *)menu didSelectColumn:(NSInteger)column andRow:(NSInteger)row{
    NSLog(@"%li------%li", column, row);
}

@end
