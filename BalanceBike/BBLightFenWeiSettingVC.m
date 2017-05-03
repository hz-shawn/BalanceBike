//
//  BBLightFenWeiSettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/25.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBLightFenWeiSettingVC.h"

@interface BBLightFenWeiSettingVC ()
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;
@property (weak,nonatomic) UITableViewCell *selectedCell;
@end

@implementation BBLightFenWeiSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //设置cell的选中状态
    UITableViewCell *cell = self.cells[self.info.moshi];
    self.selectedCell = cell;
}


-(void)setSelectedCell:(UITableViewCell *)selectedCell{
    _selectedCell.accessoryType = UITableViewCellAccessoryNone;
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedCell = selectedCell;
}
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = self.cells[indexPath.row];
    self.selectedCell = cell;
    [MainApi setmoshi:self.peripheral writeCharacteristic:self.writeCharacteristic moshi:(int)(indexPath.row)];
}


@end
