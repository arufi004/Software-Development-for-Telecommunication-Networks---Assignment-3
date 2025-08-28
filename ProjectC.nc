/*
Name:			Anthony Rufin
Panther ID		6227314

Class:			TCN5440
Section:		U01
Semester:		Spring 2025

Assignment		Programming Assignment 3
Due:			April 24, 2025

Honesty Statement: 	I have done this assignment completely on my own. I have not copied it, nor have I given my solution to anyone else. 
			I understand that if I am involved in plagiarism or cheating I will receive the penalty specified in the FIU regulations. 
*/
#include "ProjMessage.h"

configuration ProjectC
{
}

implementation
{
 	components Proj, MainC, LedsC, ActiveMessageC;
	components new SensirionSht11C() as TempC;  
	components new HamamatsuS10871TsrC() as LightC;//Light sensor component
	components new AMSenderC(AM_PROJ_MESSAGE);  
	components new AMReceiverC(AM_PROJ_MESSAGE);  
	components new TimerMilliC() as Timer; 
	components new TimerMilliC() as Timer2;//Second timer for light. 
	components SerialActiveMessageC as SerialC;  
	components SerialPrintfC;    

	Proj.Boot -> MainC;  
	Proj.Temperature -> TempC.Temperature;
	Proj.Light -> LightC;  
	Proj.Receive -> AMReceiverC;  
	Proj.AMSend -> AMSenderC;  
	Proj.RadioControl -> ActiveMessageC;  
	Proj.Leds -> LedsC;  
	Proj.Timer -> Timer;  
	Proj.Timer2 -> Timer2;
	Proj.Packet -> ActiveMessageC;  
	Proj.SerialControl -> SerialC;
	Proj.SerialAMSend -> SerialC.AMSend[AM_PROJ_MESSAGE];
	Proj.SerialPacket -> SerialC;}

