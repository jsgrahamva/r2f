RORP019B	;ALB/KG - CCR COMMON TEMPLATE CODES (PART B) ;5/15/12
	;;1.5;CLINICAL CASE REGISTRIES;**19**;Feb 17, 2006;Build 43
	;
	;******************************************************************************
	;******************************************************************************
	;                       --- ROUTINE MODIFICATION LOG ---
	;        
	;PKG/PATCH    DATE        DEVELOPER    MODIFICATION
	;-----------  ----------  -----------  ----------------------------------------
	;ROR*1.5*19   MAY  2012   K GUPTA      Support for ICD-10 Coding System
	;******************************************************************************
	;******************************************************************************
	;
	Q
TMPLCODE	;
	;;1^ESLD
	;;2^456.0,456.1,456.20,456.21,456.8,572.2,572.3,572.4,572.8
	;;3^I85.00,I85.01,I85.10,I85.11,I86.0,I86.1,I86.2,I86.3,I86.4
	;;3^K76.6,K76.7,K76.81
	;;9
	;;1^Other Depression
	;;2^293.83,296.90,296.99,298.0,300.4,301.12,309.0,309.1,311.
	;;3^F06.30,F06.31,F06.32,F06.34,F33.8,F34.1,F34.8,F34.9,F39.,F43.21,F43.23
	;;9
	;;1^Major Depression
	;;2^296.20,296.21,296.22,296.23,296.24,296.25,296.26,296.30,296.31,296.32
	;;3^F32.0,F32.1,F32.2,F32.3,F32.4,F32.5,F32.9,F33.0,F33.1,F33.2,F33.3,F33.40,F33.41,F33.42,F33.9
	;;9
	;;1^Esophageal Varices
	;;2^456.0,456.1,456.20,456.21
	;;3^I85.00,I85.01,I85.10,I85.11
	;;9
	;;1^HCC
	;;2^155.0
	;;3^C22.0
	;;9
	;;1^HIV+ Codes
	;;2^042.,042.0,042.1,042.2,042.9,043.0,043.1,043.2,043.3,043.9,044.0,044.9,795.8,V08.
	;;3^B20.,B97.35,O98.711,O98.712,O98.713,O98.719,O98.72,O98.73,Z21.
	;;9
	;;1^Hepatitis B
	;;2^070.2,070.20,070.21,070.22,070.23,070.3,070.30,070.31,070.32,070.33,V02.61
	;;3^B16.0,B16.1,B16.2,B16.9,B17.0,B18.0,B18.1,B19.10,B19.11,Z22.51
	;;9
	;;1^Hepatitis C
	;;2^070.44,070.54,070.70,070.71,V02.62
	;;3^B17.10,B17.11,B18.2,B19.20,B19.21,Z22.52
	;;9
	;;1^Hypertension
	;;2^401.0,401.1,401.9,402.00,402.01,402.10,402.11,402.90,402.91,403.0,403.00,403.01,403.1,403.10,403.11,403.9,403.90
	;;2^403.91,404.0,404.00,404.01,404.02,404.03,404.1,404.10,404.11,404.12,404.13,404.9,404.90,404.91,404.92,404.93,405.01
	;;2^405.09,405.91,405.99
	;;3^H35.031,H35.032,H35.033,H35.039,I10.,I11.0,I11.9,I12.0,I12.9,I13.0,I13.10,I13.11,I13.2,I15.0,I15.1,I15.2,I15.8,I15.9
	;;3^I67.4
	;;3^O10.02,O10.03,O10.12,O10.13,O10.22,O10.23,O10.32,O10.33,O10.42,O10.43
	;;3^O10.92,O10.93,O11.1,O11.2,O11.3,O11.9
	;;9
	;;1^Ischemic Heart Disease
	;;2^410.0,410.00,410.01,410.02,410.1,410.10,410.11,410.12,410.2,410.20,410.21,410.22,410.3,410.30,410.31,410.32,410.4
	;;2^410.40,410.41,410.42,410.5,410.50,410.51,410.52,410.6,410.60,410.61,410.62,410.7,410.70,410.71,410.72,410.8
	;;2^410.80,410.81,410.82,410.9,410.90,410.91,410.92,411.0,411.1,411.8,411.81,411.89,412.,413.0,413.1,413.9,414.0
	;;2^414.00,414.01,414.02,414.03,414.04,414.05,414.06,414.07,414.10,414.11,414.12,414.19,414.8,414.9
	;;3^I20.0,I20.1,I20.8,I20.9,I21.01,I21.02,I21.09,I21.11,I21.19,I21.21,I21.29,I21.3,I21.4,I22.0,I22.1,I22.2,I22.8,I22.9
	;;3^I23.0,I23.1,I23.2,I23.3,I23.4,I23.5,I23.6,I23.7,I23.8,I24.0,I24.1,I24.8,I24.9,I25.10,I25.110,I25.111,I25.118,I25.119
	;;3^I25.2,I25.5,I25.6,I25.700,I25.701,I25.708,I25.709,I25.710,I25.711,I25.718,I25.719,I25.720,I25.721,I25.728,I25.729
	;;3^I25.730,I25.731,I25.738,I25.739,I25.750,I25.751,I25.758,I25.759,I25.760,I25.761,I25.768,I25.769,I25.790,I25.791,I25.798
	;;3^I25.799,I25.810,I25.811,I25.812,I25.83,I25.89,I25.9
	;;9
	;;1^Schizophrenia
	;;2^295.00,295.01,295.02,295.03,295.04,295.05,295.10,295.11,295.12,295.13,295.14,295.15,295.20,295.21,295.22,295.23
	;;2^295.24,295.25,295.30,295.31,295.32,295.33,295.34,295.35,295.40,295.41,295.42,295.43,295.44,295.45,295.50,295.51
	;;2^295.52,295.53,295.54,295.55,295.60,295.61,295.62,295.63,295.64,295.65,295.70,295.71,295.72,295.73,295.74,295.75
	;;2^295.80,295.81,295.82,295.83,295.84,295.85,295.90,295.91,295.92,295.93,295.94,295.95
	;;3^F20.0,F20.1,F20.2,F20.3,F20.5,F20.81,F20.89,F20.9,F25.0,F25.1,F25.8,F25.9
	;;9
	;;1^Substance use (non-alcohol)
	;;2^304.00,304.01,304.02,304.03,304.09,304.10,304.11,304.12,304.13,304.14,304.15,304.16,304.17,304.18,304.19,304.20
	;;2^304.21,304.22,304.23,304.30,304.31,304.32,304.33,304.39,304.40,304.41,304.42,304.43,304.49,304.50,304.51,304.52
	;;2^304.53,304.59,304.60,304.61,304.62,304.63,304.70,304.71,304.72,304.73,304.80,304.81,304.82,304.83,304.90,304.91
	;;2^304.92,304.93,304.99,305.20,305.21,305.22,305.23,305.29,305.30,305.31,305.32,305.33,305.39,305.40,305.41,305.42
	;;2^305.43,305.44,305.45,305.46,305.47,305.48,305.49,305.50,305.51,305.52,305.53,305.59,305.6,305.60,305.61,305.62
	;;2^305.63,305.70,305.71,305.72,305.73,305.79,305.80,305.81,305.82,305.83,305.90,305.91,305.92,305.93,305.99
	;;3^F11.10,F11.120,F11.121,F11.122,F11.129,F11.14,F11.150,F11.151,F11.159,F11.181,F11.182,F11.188,F11.19,F11.20,F11.21
	;;3^F11.220,F11.221,F11.222,F11.229,F11.23,F11.24,F11.250,F11.251,F11.259,F11.281,F11.282,F11.288,F11.29,F11.90,F11.920
	;;3^F11.921,F11.922,F11.929,F11.93,F11.94,F11.950,F11.951,F11.959,F11.981,F11.982,F11.988,F11.99,F12.10,F12.120,F12.121
	;;3^F12.122,F12.129,F12.150,F12.151,F12.159,F12.180,F12.188,F12.19,F12.20,F12.21,F12.220,F12.221,F12.222,F12.229,F12.250
	;;3^F12.251,F12.259,F12.280,F12.288,F12.29,F12.90,F12.920,F12.921,F12.922,F12.929,F12.950,F12.951,F12.959,F12.980,F12.988
	;;3^F12.99,F13.10,F13.120,F13.121,F13.129,F13.14,F13.150,F13.151,F13.159,F13.180,F13.181,F13.182,F13.188,F13.19,F13.20
	;;3^F13.21,F13.220,F13.221,F13.229,F13.230,F13.231,F13.232,F13.239,F13.24,F13.250,F13.251,F13.259,F13.26,F13.27,F13.280
	;;3^F13.281,F13.282,F13.288,F13.29,F13.90,F13.920,F13.921,F13.929,F13.930,F13.931,F13.932,F13.939,F13.94,F13.950,F13.951
	;;3^F13.959,F13.96,F13.97,F13.980,F13.981,F13.982,F13.988,F13.99,F14.10,F14.120,F14.121,F14.122,F14.129,F14.14,F14.150
	;;3^F14.151,F14.159,F14.180,F14.181,F14.182,F14.188,F14.19,F14.20,F14.21,F14.220,F14.221,F14.222,F14.229,F14.23,F14.24
	;;3^F14.250,F14.251,F14.259,F14.280,F14.281,F14.282,F14.288,F14.29,F14.90,F14.920,F14.921,F14.922,F14.929,F14.94,F14.950
	;;3^F14.951,F14.959,F14.980,F14.981,F14.982,F14.988,F14.99,F15.10,F15.120,F15.121,F15.122,F15.129,F15.14,F15.150,F15.151
	;;3^F15.159,F15.180,F15.181,F15.182,F15.188,F15.19,F15.20,F15.21,F15.220,F15.221,F15.222,F15.229,F15.23,F15.24,F15.250
	;;3^F15.251,F15.259,F15.280,F15.281,F15.282,F15.288,F15.29,F15.90,F15.920,F15.921,F15.922,F15.929,F15.93,F15.94,F15.950
	;;3^F15.951,F15.959,F15.980,F15.981,F15.982,F15.988,F15.99,F16.10,F16.120,F16.121,F16.122,F16.129,F16.14,F16.150,F16.151
	;;3^F16.159,F16.180,F16.183,F16.188,F16.19,F16.20,F16.21,F16.220,F16.221,F16.229,F16.24,F16.250,F16.251,F16.259,F16.280
	;;3^F16.283,F16.288,F16.29,F16.90,F16.920,F16.921,F16.929,F16.94,F16.950,F16.951,F16.959,F16.980,F16.983,F16.988,F16.99
	;;3^F18.10,F18.120,F18.121,F18.129,F18.14,F18.150,F18.151,F18.159,F18.17
	;;3^F18.180,F18.188,F18.19,F18.20,F18.21,F18.220,F18.221,F18.229,F18.24,F18.250,F18.251,F18.259,F18.27,F18.280,F18.288
	;;3^F18.29,F18.90,F18.920,F18.921,F18.929,F18.94,F18.950,F18.951,F18.959,F18.97,F18.980,F18.988,F18.99,F19.10,F19.120
	;;3^F19.121,F19.122,F19.129,F19.14,F19.150,F19.151,F19.159,F19.16,F19.17,F19.180,F19.181,F19.182,F19.188,F19.19,F19.20
	;;3^F19.21,F19.220,F19.221,F19.222,F19.229,F19.230,F19.231,F19.232,F19.239,F19.24,F19.250,F19.251,F19.259,F19.26,F19.27
	;;3^F19.280,F19.281,F19.282,F19.288,F19.29,F19.90,F19.920,F19.921,F19.922,F19.929,F19.930,F19.931,F19.932,F19.939,F19.94
	;;3^F19.950,F19.951,F19.959,F19.96,F19.97,F19.980,F19.981,F19.982,F19.988,F19.99,F55.0,F55.1,F55.2,F55.3,F55.4,F55.8
	;;9
	;;1^Tobacco Use
	;;2^305.1,989.84,V15.82
	;;3^F17.200,F17.201,F17.203,F17.208,F17.209,F17.210,F17.211,F17.213,F17.218,F17.219,F17.220,F17.221,F17.223,F17.228,F17.229
	;;3^F17.290,F17.291,F17.293,F17.298,F17.299,O99.330,O99.331,O99.332,O99.333,O99.334,O99.335,T65.211A,T65.211D,T65.211S
	;;3^T65.212A,T65.212D,T65.212S,T65.213A,T65.213D,T65.213S,T65.214A,T65.214D,T65.214S,T65.221A,T65.221D,T65.221S,T65.222A
	;;3^T65.222D,T65.222S,T65.223A,T65.223D,T65.223S,T65.224A,T65.224D,T65.224S,T65.291A,T65.291D,T65.291S,T65.292A,T65.292D
	;;3^T65.292S,T65.293A,T65.293D,T65.293S,T65.294A,T65.294D,T65.294S,Z72.0,Z87.891
	;;9
	;;1^PTSD
	;;2^309.81
	;;3^F43.10,F43.11,F43.12
	;;9
	;;