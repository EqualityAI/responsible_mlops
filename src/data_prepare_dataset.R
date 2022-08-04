#===============================================================================
# DATA PREPARATION RECIPES (Sample Datasets)
#===============================================================================
data_prepare_nhamcs <- function(data_input, target_var, method_options) {
  if((method_options$method_prepare =='Zhang') | (method_options$method_prepare =='Raita')) {
    # Generate hospiatal admission (target variable) variable based on multiple attributes available in the data_inputset
    data_input$HOS=NA
    data_input$HOS[data_input$TRANPSYC==1 | data_input$TRANOTH==1 | data_input$ADMITHOS==1 | data_input$OBSHOS==1] <- 1
    data_input$HOS[is.na(data_input$HOS)] <- 0
    
    # Missing or unknown or blank values for each variables
    data_input$IMMEDR[data_input$IMMEDR == -9|data_input$IMMEDR == -8 |data_input$IMMEDR == 0|data_input$IMMEDR == 7 ]<- ''
    data_input$SEEN72[data_input$SEEN72==-8 | data_input$SEEN72==-9 | data_input$SEEN72==0 |data_input$SEEN72==3]<-''
    data_input$ARREMS[data_input$ARREMS==-8 | data_input$ARREMS==-9]<-''
    data_input$RESIDNCE[data_input$RESIDNCE==-8 | data_input$RESIDNCE==-9]<-''
    data_input$PAYTYPER[data_input$PAYTYPER==-8 | data_input$PAYTYPER==-9]<-''
    data_input$TEMPF[data_input$TEMPF==-8 | data_input$TEMPF==-9]<-''
    data_input$RESPR[data_input$RESPR==-9]<-''
    data_input$PULSE[data_input$PULSE==-8 | data_input$PULSE==998|data_input$PULSE==-9]<-''
    data_input$BPDIAS[data_input$BPDIAS==-8 | data_input$BPDIAS==998|data_input$BPDIAS==-9]<-''
    data_input$BPSYS[data_input$BPSYS==-8 | data_input$BPSYS==998| data_input$BPSYS==-9]<-''
    data_input$POPCT[data_input$POPCT==-8 | data_input$POPCT==-9]<-''
    data_input$INJPOISAD[data_input$INJPOISAD==-8 | data_input$INJPOISAD==-9]<-''
    data_input$EPISODE[data_input$EPISODE==-8 | data_input$EPISODE==-9]<-''
    data_input$PAINSCALE[data_input$PAINSCALE==-8 | data_input$PAINSCALE==-9]<-''
    data_input$ARRTIME[data_input$ARRTIME==-8 | data_input$ARRTIME==-9]<-''
    
    # 500 means 5 am, 1700 means 5 pm
    # converting arrival time range into different categories
    data_input$ARRTIME<-as.numeric(data_input$ARRTIME)
    data_input$ARRTIME[data_input$ARRTIME<=2400&data_input$ARRTIME>2000]<-0
    data_input$ARRTIME[data_input$ARRTIME<=500&data_input$ARRTIME>0]<-0
    data_input$ARRTIME[data_input$ARRTIME<=1200 &data_input$ARRTIME>500]<-1
    data_input$ARRTIME[data_input$ARRTIME<=1700&data_input$ARRTIME>1200]<-2
    data_input$ARRTIME[data_input$ARRTIME<=2000&data_input$ARRTIME>1700]<-3
    
    if(method_options$method_prepare == 'Zhang'){
      data_input <- data_input[,c('HOS','YEAR','VMONTH', 'VDAYR', 'ARRTIME', 'AGE', 'SEX', 'RESIDNCE',
                                  'PAYTYPER', 'RACERETH','ARREMS', 'TEMPF', 'PULSE',
                                  'RESPR', 'BPSYS', 'BPDIAS', 'POPCT', 'PAINSCALE', 'SEEN72','EPISODE',
                                  'INJPOISAD', 'ETOHAB',	'ALZHD',	'ASTHMA',	'CANCER',	'CEBVD',
                                  'CKD',	'COPD', 'CHF','CAD', 'DEPRN',	'DIABTYP1',
                                  'DIABTYP2',	'DIABTYP0',	'ESRD',	'HPE',	'EDHIV',	'HYPLIPID',
                                  'HTN',	'OBESITY',	'OSA',	'OSTPRSIS',	'SUBSTAB', 'IMMEDR')]
      
      # transform category and binary variables into factors
      factor_var <- c('YEAR','VMONTH', 'VDAYR', 'ARRTIME', 'SEX', 'RESIDNCE',
                      'PAYTYPER', 'RACERETH','ARREMS', 'PAINSCALE', 'SEEN72','EPISODE',
                      'INJPOISAD', 'ETOHAB',	'ALZHD',	'ASTHMA',	'CANCER',	'CEBVD',
                      'CKD',	'COPD', 'CHF','CAD', 'DEPRN',	'DIABTYP1',
                      'DIABTYP2',	'DIABTYP0',	'ESRD',	'HPE',	'EDHIV',	'HYPLIPID',
                      'HTN',	'OBESITY',	'OSA',	'OSTPRSIS',	'SUBSTAB', 'IMMEDR')
      data_input[,factor_var] <- lapply(data_input[,factor_var] , factor)
      
      num_var <- c('AGE', 'TEMPF', 'PULSE','RESPR', 'BPSYS', 'BPDIAS', 'POPCT')
      data_input[,num_var] <- sapply(data_input[,num_var] , as.numeric)
    }
    else if(method_options$method_prepare == 'Raita'){
      data_input$brfv1<-data_input$RFV1/10 #generate a new variable on the reason to visit 1
      data_input$brfv11<-''
      data_input$brfv11[	1001	<=	data_input$brfv1  &	data_input$brfv1<=	1099	 ]<-	1
      data_input$brfv11[	1100	<=	data_input$brfv1  &	data_input$brfv1<=	1199	 ]<-	2
      data_input$brfv11[	1200	<=	data_input$brfv1  &	data_input$brfv1<=	1259	 ]<-	3
      data_input$brfv11[	1260	<=	data_input$brfv1  &	data_input$brfv1<=	1299	 ]<-	4
      data_input$brfv11[	1300	<=	data_input$brfv1  &	data_input$brfv1<=	1399	 ]<-	5
      data_input$brfv11[	1400	<=	data_input$brfv1  &	data_input$brfv1<=	1499	 ]<-	6
      data_input$brfv11[	1500	<=	data_input$brfv1  &	data_input$brfv1<=	1639	 ]<-	7
      data_input$brfv11[	1640	<=	data_input$brfv1  &	data_input$brfv1<=	1829	 ]<-	8
      data_input$brfv11[	1830	<=	data_input$brfv1  &	data_input$brfv1<=	1899	 ]<-	9
      data_input$brfv11[	1900	<=	data_input$brfv1  &	data_input$brfv1<=	1999	 ]<-	10
      data_input$brfv11[	2001	<=	data_input$brfv1  &	data_input$brfv1<=	2099	 ]<-	11
      data_input$brfv11[	2100	<=	data_input$brfv1  &	data_input$brfv1<=	2199	 ]<-	12
      data_input$brfv11[	2200	<=	data_input$brfv1  &	data_input$brfv1<=	2249	 ]<-	13
      data_input$brfv11[	2250	<=	data_input$brfv1  &	data_input$brfv1<=	2299	 ]<-	14
      data_input$brfv11[	2300	<=	data_input$brfv1  &	data_input$brfv1<=	2349	 ]<-	15
      data_input$brfv11[	2350	<=	data_input$brfv1  &	data_input$brfv1<=	2399	 ]<-	16
      data_input$brfv11[	2400	<=	data_input$brfv1  &	data_input$brfv1<=	2449	 ]<-	17
      data_input$brfv11[	2450	<=	data_input$brfv1  &	data_input$brfv1<=	2499	 ]<-	18
      data_input$brfv11[	2500	<=	data_input$brfv1  &	data_input$brfv1<=	2599	 ]<-	19
      data_input$brfv11[	2600	<=	data_input$brfv1  &	data_input$brfv1<=	2649	 ]<-	20
      data_input$brfv11[	2650	<=	data_input$brfv1  &	data_input$brfv1<=	2699	 ]<-	21
      data_input$brfv11[	2700	<=	data_input$brfv1  &	data_input$brfv1<=	2799	 ]<-	22
      data_input$brfv11[	2800	<=	data_input$brfv1  &	data_input$brfv1<=	2899	 ]<-	23
      data_input$brfv11[	2900	<=	data_input$brfv1  &	data_input$brfv1<=	2949	 ]<-	24
      data_input$brfv11[	2950	<=	data_input$brfv1  &	data_input$brfv1<=	2979	 ]<-	25
      data_input$brfv11[	2980	<=	data_input$brfv1  &	data_input$brfv1<=	2999	 ]<-	26
      data_input$brfv11[	3100	<=	data_input$brfv1  &	data_input$brfv1<=	3199	 ]<-	27
      data_input$brfv11[	3200	<=	data_input$brfv1  &	data_input$brfv1<=	3299	 ]<-	28
      data_input$brfv11[	3300	<=	data_input$brfv1  &	data_input$brfv1<=	3399	 ]<-	29
      data_input$brfv11[	3400	<=	data_input$brfv1  &	data_input$brfv1<=	3499	 ]<-	30
      data_input$brfv11[	3500	<=	data_input$brfv1  &	data_input$brfv1<=	3599	 ]<-	31
      data_input$brfv11[	4100	<=	data_input$brfv1  &	data_input$brfv1<=	4199	 ]<-	32
      data_input$brfv11[	4200	<=	data_input$brfv1  &	data_input$brfv1<=	4299	 ]<-	33
      data_input$brfv11[	4400	<=	data_input$brfv1  &	data_input$brfv1<=	4499	 ]<-	34
      data_input$brfv11[	4500	<=	data_input$brfv1  &	data_input$brfv1<=	4599	 ]<-	35
      data_input$brfv11[	4600	<=	data_input$brfv1  &	data_input$brfv1<=	4699	 ]<-	36
      data_input$brfv11[	4700	<=	data_input$brfv1  &	data_input$brfv1<=	4799	 ]<-	37
      data_input$brfv11[	4800	<=	data_input$brfv1  &	data_input$brfv1<=	4899	 ]<-	38
      data_input$brfv11[	5001	<=	data_input$brfv1  &	data_input$brfv1<=	5799	 ]<-	39
      data_input$brfv11[	5800	<=	data_input$brfv1  &	data_input$brfv1<=	5899	 ]<-	40
      data_input$brfv11[	5900	<=	data_input$brfv1  &	data_input$brfv1<=	5999	 ]<-	41
      data_input$brfv11[	6100	<=	data_input$brfv1  &	data_input$brfv1<=	6700	 ]<-	42
      data_input$brfv11[	7100	<=	data_input$brfv1  &	data_input$brfv1<=	7140	 ]<-	43
      data_input$brfv11[	8990	<=	data_input$brfv1  &	data_input$brfv1<=	8999	 ]<-	44
      
      data_input <-data_input[,c('HOS','AGE', 'SEX', 'RESIDNCE','RACERETH','ARREMS', 'TEMPF', 'PULSE',
                                 'RESPR', 'BPSYS', 'BPDIAS', 'POPCT',
                                 'ETOHAB',	'ALZHD',	'ASTHMA',	'CANCER',	'CEBVD',
                                 'CKD',	'COPD', 'CHF','CAD', 'DEPRN',	'DIABTYP1',
                                 'DIABTYP2',	'DIABTYP0',	'ESRD',	'HPE',	'EDHIV',	'HYPLIPID',
                                 'HTN',	'OBESITY',	'OSA',	'OSTPRSIS',	'SUBSTAB', 'IMMEDR')]
      
      factor_var <- c('SEX', 'RESIDNCE','RACERETH','ARREMS',
                      'ETOHAB',	'ALZHD',	'ASTHMA',	'CANCER',	'CEBVD',
                      'CKD',	'COPD', 'CHF','CAD', 'DEPRN',	'DIABTYP1',
                      'DIABTYP2',	'DIABTYP0',	'ESRD',	'HPE',	'EDHIV',	'HYPLIPID',
                      'HTN',	'OBESITY',	'OSA',	'OSTPRSIS',	'SUBSTAB', 'IMMEDR')
      data_input[,factor_var] <- lapply(data_input[,factor_var] , factor)
      
      num_var <- c('AGE', 'TEMPF', 'PULSE','RESPR', 'BPSYS', 'BPDIAS', 'POPCT')
      data_input[,num_var] <- sapply(data_input[,num_var] , as.numeric)
      
    }
    data_input<-subset(data_input,data_input$AGE>=18)
    # Missing value imputation
    data_input[data_input == "" | data_input == " "] <- NA
    if(method_options$method_missing == 'complete_case'){
      data_input<-data_prep_missing_values(data_input, method_missing=method_options$method_missing)
    }
    else if(method_options$method_missing == 'mi_impute'){
      param_missing = list("max_iter_mi"=method_options$max_iter)
      data_input<-data_prep_missing_values(data_input, method_missing=method_options$method_missing, param_missing=param_missing)
    }
    else if(method_options$method_missing == 'rf_impute'){
      param_missing = list("max_iter_rf"=method_options$max_iter)
      data_input<-data_prep_missing_values(data_input, method_missing=method_options$method_missing, param_missing=param_missing)
    }
    # Using only black and white race "RACERETH"
    # Note: RACERETH -->(1:White, 2:Black, 3:Hispanic, 4:Other)
    data_input<-subset(data_input,data_input$RACERETH==1 | data_input$RACERETH==2)
    rownames(data_input) <- NULL
    # Data Types
    #data_input[[target_var]] <- as.numeric(data_input[[target_var]])
    data_input <- data.frame(sapply(data_input, as.numeric ))
    
    #data_input$YEAR = as.factor(data_input$YEAR)
    data_input <- data_input[colnames(data_input) != "YEAR"]
    
    data_ = list("data" = data_input)
    return(data_)
  }
}
