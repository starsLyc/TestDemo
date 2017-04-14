//
//  UUID.h
//  BLEDKSDK
//
//  Created by D500 user on 13/2/19.
//  Copyright (c) 2013年 D500 user. All rights reserved.
//

#ifndef BLEDKSDK_UUID_h
#define BLEDKSDK_UUID_h

//GAP
#define UUIDSTR_GAP_SERVICE @"1800"

//Device Info service
#define UUIDSTR_DEVICE_INFO_SERVICE             @"180A"
#define UUIDSTR_MANUFACTURE_NAME_CHAR           @"2A29"
#define UUIDSTR_MODEL_NUMBER_CHAR               @"2A24"
#define UUIDSTR_SERIAL_NUMBER_CHAR              @"2A25"
#define UUIDSTR_HARDWARE_REVISION_CHAR          @"2A27"
#define UUIDSTR_FIRMWARE_REVISION_CHAR          @"2A26"
#define UUIDSTR_SOFTWARE_REVISION_CHAR          @"2A28"
#define UUIDSTR_SYSTEM_ID_CHAR                  @"2A23"
#define UUIDSTR_IEEE_11073_20601_CHAR           @"2A2A"

#define UUIDSTR_ISSC_PROPRIETARY_SERVICE        @"49535343-FE7D-4AE5-8FA9-9FAFD205E455"
#define UUIDSTR_CONNECTION_PARAMETER_CHAR       @"49535343-6DAA-4D02-ABF6-19569ACA69FE"
#define UUIDSTR_AIR_PATCH_CHAR                  @"49535343-ACA3-481C-91EC-D85E28A60318"
#define UUIDSTR_ISSC_TRANS_TX                   @"49535343-1E4D-4BD9-BA61-23C647249616"     //读
#define UUIDSTR_ISSC_TRANS_RX                   @"49535343-8841-43F4-A8D4-ECBE34729BB3"     //写
#define UUIDSTR_ISSC_MP                         @"49535343-ACA3-481C-91EC-D85E28A60318"



//电池电量服务的UUID
#define LPSnoreBattery  @"180F"
//电池电量value的UUID
#define LPSnoreBatteryValue  @"2A19"

//血氧值服务
#define LPSnoreSpO2 @"F040"
//血氧值value
#define LPSnoreSpO2Value @"F041"

//脉率的服务
#define LPSnorePulse @"F020"
//脉率的value
#define LPSnorePulseValue @"F021"

//时间
#define LPSnorTime @"1805"
#define LPSnorTimeValue @"2A2B"


//电刺激
#define LPSnorElectricalStimulation @"F030"
#define LPSnorElectricalStimulationValue @"F031"


#endif
