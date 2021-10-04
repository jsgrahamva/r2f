DGPT501P	;ALB/MTC,HIOFO/FT - Parse 501 Record ;10/29/2014 3:14pm
	;;5.3;Registration;**884**;Aug 13, 1993;Build 31
	;
SET	; Set up 501 variables. Called from PARSE^DGPT501
	D:DGPTFMT=2 SET9
	D:DGPTFMT=3 SET10
	Q
SET9	;record layout before icd10 turned on
	S DGPTMSR=$E(DGPTSTR,41,46) ;specialty cdr code
	S DGPTMSC=$E(DGPTSTR,47,48) ;specialty code
	S DGPTMLD=$E(DGPTSTR,49,51) ;leave days
	S DGPTMPD=$E(DGPTSTR,52,54) ;pass days
	S DGPTMSI=$E(DGPTSTR,55) ;spinal cord injury indicator
	S (DGPTMD1,DGPTMD11)=$P($E(DGPTSTR,56,62)," ") ;diagnosis codes 1-5
	S DGPTMD2=$P($E(DGPTSTR,63,69)," ")
	S DGPTMD3=$P($E(DGPTSTR,70,76)," ")
	S DGPTMD4=$P($E(DGPTSTR,77,83)," ")
	S DGPTMD5=$P($E(DGPTSTR,84,90)," ")
	S DGPTMXX=$E(DGPTSTR,91,99) ;spaces, not used
	S DGPTMLR=$E(DGPTSTR,100,105) ;physical location cdr code
	S DGPTMLC=$E(DGPTSTR,106,107) ;physical location code
	S DGPTMBS=$E(DGPTSTR,108) ;bed status (discharge movement only)
	S DGPTMLG=$E(DGPTSTR,109) ;legionnaires indicator
	S DGPTMSU=$E(DGPTSTR,110) ;suicide indicator
	S DGPTMDG=$E(DGPTSTR,111,114) ;drug indicator
	S DGPTMXIV=$E(DGPTSTR,115) ;axes 4 & 5
	S DGPTMXV1=$E(DGPTSTR,116,117) ;axes 4 & 5
	S DGPTMXV2=$E(DGPTSTR,118,119) ;axes 4 & 5
	S DGPT50SR=$E(DGPTSTR,120) ;service
	Q
SET10	;record layout after icd10 turned on
	S DGPTMSR=$E(DGPTSTR,41,46) ;specialty cdr code
	S DGPTMSC=$E(DGPTSTR,47,48) ;specialty code
	S DGPTMLD=$E(DGPTSTR,49,51) ;leave days
	S DGPTMPD=$E(DGPTSTR,52,54) ;pass days
	S DGPTMSI=$E(DGPTSTR,55) ;spinal cord injury indicator
	S DGPTMD1=$E(DGPTSTR,56,62),DGPTMPOA1=$E(DGPTSTR,63) ;diagnosis & poa codes
	S DGPTMD2=$E(DGPTSTR,64,70),DGPTMPOA2=$E(DGPTSTR,71)
	S DGPTMD3=$E(DGPTSTR,72,78),DGPTMPOA3=$E(DGPTSTR,79)
	S DGPTMD4=$E(DGPTSTR,80,86),DGPTMPOA4=$E(DGPTSTR,87)
	S DGPTMD5=$E(DGPTSTR,88,94),DGPTMPOA5=$E(DGPTSTR,95)
	S DGPTMD6=$E(DGPTSTR,96,102),DGPTMPOA6=$E(DGPTSTR,103)
	S DGPTMD7=$E(DGPTSTR,104,110),DGPTMPOA7=$E(DGPTSTR,111)
	S DGPTMD8=$E(DGPTSTR,112,118),DGPTMPOA8=$E(DGPTSTR,119)
	S DGPTMD9=$E(DGPTSTR,120,126),DGPTMPOA9=$E(DGPTSTR,127)
	S DGPTMD10=$E(DGPTSTR,128,134),DGPTMPOA10=$E(DGPTSTR,135)
	S DGPTMD11=$E(DGPTSTR,136,142),DGPTMPOA11=$E(DGPTSTR,143)
	S DGPTMD12=$E(DGPTSTR,144,150),DGPTMPOA12=$E(DGPTSTR,151)
	S DGPTMD13=$E(DGPTSTR,152,158),DGPTMPOA13=$E(DGPTSTR,159)
	S DGPTMD14=$E(DGPTSTR,160,166),DGPTMPOA14=$E(DGPTSTR,167)
	S DGPTMD15=$E(DGPTSTR,168,174),DGPTMPOA15=$E(DGPTSTR,175)
	S DGPTMD16=$E(DGPTSTR,176,182),DGPTMPOA16=$E(DGPTSTR,183)
	S DGPTMD17=$E(DGPTSTR,184,190),DGPTMPOA17=$E(DGPTSTR,191)
	S DGPTMD18=$E(DGPTSTR,192,198),DGPTMPOA18=$E(DGPTSTR,199)
	S DGPTMD19=$E(DGPTSTR,200,206),DGPTMPOA19=$E(DGPTSTR,207)
	S DGPTMD20=$E(DGPTSTR,208,214),DGPTMPOA20=$E(DGPTSTR,215)
	S DGPTMD21=$E(DGPTSTR,216,222),DGPTMPOA21=$E(DGPTSTR,223)
	S DGPTMD22=$E(DGPTSTR,224,230),DGPTMPOA22=$E(DGPTSTR,231)
	S DGPTMD23=$E(DGPTSTR,232,238),DGPTMPOA23=$E(DGPTSTR,239)
	S DGPTMD24=$E(DGPTSTR,240,246),DGPTMPOA24=$E(DGPTSTR,247)
	S DGPTMD25=$E(DGPTSTR,248,254),DGPTMPOA25=$E(DGPTSTR,255)
	S DGPTAPSSN=$E(DGPTSTR,256,264) ;attending physician ssn
	S DGPTMLR=$E(DGPTSTR,265,270) ;physical location cdr code
	S DGPTMLC=$E(DGPTSTR,271,272) ;physical location code
	S DGPTMBS=$E(DGPTSTR,273) ;bed status (discharge movement only)
	Q
