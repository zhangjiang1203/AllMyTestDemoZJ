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

//blueTooth代理方法
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        case CBCentralManagerStateResetting:
        case CBCentralManagerStateUnsupported:
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStatePoweredOff:
        {
           [HUDHelper confirmMsg:@"请在“设置”-“蓝牙”中，先打开蓝牙功能" continueBlock:^{
               NSLog(@"打开蓝牙功能");
           }];
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            //开始扫描周围的外设
            [self.cbManager scanForPeripheralsWithServices:nil options:nil];

        }
            break;
    }
}


//扫面到设备会进入这个代理方法，不止一个蓝牙设备会被调用多次
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    [self.blueSourceArr addObject:peripheral];
    [self.myTableView reloadData];
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
    //开始连接设备，一个设备最多连接7个设备
    [self.cbManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(1)}];
}


//连接成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接到设备为--%@的设备，成功",peripheral.name);
    //设置peripheral代理方法
    [peripheral setDelegate:self];
    //扫描外设services 成功之后进入-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [peripheral discoverServices:nil];
}


//连接失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"连接到设备为--%@的设备，失败---%@",peripheral.name,error.description);
}

//断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"外设连接断开--%@:%@",peripheral.name,[error localizedDescription]);
}

//扫描到services
-(void)peripheral:(CBPeripheral*)peripheral didDiscoverServices:(nullable NSError *)error{
    NSLog(@"扫描到服务：%@",peripheral.services);
    if (error) {
        NSLog(@"扫描外部设备--%@ 出错--%@",peripheral.name,[error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        //扫描每个service的Characteristics，扫描到后会进入方法-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//获取外设的Characteristics,获取characteristics的值，获取Characteristics的Description和Descriptor的值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error){
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"service:%@ 的 Characteristics:%@",service.UUID,characteristic.UUID);
    }
    
    //获取Characteristics的值,读取数据会进入的方法 -(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristics in service.characteristics) {
        [peripheral readValueForCharacteristic:characteristics];
    }
    
    //搜索Characteristics的Descriptors，读取数据会进入方法-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristics in service.characteristics) {
        [peripheral discoverDescriptorsForCharacteristic:characteristics];
    }
}

//获取的Characteristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出Characteristic的UUID和值
    //value的值类型是NSData，具体开发时会根据外设协议制定的方法去解析数据
    NSLog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
}

//搜索到Characteristics的DEscriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"Characteristics UUID:%@",characteristic.UUID);
    
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        NSLog(@"descriptor uuid：%@",descriptor.UUID);
    }
}


//获取到descriptor的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
}


//把数据写到Characteristic中
-(void)writeCharacteristic:(CBPeripheral*)peripheral characteristic:(CBCharacteristic*)characteristic value:(NSData*)value{
    NSLog(@"%lu",(unsigned long)characteristic.properties);
    //只有Characteristics.propertise 有write的权限才可以写
    if (characteristic.properties & CBCharacteristicPropertyWrite) {
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"该字段不可用");
    }
}

//订阅Characteristics的通知
-(void)notifyCharacteristic:(CBPeripheral*)peripheral characteristic:(CBCharacteristic*)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForChararteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral*)peripheral characteristic:(CBCharacteristic*)characteristic{
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

//断开连接
-(void)disconnectPeripheral:(CBCentralManager*)centralManager peripheral:(CBPeripheral*)peripheral{
    [centralManager stopScan];//停止扫描
    [centralManager cancelPeripheralConnection:peripheral];//断开连接
}






@end
