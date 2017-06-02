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


# ReactiveCocoa/RAC
参考：

[MVVMReactiveCocoaDemo介绍](https://github.com/wujunyang/MVVMReactiveCocoaDemo)

[ReactiveCocoa中潜在的内存泄漏及解决方案](http://tech.meituan.com/potential-memory-leak-in-reactivecocoa.html)

[“自释放”在iOS开发中的应用](http://www.olinone.com/?p=232)

#### 内存释放

获取信号直到`signalTrigger`信号执行完成
```
- (RACSignal *)takeUntil:(RACSignal *)signalTrigger;
```

即将dealloc的时候会发出此信号
```
- (RACSignal *)rac_willDeallocSignal;
```
takeUntil:self.rac_willDeallocSignal：意思为self即将dealloc时释放此信号订阅
```
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSLog(@"cellClick");
    }];
```
关于RAC什么时候使用@weakify(self)、@strongify(self) : viewcontroller需要，viewModel不需要

 



