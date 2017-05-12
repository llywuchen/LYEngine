//
//  ViewController.m
//  MVVM-test
//
//  Created by llywuchen on 2017/5/1.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import "ViewController.h"

#import "ViewModelProtocol.h"
#import "ListVMProtocol.h"

//#define ViewControllerReadly

#ifdef ViewControllerReadly
#import "ViewModel.h"
#import "ListViewModel.h"
#endif


@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSObject<ViewModel> * viewModel;
@property (nonatomic,strong) NSObject<ListVMProtocol> * listViewModel;

@property (nonatomic,strong) UITextField *userNameField;
@property (nonatomic,strong) UITextField *userPwdField;

@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *userPwdLabel;

@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _userNameField = [[UITextField alloc]init];
    _userNameField.delegate = self;
    _userNameField.backgroundColor = [UIColor lightGrayColor];
    _userPwdField = [[UITextField alloc]init];
    _userPwdField.delegate = self;
    _userPwdField.backgroundColor = [UIColor lightGrayColor];
    
    _userNameLabel = [[UILabel alloc]init];
    _userNameLabel.text = @"name";
    _userPwdLabel = [[UILabel alloc]init];
    _userPwdLabel.text = @"password";
    
    _loginBtn = [[UIButton alloc]init];
    [_loginBtn setTitle:@"login" forState:UIControlStateNormal];
    _loginBtn.backgroundColor = [UIColor lightGrayColor];
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_userNameField];
    [self.view addSubview:_userPwdField];
    [self.view addSubview:_userNameLabel];
    [self.view addSubview:_userPwdLabel];
    [self.view addSubview:_loginBtn];
    
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@50);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [_userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_userNameLabel);
        make.left.equalTo(_userNameLabel.mas_right).offset(10);
        make.width.equalTo(@100);
    }];
    
    [_userPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.left.equalTo(_userNameLabel);
        make.top.equalTo(_userNameLabel.mas_bottom).offset(20);
    }];
    
    [_userPwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_userNameField);
        make.top.bottom.equalTo(_userPwdLabel);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userPwdField.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(85, 55));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
    }];
    
    
    [RACObserve(self.viewModel,VD_userName) subscribeNext:^(id  _Nullable x) {
        self.userNameField.text = x;
    }];
    
    [RACObserve(self.viewModel,VD_userPwd) subscribeNext:^(id  _Nullable x) {
        self.userPwdField.text = x;
    }];
    
    [RACObserve(self.listViewModel,VD_list) subscribeNext:^(id  _Nullable x) {
        [self.tableView reloadData];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewModel
#ifdef ViewControllerReadly
LYSynthesizeViewModelReadly(ViewModel,ViewModel);
LYSynthesizeSubViewModelRegisterAndReadly(self.tableView,listViewModel,ListVMProtocol,ListViewModel);
#else
LYSynthesizeViewModelUnReadly(ViewModel);
LYSynthesizeSubViewModelRegisterAndUnReadly(self.tableView, listViewModel, ListVMProtocol);
#endif


#pragma mark - delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField==_userNameField){
        self.viewModel.VD_userPwd = textField.text;
    }else{
        self.viewModel.VD_userPwd = textField.text;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listViewModel.VD_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    LYTViewData *obj = self.listViewModel.VD_list[indexPath.row];
    cell.textLabel.text = obj.VD_name;
    cell.detailTextLabel.text = obj.VD_nick;
    return cell;
}

#pragma mark - action
- (void)login:(UIButton *)sender{
    [self.userPwdField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    NSLog(@"%@-%@",self.viewModel.VD_userName,self.viewModel.VD_userPwd);
    
    [self.viewModel performSelector:@selector(VD_refresh) withObject:nil afterDelay:1];
}


@end
