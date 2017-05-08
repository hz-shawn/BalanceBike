//
//  MainApi.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "MainApi.h"

@implementation MainApi

+(void)getSystemInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0x10 , 0x1E , 0xC3 , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}


+(void)getMainInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0xB0 , 0x20 , 0x21 , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}


+(void)getLimitSpeedInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0x73 , 0x04 , 0x7A , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)setLimitSpeedInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic speed:(int)speed{
    
    int lowBit = (speed & 0x00ff);
    int highBit = (speed & 0xff00) >> 8;
    
    int sum = (0x04 + 0x0A + 0x03 + 0x74 + lowBit + highBit);
    int unsum = 0xffff ^ sum;
    
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x74 , lowBit , highBit , lowCheckBit,highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//查询灵敏度
+(void)getSensorInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0xA1 , 0x0A , 0x46 , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)setShouBaLingMingDuInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic ShouBaLingMingDu:(int)lmd{
    
    int lowBit = (lmd & 0x00ff);
    int highBit = (lmd & 0xff00) >> 8;
    
    int sum = (0x04 + 0x0A + 0x03 + 0xA1 + lowBit + highBit);
    int unsum = 0xffff ^ sum;
    
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0xA1, lowBit , highBit , lowCheckBit,highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}
//设置骑行灵敏度
+(void)setQiXingLinMingDuInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic QiXingLinMingDu:(int)lmd{
    
    int lowBit = (lmd & 0x00ff);
    int highBit = (lmd & 0xff00) >> 8;
    
    int sum = (0x04 + 0x0A + 0x03 + 0xA2 + lowBit + highBit);
    int unsum = 0xffff ^ sum;
    
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0xA2, lowBit , highBit , lowCheckBit,highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}
//设置助理平衡点
+(void)setZhuLiPingHengInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic ZhuLiPingHeng:(int)lmd{
    
    int lowBit = (lmd & 0x00ff);
    int highBit = (lmd & 0xff00) >> 8;
    
    int sum = (0x04 + 0x0A + 0x03 + 0xA3 + lowBit + highBit);
    int unsum = 0xffff ^ sum;
    
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0xA3, lowBit , highBit , lowCheckBit,highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}

+(void)jiaozhun:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x75 , 0x01 , 0x00 ,0x78, 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}
//查询电量
+(void)getBatteryInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0C , 0x01 , 0x31 , 0x16 , 0xA8 , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}



+(void)getAlertModelInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0xD3 , 0x02 , 0x1C , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)setAlertModelInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic DengGuanBao:(int)value{
    int lowBit = (value & 0x00ff);
    int highBit = (value & 0xff00) >> 8;
    
    int sum = (0x04 + 0x0A + 0x03 + 0xD3 + lowBit + highBit);
    int unsum = 0xffff ^ sum;
    
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0xD3, lowBit , highBit , lowCheckBit,highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
+(void)setMachineNameInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic name:(NSData *)nameData{
 
        Byte *nameByte = (Byte *)[nameData bytes];
        
        int  first = (int)nameData.length + 2;
        
        int sum = first +  0x0A + 0x50 + 0x00 ;
        for (int i = 0; i < nameData.length; i++) {
            NSLog(@"%d",nameByte[i]);
            int value = nameByte[i];
            sum += value;
        }
        int unsum = 0xffff ^ sum;
        int lowCheckBit = (unsum & 0x00ff);
        int highCheckBit = (unsum & 0xff00) >> 8;
        NSUInteger size = 6+first;
        
        Byte bytes[]  = {0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0, 0,0, 0, 0 , 0 , 0};
        
        bytes[0] = 0x55;
        bytes[1] = 0xAA;
        bytes[2] = first;
        bytes[3] = 0x0A;
        bytes[4] = 0x50;
        bytes[5] = 0;
        for (int i = 0; i < nameData.length; i++) {
            int value = nameByte[i];
            bytes[6+i] = value;
        }
        
        bytes[6 + nameData.length] = lowCheckBit;
        bytes[7 + nameData.length] = highCheckBit;
        
        for (int i = 0 ; i < size; i++) {
            NSLog(@"%d-----%x",i,bytes[i]);
        }
        
        NSData *data = [NSData dataWithBytes:bytes length:size];
        
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        
    });
    
}


