#ifndef _COMMRTC_H__
#define _COMMRTC_H__


void RTCinit();

void adjTime(int y,int m,int d,int h,int mi,int s);
//void printTime();
void getTime(int * year,int * mon ,int * day ,int * hour ,int * min ,int * sec);



#endif