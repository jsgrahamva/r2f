XMRUCX	;(WASH ISC)/THM/CAP-SMTP Receiver (RFC 821) for UCX ;7:56 AM  5 Apr 2014
	;;8.0;MailMan;**6,19,25,27,44,WVEHR,LOCAL**;Jun 28, 2002;Build 3
	;
	;
	       ; Copyright 2015 WorldVistA.
	       ;
	       ; This program is free software: you can redistribute it and/or modify
	       ; it under the terms of the GNU Affero General Public License as
	       ; published by the Free Software Foundation, either version 3 of the
	       ; License, or (at your option) any later version.
	       ;
	       ; This program is distributed in the hope that it will be useful,
	       ; but WITHOUT ANY WARRANTY; without even the implied warranty of
	       ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	       ; GNU Affero General Public License for more details.
	       ;
	       ; You should have received a copy of the GNU Affero General Public License
	       ; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	       ;
	;Entry for Inet_servers interface RECEIVER
	;SMTP service request invokes MailMan
SOC25	;
	;S (XMRPORT,IO,IO(0))=%,X=$E(%_"-INETMM",1,15) D SETENV^%ZOSV
	;I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP="D R^XMCTRAP Q"
	;E  S X="R^XMCTRAP",@^%ZOSF("TRAP")
	;D DT^DICRW,DUZ^XUP(.5)
	;S ER=0
	;O IO:(SHARE) U IO
	;S XMCHAN="TCP/IP-MAILMAN",XMNO220=""
	;D ENT^XMR
	;;G HALT^XMRTCP
	;Q
SOC	;
	S (XMRPORT,IO,IO(0))="SYS$NET",X=$E(%_"INETMM",1,15) D SETENV^%ZOSV
	I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP="S ZZIO=$ZIO H 33 D R^XMCTRAP Q"
	E  S X="R^XMCTRAP",@^%ZOSF("TRAP")
	D DT^DICRW,DUZ^XUP(.5)
	S ER=0
	O IO:(TCPDEV):33 U IO
	S XMCHAN="TCP/IP-MAILMAN",XMNO220=""
	D ENT^XMR
	;G HALT^XMRTCP
	Q
GTM2	;Entry point for %ZISTCPS to GT.M
	;The device has been open and setup in %ZISTCPS
	N $ETRAP,$ESTACK S $ETRAP="D ^%ZTER S ZZIO=$ZIO H 33 D R^XMCTRAP Q"
	S XMRPORT=IO
	D SETNM^%ZOSV($E(IO_"INETMM",1,15)),COUNT^XUSCNT(1) ;Process counting under GT.M
	N DIQUIET S DIQUIET=1 D DT^DICRW,DUZ^XUP(.5)
	S ER=0,XMS0C=1
	U IO:(DELIMITER=$C(13))
	S XMCHAN="TCP/GTM" ;,XMNO220=""
	D ENT^XMR
	D COUNT^XUSCNT(-1) ;Check out GT.M counting
	Q
STARTGTM	;Start the %ZISTCPS service
	D LISTEN^%ZISTCPS(25,"GTM2^XMRUCX")
	Q
	;
	;Begin WorldVistA change
GTMLNX	;From Linux xinetd script
	S U="^",$ETRAP="D ^%ZTER S ZZIO=$ZIO H 33 D R^XMCTRAP Q"
	;GTM specific code
	S @("$ZINTERRUPT=""I $$JOBEXAM^ZU($ZPOSITION)""")
	S (XMRPORT,IO,IO(0))=$P X "U XMRPORT:(nowrap:delimiter=$C(13))"
	S %="",@("%=$ZTRNLNM(""REMOTE_HOST"")") S:$L(%) IO("GTM-IP")=%
	D SETNM^%ZOSV($E(XMRPORT_"INETMM",1,15)),COUNT^XUSCNT(1) ;Process counting under GT.M
	S XMCHAN="TCP/GTM",XMNO220=""
	N DIQUIET S DIQUIET=1 D DT^DICRW,DUZ^XUP(.5)
	D ENT^XMR
	D COUNT^XUSCNT(-1) ;Check out GT.M counting
	Q
	;End WorldVistA change
	;
CACHEVMS	;Cache/VMS tcpip service and XINETD entry point
	N $ETRAP,$ESTACK,XMOS S $ETRAP="S ZZIO=$ZIO H 33 D R^XMCTRAP Q"
	;CHECK OS WHEN SETTING IO VARIABLES XM*8*44 RRA
	S XMOS=$$OS^%ZOSV
	S (XMRPORT,IO,IO(0))=$S(XMOS["VMS":"SYS$NET",1:$P) D SETNM^%ZOSV($E("INETMM-"_$J,1,15))
	N DIQUIET S DIQUIET=1 D DT^DICRW,DUZ^XUP(.5)
	S ER=0,XMS0C=1
	O IO::33 U IO:(::"-M")
	S XMCHAN="TCP/IP-MAILMAN",XMNO220=""
	D ENT^XMR
	Q