+(void)getPWDInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0x17 , 0x06 , 0xD4 , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)setpwdInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic pwd:(NSString *)pwd{
    const char *s = [pwd UTF8String];
    int sum  = 0x08 + 0x0A + 0x03 + 0x17;
    
    for (int i = 0; i < pwd.length; i++) {
        int value = s[i];
        sum += value;
    }
    
    int unsum = 0xffff ^ sum;
    
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[14] ;
    
    byte[0] = 0x55;
    byte[1] = 0xAA;
    byte[2] = 0x08;
    byte[3] = 0x0A;
    byte[4] = 0x03;
    byte[5] = 0x17;
    
    for (int i = 0; i < pwd.length; i++) {
        int value = s[i];
        byte[6+i] = value;
    }
    
    
    byte[6 + pwd.length] = lowCheckBit;
    byte[7 + pwd.length] = highCheckBit;
    
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}


+(void)xiansu:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x72 , 0x01 , 0x00 , 0x7B, 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)jieChuxiansu:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x72 , 0x00 , 0x00 , 0x7C, 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}



+(void)getHeiXiaZiInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic index:(int)index{
    
    int lowBit = (index & 0x00ff);
    int highBit = (index & 0xff00) >> 8;
    int sum = (0x04 + 0x0A + 0x05 + lowBit + highBit +  0x08 );
    int unsum = 0xffff ^ sum;
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x05 , lowBit , highBit, 0x08 , lowCheckBit, highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)getLightInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0xC6 , 0x1A , 0x11 , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)suoche:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x70 , 0x01 , 0x00 , 0x7D, 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
+(void)jiesuo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x71 , 0x01 , 0x00 , 0x7C, 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
+(void)suocheWithoutAlert:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0xD3 , 0x03 , 0x00 , 0x18, 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)setColor:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic lightId:(int)lightId color:(int) color{
    
    int sum = (0x04 + 0x0A + 0x03 + lightId + color +  0xF0 );
    int unsum = 0xffff ^ sum;
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , lightId ,  0xF0 , color, lowCheckBit, highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}

+(void)setmoshi:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic  moshi:(int) moshi{
    int lowBit = (moshi & 0x00ff);
    int highBit = (moshi & 0xff00) >> 8;
    int sum = (0x04 + 0x0A + 0x03 + 0xC6+ lowBit + highBit );
    int unsum = 0xffff ^ sum;
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 ,0xC6, lowBit , highBit , lowCheckBit, highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}


+(void)setYKSpeed:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic  speed: (float) speed{
    int moshi = speed * 1000;
    int lowBit = (moshi & 0x00ff);
    int highBit = (moshi & 0xff00) >> 8;
    int sum = (0x04 + 0x0A + 0x03 + 0x7D+ lowBit + highBit );
    int unsum = 0xffff ^ sum;
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 ,0x7D, lowBit , highBit , lowCheckBit, highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}
+(void)getYKXianSu:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0x7D , 0x02 , 0x72 ,0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)setYkModel:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x7A , 0x01 , 0x00 ,0x73 ,0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
+(void)quiteYkModel:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x7A , 0x00 , 0x00 ,0x74 ,0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)setYkSpeed:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic x:(int)x y:(int)y{
    
    int lowBitx = (x & 0x00ff);
    int highBitx = (x & 0xff00) >> 8;
    int lowBity = (y & 0x00ff);
    int highBity = (y & 0xff00) >> 8;
    
    int sum = (0x06 + 0x0A + 0x03 + 0x7B+ lowBitx + highBitx + lowBity + highBity );
    int unsum = 0xffff ^ sum;
    int lowCheckBit = (unsum & 0x00ff);
    int highCheckBit = (unsum & 0xff00) >> 8;
    
    Byte byte[] = {0x55, 0xAA, 0x06 , 0x0A , 0x03 ,0x7B, lowBitx , highBitx, lowBity,highBity, lowCheckBit, highCheckBit};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}

+(void)getYkStatus:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x03 , 0x0A , 0x01 , 0xB2 , 0x08 , 0x3D , 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

+(void)shutDown:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic{
    Byte byte[] = {0x55, 0xAA, 0x04 , 0x0A , 0x03 , 0x79 , 0x01 , 0x00 , 0x74, 0xFF};
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    [peripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}
@end
