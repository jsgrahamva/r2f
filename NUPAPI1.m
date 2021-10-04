NUPAPI1	;PHOENIX/KLD; 7/15/09; NUPA POST-INIT; 2/23/12  1:25 PM
	;;1.0;NUPA;;;Build 105
ST	Q
	;
HF	;Enter AA Health Factors
	N DIC,NUPA,X S DIC="^AUTTHF(",DIC(0)="L"
	F NUPA("I")=0:1 S X=$P($T(H+NUPA("I")),";",3,4),X(1)=$P(X,";",2),X=$P(X,";") Q:X=""  S X="ONS AA "_X D:'$D(^AUTTHF("B",X)) ADD
	F NUPA("I")=0:1 S X=$P($T(AA+NUPA("I")^NUPAPI),";",3,4),X(1)=$P(X,";",2),X=$P(X,";") Q:"END"[X  S X="ONS AA "_X D:'$D(^AUTTHF("B",X)) ADD ;For routine size purposes
	Q
	;
ADD	S:$E(X(1),1,3)'="ONS" X(1)="ONS AA "_X(1)
	S DIC("DR")=".1///F;.08///Y;.03///"_X(1) K DD,DO D FILE^DICN Q
	;
H	;;ABUSE FINANCIAL REPORTED;PSYCHOSOCIAL
	;;ABUSE NEGLECT REPORTED;PSYCHOSOCIAL
	;;ABUSE NEGLECT SUSPECTED;PSYCHOSOCIAL
	;;ABUSE PHYSICAL REPORTED;PSYCHOSOCIAL
	;;ABUSE PHYSICAL SUSPECTED;PSYCHOSOCIAL
	;;ABUSE SEXUAL REPORTED;PSYCHOSOCIAL
	;;ABUSE SUSPECTED BY PATIENT YES;PSYCHOSOCIAL
	;;ABUSE VERBAL REPORTED;PSYCHOSOCIAL
	;;ABUSE VERBAL SUSPECTED;PSYCHOSOCIAL
	;;AUTONOMIC DYSREFLEXIA HX NO;NEUROLOGICAL
	;;AUTONOMIC DYSREFLEXIA HX YES;NEUROLOGICAL
	;;BOWEL PROGRAM YES;GASTROINTESTINAL
	;;BRADEN SCALE 10-12;BRADEN SCALE
	;;BRADEN SCALE 13-14;BRADEN SCALE
	;;BRADEN SCALE 15-18;BRADEN SCALE
	;;BRADEN SCALE 19 OR HIGHER;BRADEN SCALE
	;;BRADEN SCALE 9 OR LOWER;BRADEN SCALE
	;;CENTRAL LINE #1 DATE DISCONTINUED;VASCULAR ACCESS
	;;CENTRAL LINE #1 DATE INSERTED;VASCULAR ACCESS
	;;CENTRAL LINE #2 DATE DISCONTINUED;VASCULAR ACCESS
	;;CENTRAL LINE #2 DATE INSERTED;VASCULAR ACCESS
	;;CENTRAL LINE #3 DATE DISCONTINUED;VASCULAR ACCESS
	;;CENTRAL LINE #3 DATE INSERTED;VASCULAR ACCESS
	;;CENTRAL LINE #4 DATE DISCONTINUED;VASCULAR ACCESS
	;;CENTRAL LINE #4 DATE INSERTED;VASCULAR ACCESS
	;;CENTRAL LINE #5 DATE DISCONTINUED;VASCULAR ACCESS
	;;CENTRAL LINE #5 DATE INSERTED;VASCULAR ACCESS
	;;CENTRAL LINE #1 ON ADMISSION;VASCULAR ACCESS
	;;CENTRAL LINE #2 ON ADMISSION;VASCULAR ACCESS
	;;CENTRAL LINE #3 ON ADMISSION;VASCULAR ACCESS
	;;CV ASSESS NO RESPONSE;CARDIOVASCULAR
	;;DYSPHAGIA CANT FOLLOW COMMANDS;GASTROINTESTINAL
	;;DYSPHAGIA DROOLING WHILE AWAKE;GASTROINTESTINAL
	;;DYSPHAGIA MOD TEXT/EAT MANEUVERS;GASTROINTESTINAL
	;;DYSPHAGIA NEW DX STROKE/HN CA/TBI;GASTROINTESTINAL
	;;DYSPHAGIA SCREEN NO;GASTROINTESTINAL
	;;DYSPHAGIA SCREEN YES;GASTROINTESTINAL
	;;DYSPHAGIA TONGUE DEVIATES FROM ML;GASTROINTESTINAL
	;;DYSPHAGIA WET GURGLY VOICE;GASTROINTESTINAL
	;;ED ASSESS NO RESPONSE;EDUCATION
	;;ELOPEMENT SCREEN NO;PSYCHOSOCIAL
	;;ELOPEMENT SCREEN YES;PSYCHOSOCIAL
	;;FALL HX UNKNOWN INJURY;HX OF FALLING
	;;FALL HX WITH FRACTURE;HX OF FALLING
	;;FALL HX WITH INJURY;HX OF FALLING
	;;FALL HX WITHOUT FRACTURE;HX OF FALLING
	;;FALL HX WITHOUT INJURY;HX OF FALLING
	;;FALL PREVENT-AMB AID ASSESSMENT;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-BEDSIDE TOILETING;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-CLOSER TO RN STATION;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-DIVERSIONAL ACTIVITY;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-ED ON TRIPPING;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-EVAL ORTHOSTASIS;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-EVAL USE PT AMB AID;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-HIP PROTECTORS;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-HT ADJUST BED;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-NURSE RESTORE EVAL;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-OBSERVE Q 1 HOUR;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-OTHER;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PROVIDE CLOCK/CALEND;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PROVIDE ED ON MEDS;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PROVIDE EXIT ALARM;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PROVIDE FLOOR MAT;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PROVIDE HELMET;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PROVIDE TRANS EQUIP;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PT ROUNDS Q 1 HOUR;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PT ROUNDS Q 15 MIN;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PT ROUNDS Q 2 HOURS;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-PT ROUNDS Q 30 MIN;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-RE EDUCATE PT SAFETY;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-REFER TO REHAB;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-REHAB RECOMMENDATION;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-REHAB SELECT AMB AID;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-REHAB TO ASSESS GAIT;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-REINFORCE TRANS HELP;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-REVIEW MED RISKS;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-SAFE AMB DEVICE;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-SAFE EXIT FROM BED;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-SUPPORT MD INSTRUCT;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-SUPPORT PT TOILETING;FALL PREVENTION INTERVENTIONS
	;;FALL PREVENT-WANDERING MONITOR;FALL PREVENTION INTERVENTIONS
	;;FALL UNIVERSAL PRECAUTION YES;FALL PREVENTION INTERVENTIONS
	;;FEELING HOPELESS DECLINES ANSWER;PSYCHOSOCIAL
	;;FEELING HOPELESS NO;PSYCHOSOCIAL
	;;FEELING HOPELESS YES;PSYCHOSOCIAL
	;;FINANCIAL ABUSE REPORTED;PSYCHOSOCIAL
	;;FUNCTIONAL NO RESPONSE;FUNCTIONAL
	;;GENERAL INFO NO RESPONSE;GENERAL INFO
	;;GI ASSESS NO RESPONSE;GASTROINTESTINAL
	;;GU ASSESS NO RESPONSE;GENITOURINARY
	;;HX OF FALLS UNKNOWN;HX OF FALLING
	;;HX OF FALLS WITH FRACTURE;HX OF FALLING
	;;HX OF FALLS WITH INJURY;HX OF FALLING
	;;HX OF FALLS WITHOUT FRACTURE;HX OF FALLING
	;;IC UNDERSTANDING FAIR;INFECT CONTROL
	;;IC UNDERSTANDING GOOD;INFECT CONTROL
	;;IC UNDERSTANDING POOR;INFECT CONTROL
	;;IC UNDERSTANDING REFUSED;INFECT CONTROL
	;;INFECTION CONTROL ED NO;INFECT CONTROL
	;;INFECTION CONTROL ED YES;INFECT CONTROL
	;;INITIAL SKIN ASSESSMENT;SKIN ASSESSMENT
	;;MEDICATIONS-ANALGESICS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-ANTICOAGULANTS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-ANTIDEPRESSANTS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-ANTIDIABETICS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-ANTIHYPERTENSIVES;SECONDARY DIAGNOSIS
	;;MEDICATIONS-DIURETICS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-HYPNOTICS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-MULTIPLE;SECONDARY DIAGNOSIS
	;;MEDICATIONS-OPIOIDS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-OTHER;SECONDARY DIAGNOSIS
	;;MEDICATIONS-PSYCHOTROPICS;SECONDARY DIAGNOSIS
	;;MEDICATIONS-SEDATIVES;SECONDARY DIAGNOSIS
	;;MH ASSESS NO RESPONSE;MENTAL HEALTH
	;;MH CALMING ID-BODY POSITION;MENTAL HEALTH
	;;MH CALMING ID-DISTRACTION;MENTAL HEALTH
	;;MH CALMING ID-EAT;MENTAL HEALTH
	;;MH CALMING ID-EXERCISE/WALK;MENTAL HEALTH
	;;MH CALMING ID-MEDICATIONS;MENTAL HEALTH
	;;MH CALMING ID-MEDITATION;MENTAL HEALTH
	;;MH CALMING ID-MUSIC;MENTAL HEALTH
	;;MH CALMING ID-OTHER;MENTAL HEALTH
	;;MH CALMING ID-PACING;MENTAL HEALTH
	;;MH CALMING ID-PRAYING;MENTAL HEALTH
	;;MH CALMING ID-READ;MENTAL HEALTH
	;;MH CALMING ID-RELAX TECHNIQUES;MENTAL HEALTH
	;;MH CALMING ID-SEEK QUIET PLACE;MENTAL HEALTH
	;;MH CALMING ID-SEXUAL ACTIVITIES;MENTAL HEALTH
	;;MH CALMING ID-SLEEP;MENTAL HEALTH
	;;MH CALMING ID-SMOKING;MENTAL HEALTH
	;;MH CALMING ID-SUBSTANCE USE;MENTAL HEALTH
	;;MH CALMING ID-TALKING W/OTHERS;MENTAL HEALTH
	;;MH CALMING ID-USE HUMOR;MENTAL HEALTH
	;;MH CALMING ID-WATCH TV;MENTAL HEALTH
	;;MH CALMING ID-WRITE IN JOURNAL;MENTAL HEALTH
	;;MH RESTRAINT NTF DECLINES ANSWER;MENTAL HEALTH
	;;MH RESTRAINT NTF NO;MENTAL HEALTH
	;;MH RESTRAINT NTF UNABLE TO ANSWER;MENTAL HEALTH
	;;MH RESTRAINT NTF YES;MENTAL HEALTH
	;;MH TRIGGER DECLINES TO ANSWER;MENTAL HEALTH
	;;MH TRIGGER ID-ARGUMENTS;MENTAL HEALTH
	;;MH TRIGGER ID-BEING HOMELESS;MENTAL HEALTH
	;;MH TRIGGER ID-CANT GET WANTS MET;MENTAL HEALTH
	;;MH TRIGGER ID-CANT PROBLEM SOLVE;MENTAL HEALTH
	;;MH TRIGGER ID-EXCESSIVE NOISE;MENTAL HEALTH
	;;MH TRIGGER ID-HEARING VOICES;MENTAL HEALTH
	;;MH TRIGGER ID-HURT FEELINGS;MENTAL HEALTH
	;;MH TRIGGER ID-LOSS CTRL ETOH/DRUG;MENTAL HEALTH
	;;MH TRIGGER ID-MONETARY ISSUES;MENTAL HEALTH
	;;MH TRIGGER ID-NO POWER;MENTAL HEALTH
	;;MH TRIGGER ID-NOT LISTENED TO;MENTAL HEALTH
	;;MH TRIGGER ID-NOTHING UPSETTING;MENTAL HEALTH
	;;MH TRIGGER ID-OTHER;MENTAL HEALTH
	;;MH TRIGGER ID-PAIN;MENTAL HEALTH
	;;MH TRIGGER ID-PHYSICAL ABUSE;MENTAL HEALTH
	;;MH TRIGGER ID-SEXUAL ABUSE;MENTAL HEALTH
	;;MH TRIGGER ID-SIGNIFICANT LOSSES;MENTAL HEALTH
	;;MH TRIGGER ID-SPACE INVADED;MENTAL HEALTH
	;;MH TRIGGER ID-TREATED UNFAIRLY;MENTAL HEALTH
	;;MH TRIGGER ID-UNJUSTLY BLAMED;MENTAL HEALTH
	;;MH TRIGGER UNABLE TO ANSWER;MENTAL HEALTH
	;;MH UPSET ABLE TO CALM;MENTAL HEALTH
	;;MH UPSET DECLINES TO ANSWER;MENTAL HEALTH
	;;MH UPSET UNABLE TO CALM;MENTAL HEALTH
	;;MORSE FALL SCALE HIGH RISK;MORSE FALL SCALE SCORE
	;;MORSE FALL SCALE LOW RISK;MORSE FALL SCALE SCORE
	;;MORSE FALL SCALE MODERATE RISK;MORSE FALL SCALE SCORE
	;;MRSA INFO NO;MRSA
	;;MRSA INFO YES;MRSA
	;;MRSA SWAB AGREEMENT NO;MRSA
	;;MRSA SWAB AGREEMENT YES;MRSA
	;;MRSA SWAB NO;MRSA
	;;MRSA SWAB YES;MRSA
	;;MS ASSESS NO RESPONSE;MUSCULOSKELETAL
	;;NEGLECT REPORTED;PSYCHOSOCIAL
	;;NEGLECT SUSPECTED;PSYCHOSOCIAL
	;;NEURO ASSESS NO RESPONSE;NEUROLOGICAL
	;;P/S ASSESS NO RESPONSE;PSYCHOSOCIAL
	;;PAIN ACUTE LOC 1;PAIN
	;;PAIN ACUTE LOC 2;PAIN
	;;PAIN ACUTE LOC 3;PAIN
	;;PAIN ACUTE LOC 4;PAIN
	;;PAIN ACUTE LOC 5;PAIN
	;;PAIN BEHAVIORS NONE;PAIN
	;;PAIN BEHAVIORS YES;PAIN
	;;PAIN CHRONIC LOC 1;PAIN
	;;PAIN CHRONIC LOC 2;PAIN
	;;PAIN CHRONIC LOC 3;PAIN
	;;PAIN CHRONIC LOC 4;PAIN
	;;PAIN CHRONIC LOC 5;PAIN
	;;PAIN GOAL ID LOC 1;PAIN
	;;PAIN GOAL ID LOC 2;PAIN
	;;PAIN GOAL ID LOC 3;PAIN
	;;PAIN GOAL ID LOC 4;PAIN
	;;PAIN GOAL ID LOC 5;PAIN
	;;PAIN PROBLEM NO;PAIN
	;;PAIN PROBLEM NO RESPONSE;PAIN
	;;PAIN PROBLEM YES;PAIN
	;;PAIN SEVERITY ID LOC 1;PAIN
	;;PAIN SEVERITY ID LOC 2;PAIN
	;;PAIN SEVERITY ID LOC 3;PAIN
	;;PAIN SEVERITY ID LOC 4;PAIN
	;;PAIN SEVERITY ID LOC 5;PAIN
	;;PERIPH IV #1 DATE DISCONTINUED;VASCULAR ACCESS
	;;PERIPH IV #1 DATE INSERTED;VASCULAR ACCESS
	;;PERIPH IV #2 DATE DISCONTINUED;VASCULAR ACCESS
	;;PERIPH IV #2 DATE INSERTED;VASCULAR ACCESS
	;;PERIPH IV #3 DATE DISCONTINUED;VASCULAR ACCESS
	;;PERIPH IV #3 DATE INSERTED;VASCULAR ACCESS
	;;PERIPH IV #4 DATE DISCONTINUED;VASCULAR ACCESS
	;;PERIPH IV #4 DATE INSERTED;VASCULAR ACCESS
	;;PERIPH IV #5 DATE DISCONTINUED;VASCULAR ACCESS
	;;PERIPH IV #5 DATE INSERTED;VASCULAR ACCESS
	;;PERIPH IV #1 ON ADMISSION;VASCULAR ACCESS
	;;PERIPH IV #2 ON ADMISSION;VASCULAR ACCESS
	;;PERIPH IV #3 ON ADMISSION;VASCULAR ACCESS
	;;PREFERRED LANGUAGE;LANGUAGE
	;;PRESSURE ULCER;SKIN ASSESSMENT
	;;PRIOR SUICIDE ATTEMPT DCLINS ANSR;PSYCHOSOCIAL
	;;PRIOR SUICIDE ATTEMPT NO;PSYCHOSOCIAL
	;;PRIOR SUICIDE ATTEMPT YES;PSYCHOSOCIAL
	;;PU ED-CAUSE/PREVENTION;PRESSURE ULCER-EDUCATION
	;;PU ED-IMP OF CHANGING POSITIONS;PRESSURE ULCER-EDUCATION
	;;PU ED-MATERIAL ON ULCER PREVENT;PRESSURE ULCER-EDUCATION
	;;PU ED-OTHER;PRESSURE ULCER-EDUCATION
	;;PU ED-TX PLAN;PRESSURE ULCER-EDUCATION
	;;RESP ASSESS NO RESPONSE;RESPIRATORY
	;;RESTRAINT DATE/TIME DISCONTINUED;RESTRAINTS
	;;RESTRAINT DATE/TIME INITIATED;RESTRAINTS
	;;RESTRAINT RESTRICTIVE;RESTRAINTS
	;;RESTRAINT SUPPORTIVE;RESTRAINTS
	;;SKIN ASSESS NO RESPONSE;SKIN
	;;SKIN COLOR;SKIN ASSESSMENT
	;;SKIN INTERVENT-ACT AS TOLERATED;SKIN INTERVENTIONS
	;;SKIN INTERVENT-CLEAN DRY SKIN;SKIN INTERVENTIONS
	;;SKIN INTERVENT-CONDOM CATHETER;SKIN INTERVENTIONS
	;;SKIN INTERVENT-ELBOW PADS;SKIN INTERVENTIONS
	;;SKIN INTERVENT-ELEVATE HEELS;SKIN INTERVENTIONS
	;;SKIN INTERVENT-ELEVATE HOB MEALS;SKIN INTERVENTIONS
	;;SKIN INTERVENT-ENCOURAGE MEALS;SKIN INTERVENTIONS
	;;SKIN INTERVENT-FECAL COLLECTOR;SKIN INTERVENTIONS
	;;SKIN INTERVENT-HOB 30 NOT EATING;SKIN INTERVENTIONS
	;;SKIN INTERVENT-HOB ELE/RAISE KNEE;SKIN INTERVENTIONS
	;;SKIN INTERVENT-LIQ Q 2H WHEN TURN;SKIN INTERVENTIONS
	;;SKIN INTERVENT-MONITOR INTAKE;SKIN INTERVENTIONS
	;;SKIN INTERVENT-OFFER BEDPAN/UR;SKIN INTERVENTIONS
	;;SKIN INTERVENT-OFFER SUPPLEMENTS;SKIN INTERVENTIONS
	;;SKIN INTERVENT-ORAL CARE;SKIN INTERVENTIONS
	;;SKIN INTERVENT-OTHER;SKIN INTERVENTIONS
	;;SKIN INTERVENT-POSITION CHANGE;SKIN INTERVENTIONS
	;;SKIN INTERVENT-PROTECT OINTMENT;SKIN INTERVENTIONS
	;;SKIN INTERVENT-ROM;SKIN INTERVENTIONS
	;;SKIN INTERVENT-SIT OOB 2H;SKIN INTERVENTIONS
	;;SKIN INTERVENT-SPECIALTY BED;SKIN INTERVENTIONS
	;;SKIN INTERVENT-TELL PT SEEK HELP;SKIN INTERVENTIONS
	;;SKIN INTERVENT-TOILET SCHEDULE;SKIN INTERVENTIONS
	;;SKIN INTERVENT-TRAPEZE PULL SHEET;SKIN INTERVENTIONS
	;;SKIN INTERVENT-TRAY SET UP;SKIN INTERVENTIONS
	;;SKIN INTERVENT-TURN REPOS Q2H;SKIN INTERVENTIONS
	;;SKIN INTERVENT-WHEELCHAIR CUSHION;SKIN INTERVENTIONS
	;;SKIN MOISTURE;SKIN ASSESSMENT
	;;SKIN PATCHES NO;SKIN ASSESSMENT
	;;SKIN PATCHES YES;SKIN ASSESSMENT
	;;SKIN PROBLEM-ABRASION;SKIN ASSESSMENT
	;;SKIN PROBLEM-BITE;SKIN ASSESSMENT
	;;SKIN PROBLEM-BRUISING;SKIN ASSESSMENT
	;;SKIN PROBLEM-BURN;SKIN ASSESSMENT
	;;SKIN PROBLEM-CRUSH INJURY;SKIN ASSESSMENT
	;;SKIN PROBLEM-LACERATION;SKIN ASSESSMENT
	;;SKIN PROBLEM-NONE;SKIN ASSESSMENT
	;;SKIN PROBLEM-OTHER;SKIN ASSESSMENT
	;;SKIN PROBLEM-PENETRATING;SKIN ASSESSMENT
	;;SKIN PROBLEM-PUNCTURE WOUND;SKIN ASSESSMENT
	;;SKIN PROBLEM-RASH;SKIN ASSESSMENT
	;;SKIN PROBLEM-SURGICAL INCISION;SKIN ASSESSMENT
	;;SKIN PROBLEM-VASCULAR LESION;SKIN ASSESSMENT
	;;SKIN PROBLEM-WOUND;SKIN ASSESSMENT
	;;SKIN PU #1 STAGE I;PRESSURE ULCER
	;;SKIN PU #1 STAGE II;PRESSURE ULCER
	;;SKIN PU #1 STAGE III;PRESSURE ULCER
	;;SKIN PU #1 STAGE IV;PRESSURE ULCER
	;;SKIN PU #1 SUSPECTED DEEP TISSUE;PRESSURE ULCER
	;;SKIN PU #1 UNABLE TO STAGE;PRESSURE ULCER
	;;SKIN PU #2 STAGE I;PRESSURE ULCER
	;;SKIN PU #2 STAGE II;PRESSURE ULCER
	;;SKIN PU #2 STAGE III;PRESSURE ULCER
	;;SKIN PU #2 STAGE IV;PRESSURE ULCER
	;;SKIN PU #2 SUSPECTED DEEP TISSUE;PRESSURE ULCER
	;;SKIN PU #2 UNABLE TO STAGE;PRESSURE ULCER
	;;SKIN PU #3 STAGE I;PRESSURE ULCER
	;;SKIN PU #3 STAGE II;PRESSURE ULCER
	;;SKIN PU #3 STAGE III;PRESSURE ULCER
	;;SKIN PU #3 STAGE IV;PRESSURE ULCER
	;;SKIN PU #3 SUSPECTED DEEP TISSUE;PRESSURE ULCER
	;;SKIN PU #3 UNABLE TO STAGE;PRESSURE ULCER
	;;SKIN PU #4 STAGE I;PRESSURE ULCER
	;;SKIN PU #4 STAGE II;PRESSURE ULCER
	;;SKIN PU #4 STAGE III;PRESSURE ULCER
	;;SKIN PU #4 STAGE IV;PRESSURE ULCER
	;;SKIN PU #4 SUSPECTED DEEP TISSUE;PRESSURE ULCER
	;;SKIN PU #4 UNABLE TO STAGE;PRESSURE ULCER
	;;SKIN PU #5 STAGE I;PRESSURE ULCER
	;;SKIN PU #5 STAGE II;PRESSURE ULCER
	;;SKIN PU #5 STAGE III;PRESSURE ULCER
	;;SKIN PU #5 STAGE IV;PRESSURE ULCER
	;;SKIN PU #5 SUSPECTED DEEP TISSUE;PRESSURE ULCER
	;;SKIN PU #5 UNABLE TO STAGE;PRESSURE ULCER
	;;SKIN RISK-AMPUTEE;SKIN HIGH RISK FACTORS
	;;SKIN RISK-DIABETES;SKIN HIGH RISK FACTORS
	;;SKIN RISK-MULTIPLE SCLEROSIS;SKIN HIGH RISK FACTORS
	;;SKIN RISK-NEUROLOGICAL DISEASE;SKIN HIGH RISK FACTORS
	;;SKIN RISK-PARALYSIS;SKIN HIGH RISK FACTORS
	;;SKIN RISK-PARAPLEGIA;SKIN HIGH RISK FACTORS
