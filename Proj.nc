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
#include "printf.h"
module Proj
{
	uses  interface Boot;  
	uses  interface Read<uint16_t> as Temperature;
	uses  interface Read<uint16_t> as Light;//interfeace for reading light  
	uses  interface Leds;  
	uses  interface Packet;  
	uses  interface Receive;  
	uses  interface AMSend;  
	uses  interface Timer<TMilli> as Timer; 
	uses  interface Timer<TMilli> as Timer2;//second timer for light   
	uses  interface SplitControl as RadioControl;  
	uses  interface SplitControl as SerialControl;  
	uses  interface Packet as SerialPacket;  
	uses  interface AMSend as SerialAMSend;
}
implementation
{
	message_t buf;
	message_t *receivedBuf;
	
	task void readSensor();
	task void readSensorLight();
	task void sendPacket();
	task void sendSerialPacket();
event void Boot.booted()
{
	call RadioControl.start();
	call SerialControl.start();
}
	
event void RadioControl.startDone(error_t err)
{
	if(TOS_NODE_ID == 1){
		call Timer.startPeriodic(2000);//Send temperature every two seconds
		call Timer2.startPeriodic(1000);//Send light reading every second
	}
}
event void Timer.fired()
{
	post readSensor();
}
event void Timer2.fired()//second timer fired for the light sensor
{
	post readSensorLight();
}
event void RadioControl.stopDone(error_t err){}
event void SerialControl.startDone(error_t err){}
event void SerialControl.stopDone(error_t err){}
task void readSensor()
{
	if(call Temperature.read() != SUCCESS)
		post readSensor();
}
task void readSensorLight()//function for reading data from the light sensor.
{
	if(call Light.read() != SUCCESS)
		post readSensor();
}
event void Temperature.readDone(error_t err, uint16_t value0)
{
	if(err != SUCCESS)
		post readSensor();
	else
	{
 		proj_message_t * payload = (proj_message_t *)call Packet.getPayload(&buf,sizeof(proj_message_t)); 
		value0 = -39.6 + 0.01 * value0; //For whatever reason the simulation kept reading the temperature as 6063. This line of code converts the value to something smaller like in the example video.
		payload->temperatureReading = value0;    
		printf("S1 Temperature %d !\n",value0);     
		post sendPacket(); 	
	}
}
event void Light.readDone(error_t err, uint16_t value0)
{
	//function for sending the message payload from sensor 1 to sensor 2
	if(err != SUCCESS)
		post readSensorLight();
	else
	{
 		proj_message_t * payload = (proj_message_t *)call Packet.getPayload(&buf,sizeof(proj_message_t));    		
		payload->lightReading = value0;    
		printf("S1 Light %d !\n",value0);     
		post sendPacket(); 	
	}
}
task void sendPacket()
{
	if(call AMSend.send(AM_BROADCAST_ADDR, &buf, sizeof(proj_message_t)) != SUCCESS)
		post sendPacket();
}
event void AMSend.sendDone(message_t * msg, error_t err)
{
	if(err != SUCCESS)
		post sendPacket();
}
event message_t * Receive.receive(message_t * msg, void * payload, uint8_t len)
{
        //printf("received message!/n"); 
        proj_message_t * demopayload = (proj_message_t *) payload;

	printf("Reading of Temperaturei");
	if((demopayload->temperatureReading)!= NULL){                        
		printf("Reading of Temperature: %d\n", demopayload->temperatureReading); 
	}
	printf("Reading of Lighti");//Reading the message sent from the light sensor.
	if((demopayload->lightReading)!= NULL){                        
		printf("Reading of Light: %d\n", demopayload->lightReading); 
	}	
        receivedBuf = msg;		 
        post sendSerialPacket();	
	return msg;
}
task void sendSerialPacket()
{
	if(call SerialAMSend.send(AM_BROADCAST_ADDR, receivedBuf, sizeof(proj_message_t))!= SUCCESS)
		post sendSerialPacket();
}
event void SerialAMSend.sendDone(message_t* ptr, error_t success) 
{
	if(success!=SUCCESS)
		post sendSerialPacket();
}

}

