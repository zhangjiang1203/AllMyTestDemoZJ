//
//  ZJBlueToothViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/21.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJBlueToothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ZJBlueToothViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong,nonatomic)CBCentralManager *cbManager;

@property (strong,nonatomic)NSMutableArray *blueSourceArr;
@end

@implementation ZJBlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blueSourceArr = [NSMutableArray array];
    [TableEmptyData shareManager].emptyDataColor = UIColorFromRGB(0xF2F2F2);
    [self.myTableView setMethodDelegateAndDataSource];
    
    self.cbManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    //扫描周围蓝牙
    NSDictionary *dict = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(0)};
    [self.cbManager scanForPeripheralsWithServices:nil options:dict];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.blueSourceArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    CBPeripheral *peripheral = self.blueSourceArr[indexPath.row];
    cell.textLabel.text = peripheral.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *peripheral = self.blueSourceArr[indexPath.row];
    
    [self.cbManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(1)}];
}

//发现蓝牙设备，也就是收到了一个周围的蓝牙发来的广告信息，这是CBCentralManager会通知代理来处理,不止一个蓝牙设备会被调用多次
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    [self.blueSourceArr addObject:peripheral];
    [self.myTableView reloadData];
}
//连接之后的代理方法
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接上了");
}

//blueTooth代理方法
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"蓝牙连接--");
    
    
    
}

@end
