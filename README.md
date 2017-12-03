## FXDropDownMenu
点击出现的下拉菜单,简单设置数据源就可以实现效果

## 导入方式:
  将Demo中的FXDropDownMenu文件夹拖入你的工程,在需要使用下拉菜单的地方引用FXDropDownMenu.h即可.
  
## 使用:
  FXDropDownMenu类继承自UIView,直接在你需要使用的地方确定frame新建就好,数据源方法确定加载数据,常见的显示属性已经列出，可以直接赋值，然后调用  `showWithView`方法就可以显示在你设置好的视图上。
  
```
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
```
数据源的协议见下面的代码，可以看出有点TableViewDataSource的味道，这里我们分别传如两个字符串范型的数组就可以了，因为只做显示，所以吧需要显示出来的文案做成数组就好。

```
@protocol FXDropDownMenuDataSource <NSObject>

@required

//第一级菜单选项的标题数组,内容为NSString类型
-(NSArray<NSString *> *)theColumnTitlesArrayWithMenu:(FXDropDownMenu *)menu;

//第二级菜单选项的标题数组(下滑菜单),内容为NSString类型

-(NSArray<NSString *> *)theRowTitlesArrayWithColumn:(NSInteger)column;

@end

```
代理方法如下，会返回给你点击的行列序号，根据此来刷新自己的界面或者做其他操作就好。

```
@protocol FXDropDownMenuDelegate <NSObject>

@optional
//选中二级菜单之后的操作
- (void)menu:(FXDropDownMenu *)menu didSelectColumn:(NSInteger) column andRow:(NSInteger) row;

@end
```
## 效果展示:
![12月-03-2017 19-18-08.gif](http://upload-images.jianshu.io/upload_images/3569202-7a9113c911097f20.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


####**这个是我在实际APP中的使用,更多的样式都可以在代码中改,欢迎使用.**