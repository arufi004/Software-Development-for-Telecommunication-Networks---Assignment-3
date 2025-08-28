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
#ifndef __PROJMESSAGE_H
#define __PROJMESSAGE_H
/*{  
   nx_uint16_t temperatureReading;
} demo_message_t;
Enum
{  
   AM_DEMO_MESSAGE = 200,
};*/

typedef nx_struct proj_message
{
  nx_uint16_t temperatureReading;
  nx_uint16_t humidityReading;
  nx_uint16_t lightReading;

}
  proj_message_t;
enum
{
  AM_PROJ_MESSAGE = 200,
};


#endif //__DEMOMESSAGE_H

