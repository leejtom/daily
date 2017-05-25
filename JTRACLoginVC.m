//
//  JTRACLoginVC.m
//  liangyiju-v2
//
//  Created by JTom on 2017/5/25.
//  Copyright © 2017年 云翌康. All rights reserved.
//

#import "JTRACLoginVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface JTRACLoginVC ()

@property(nonatomic, strong) UITextField *phoneTF;
@property(nonatomic, strong) UITextField *passwordTF;

@property(nonatomic, strong) UIButton *getCodeBtn;
@property(nonatomic, strong) UIButton *submitBtn;

@end

@implementation JTRACLoginVC

-(UITextField *)passwordTF{
	if (!_passwordTF) {
		_passwordTF=[[UITextField alloc]init];
		_passwordTF.backgroundColor=[UIColor grayColor];
		_passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
		_passwordTF.placeholder=@"输入6位密码";
	}
	return _passwordTF;
}
-(UITextField *)phoneTF
{
	if (!_phoneTF) {
		_phoneTF=[[UITextField alloc]init];
		_phoneTF.backgroundColor=[UIColor grayColor];
		_phoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
		_phoneTF.placeholder=@"输入11位手机号";
	}
	return _phoneTF;
}

-(UIButton *)submitBtn{
	if (!_submitBtn) {
		_submitBtn=[UIButton new];
		[_submitBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
	}
	return _submitBtn;
}
-(UIButton *)getCodeBtn
{
	if (!_getCodeBtn) {
		_getCodeBtn=[UIButton new];
		[_getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[_getCodeBtn setTitle:@"获得验证码" forState:UIControlStateNormal];
	}
	return _getCodeBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self addSubviews];
	[self addRAC];
}


- (void)addSubviews{
	[self.view addSubview:self.phoneTF];
	[self.view addSubview:self.getCodeBtn];
	[self.view addSubview:self.passwordTF];
	[self.view addSubview:self.submitBtn];
	
	[self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_offset(CGSizeMake(100, 44));
		make.right.equalTo(self.view).offset(-10);
		make.top.equalTo(self.view).offset(20);
	}];
	
	[self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.and.left.equalTo(self.view).offset(20);
		make.right.equalTo(self.getCodeBtn.mas_left).offset(-10);
		make.height.mas_equalTo(44);
	}];
	
	[self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.phoneTF);
		make.top.equalTo(self.phoneTF.mas_bottom).offset(10);
		make.right.equalTo(self.getCodeBtn);
		make.height.mas_equalTo(44);
	}];
	
	[self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.right.height.equalTo(self.passwordTF);
		make.top.mas_equalTo(self.passwordTF.mas_bottom).offset(10);
	}];

}

- (void)addRAC{
	@weakify(self);
	NSNumber *timerNumber = [NSNumber numberWithInteger:10];
	//倒计时效果
	RACSignal *(^counterSigner) (NSNumber *count) = ^RACSignal *(NSNumber *count){
		
		RACSignal *timerSignal=[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler];
		
		RACSignal *counterSignal=[[timerSignal scanWithStart:count reduce:^id(NSNumber *running, id next) {
			return @(running.integerValue -1);
		}] takeUntilBlock:^BOOL(NSNumber *x) {
			return x.integerValue<0;
		}];
		
		return [counterSignal startWith:count];
	};
	
	RACSignal *phoneEnableSignal=[self.phoneTF.rac_textSignal map:^id(NSString *value) {
		@strongify(self)
		if (value.length !=11) {
			[self.getCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		}else
			[self.getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		
		return @(value.length==11);
	}];
	
	RACSignal *passwordEnableSignal = [self.passwordTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
		return @(value.length ==6);
	}];
	
	RACCommand *codeBtnCommand = [[RACCommand alloc]initWithEnabled:phoneEnableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
		return counterSigner(timerNumber);
	}];
	
	RACSignal *counterStringSignal=[[codeBtnCommand.executionSignals switchToLatest] map:^id(NSNumber *value) {
		return [value stringValue];
	}];
	
	//executing 监听当前命令是否正在执行
	//filrter 过滤
	//mapReplace  map的简化版。替换
	RACSignal *resetStringSignal=[[codeBtnCommand.executing filter:^BOOL(NSNumber *value) {
		return !value.boolValue;
	}] mapReplace:@"获取验证码"];
	
 	[self.getCodeBtn rac_liftSelector:@selector(setTitle:forState:) withSignals:[RACSignal merge:@[counterStringSignal,resetStringSignal]],[RACSignal return:@(UIControlStateNormal)],nil];
	//    //上面也可以写成下面这样
	//    [[RACSignal merge:@[counterStringSignal,resetStringSignal]] subscribeNext:^(id x) {
	//        @strongify(self);
	//        [getCodeBtn setTitle:x forState:UIControlStateNormal];
	//    }];
	
	RAC(self.submitBtn, enabled) = [RACSignal combineLatest:@[phoneEnableSignal,passwordEnableSignal] reduce:^(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect){
		NSNumber *enable = @([isUsernameCorrect boolValue] && [isPasswordCorrect boolValue]) ;
		@strongify(self)
		if ([enable boolValue]) {
			[self.submitBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		}else{
			[self.submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		}
		return enable;
	}];
	//点击事件
	[[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
		NSLog(@"submitBtn touch");
	}];
	
	self.getCodeBtn.rac_command=codeBtnCommand;
}

@end
