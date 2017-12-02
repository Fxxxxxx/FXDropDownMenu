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
    _columns = @[@"你好", @"你好", @"你好", @"你好", @"你好"];
    _rows = @[@"好的", @"好的", @"好的", @"好的", @"好的"];
    FXDropDownMenu * menu = [[FXDropDownMenu alloc] init];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    [menu reload];
    
    
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
