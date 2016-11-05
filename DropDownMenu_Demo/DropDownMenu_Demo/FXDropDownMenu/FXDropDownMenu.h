//
//  FXDropDownMenu.h
//  DropDownMenu_Demo
//
//  Created by Fxxx on 2016/11/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXDropDownMenu;

#pragma mark- DataSource
@protocol FXDropDownMenuDataSource <NSObject>

@required

//第一级菜单选项的标题数组,内容为NSString类型
-(NSArray<NSString *> *)theColumnTitlesArrayWithMenu:(FXDropDownMenu *)menu;

//第二级菜单选项的标题数组(下滑菜单),内容为NSString类型

-(NSArray<NSString *> *)theRowTitlesArrayWithColumn:(NSInteger)column;

@end

#pragma mark- Delegate
@protocol FXDropDownMenuDelegate <NSObject>

@required

//选中二级菜单之后的操作
- (void)menu:(FXDropDownMenu *)menu didSelectColumn:(NSInteger) column andRow:(NSInteger) row;

@end




@interface FXDropDownMenu : UIView

@property (weak, nonatomic) id<FXDropDownMenuDataSource> dataSource;
@property (weak, nonatomic) id<FXDropDownMenuDelegate> delegate;
//第二级菜单(行)的高度
@property (assign, nonatomic) CGFloat rowHeight;
//第一级菜单(列)的宽度
@property (assign, nonatomic) CGFloat columnWidth;
//第二级菜单(行)的字体
@property (strong, nonatomic) UIFont * rowTextFont;
//第一级菜单(列)的字体
@property (strong, nonatomic) UIFont * columnTextFont;
//选中状态的颜色
@property (strong, nonatomic) UIColor * selectedColor;

@end
