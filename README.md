# daily
日常记录

# UIViewController 
### 管理状态栏

修改过需要执行此方法，刷新状态栏
```
- (void)setNeedsStatusBarAppearanceUpdate NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
```
是否显示状态栏
```
@property(nonatomic, readonly) UIStatusBarStyle preferredStatusBarStyle NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED; // Defaults to UIStatusBarStyleDefault
```
状态栏样式
```
@property(nonatomic, readonly) UIStatusBarStyle preferredStatusBarStyle NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED; // Defaults to UIStatusBarStyleDefault
```
### 配置Navigation界面

隐藏tabbar图标
```
@property(nonatomic) BOOL hidesBottomBarWhenPushed __TVOS_PROHIBITED; // If YES, then when this view controller is pushed into a controller hierarchy with a bottom bar (like a tab bar), the bottom bar will slide out. Default is NO.
```
重写UINavigation方法
```
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
```
```
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
	if (self.viewControllers.count) {
		viewController.hidesBottomBarWhenPushed = YES;
	}
	[super pushViewController:viewController animated:animated];
}
```



