XOBVGTM	;ISF/RWF - Vistalink startup for GT.M v5 from xinetd ;8/29/07  11:13
	;;1.0;VISTALINK;;WorldVistA;Build 3;Build 29
	;Modified from FOIA VISTA,
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
GTMLNX	; -- Linux xinetd multi-thread entry point for GT.M
	;
	NEW XOBEC
	DO ESET^XOBVTCP
	;
	; **GTM/linux specific code**
	SET (IO,IO(0))=$P,@("$ZT=""""")
	X "U IO:(nowrap:nodelimiter:IOERROR=""TRAP"")" ;Setup device
	S @("$ZINTERRUPT=""I $$JOBEXAM^ZU($ZPOSITION)"""),X=""
	X "ZSHOW ""D"":TMP"
	F %=1:1 Q:'$D(TMP($J,"D",%))  S X=^(%) Q:X["LOCAL"
	S IO("IP")=$P($P(X,"REMOTE=",2),"@"),IO("PORT")=+$P($P(X,"LOCAL=",2),"@",2)
	;End GT.M code
	;
	SET XOBEC=$$NEWOK^XOBVTCPL()
	IF XOBEC DO LOGINERR^XOBVTCPL(XOBEC,IO)
	IF 'XOBEC DO COUNT^XUSCNT(1),SPAWN^XOBVLL,COUNT^XUSCNT(-1)
	QUIT
	;
	;Sample linux scripts
	;xinetd script
	;vvvvvvvvvvvvvvvvvvvvvvvvv
	;service vistalink
	;{
	;   socket_type     = stream
	;   port            = 18001
	;   type            = UNLISTED
	;   user            = vista
	;   wait            = no
	;   disable         = no
	;   server          = /bin/bash
	;   server_args     = /home/vista/dev/vistalink.sh
	;   passenv         = REMOTE_HOST
	;}
	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	;
	;cat /home/vista/dev/vistalink.sh
	;vvvvvvvvvvvvvvvvvvvvvvvvvvvv
	;#!/bin/bash
	;#RPC Broker
	;cd /home/vista/dev
	;. ./gtmprofile
	;$gtm_dist/mumps -r GTMLNX^XOBVGTM
	;exit 0
	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
