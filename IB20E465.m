IB20E465	;ALB/TDM - ENVIRONMENT CHECK WITH PRE-INIT CODE ; 12/6/11 10:05am
	;;2.0;INTEGRATED BILLING;**465**;21-MAR-94;Build 5
	;
	Q
	;
	;
POS1	; Ask if user wants to print or update and print if "APRIOR" X-ref is
	; set for 12/1/2010.
	I '$D(^IBA(354.1,"APRIOR",3101201)) K DIR Q
	D MES^XPDUTL("There are exemptions that were based on the threshold values")
	D MES^XPDUTL("over a year old. You can Print a list of patients with old ")
	D MES^XPDUTL("exemptions, or automatically Update while printing the same")
	D MES^XPDUTL("list.  This will take place in the post initialization process.")
	Q
	;
	;
POS2	; Ask device to print the report to, if "APRIOR" X-ref is set for 12/1/10.
	I '$D(^IBA(354.1,"APRIOR",3101201)) K DIR Q
	K DIR
	S %ZIS="QNM0" D ^%ZIS I POP D BMES^XPDUTL("This is a required response.  Select a printer.") G POS2
	S XPDQUES("POS2")=ION
	D HOME^%ZIS
	Q
