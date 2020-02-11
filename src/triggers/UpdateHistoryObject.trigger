trigger UpdateHistoryObject on Needs_Assesment__c(after update,before update,before insert,after insert)
{
    
    NeedAssessmentHistoryController ctrl = new NeedAssessmentHistoryController();
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        for (Needs_Assesment__c newobj : Trigger.new)
        {
            Needs_Assesment__c oldobj = Trigger.oldMap.get(newobj.Id);
            if (!string.isEmpty(newobj.Home_Improvement__c) && newobj.Home_Improvement__c != oldobj.Home_Improvement__c)
            {
                newobj.LEOM_Home_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Home_Improvement_Timeframe__c) && newobj.Home_Improvement_Timeframe__c != oldobj.Home_Improvement_Timeframe__c)
            {
                newobj.LEOM_Home_Update__c = system.today();
                
            }
            if (!string.isEmpty(newobj.Home_Improvement_Plan__c) && newobj.Home_Improvement_Plan__c != oldobj.Home_Improvement_Plan__c)
            {
                
                newobj.LEOM_Home_Update__c = system.today();
            }
            
            
            if (!string.isEmpty(newobj.College__c) && newobj.College__c != oldobj.College__c)
            {
                
                newobj.LEOM_College_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.College_Timeframe__c) && newobj.College_Timeframe__c != oldobj.College_Timeframe__c)
            {
                newobj.LEOM_College_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.College_Plan__c) && newobj.College_Plan__c != oldobj.College_Plan__c)
            {
                newobj.LEOM_College_Update__c = system.today();
            }
            
            if (!string.isEmpty(newobj.Medical__c) && newobj.Medical__c != oldobj.Medical__c)
            {
                newobj.LEOM_Medical_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Medical_Timeframe__c) && newobj.Medical_Timeframe__c != oldobj.Medical_Timeframe__c)
            {
                newobj.LEOM_Medical_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Medical_Plan__c) && newobj.Medical_Plan__c != oldobj.Medical_Plan__c)
            {
                newobj.LEOM_Medical_Update__c = system.today();
            }
            
            if (!string.isEmpty(newobj.Purchase_RV_Boat__c) && newobj.Purchase_RV_Boat__c != oldobj.Purchase_RV_Boat__c)
            {
                newobj.LEOM_RV_Boat_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Purchase_RV_Boat_Timeframe__c) && newobj.Purchase_RV_Boat_Timeframe__c != oldobj.Purchase_RV_Boat_Timeframe__c)
            {
                newobj.LEOM_RV_Boat_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Purchase_RV_Boat_Plan__c) && newobj.Purchase_RV_Boat_Plan__c != oldobj.Purchase_RV_Boat_Plan__c)
            {
                newobj.LEOM_RV_Boat_Update__c = system.today();
            }
            
            if (!string.isEmpty(newobj.Retirement_Plan__c) && newobj.Retirement_Plan__c != oldobj.Retirement_Plan__c)
            {
                newobj.LEOM_Retirement_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Retirement_Timeframe__c) && newobj.Retirement_Timeframe__c != oldobj.Retirement_Timeframe__c)
            {
                newobj.LEOM_Retirement_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Retirement_New__c) && newobj.Retirement_New__c != oldobj.Retirement__c)
            {
                newobj.LEOM_Retirement_Update__c = system.today();
            }
            
            
            if (!string.isEmpty(newobj.Travel__c) && newobj.Travel__c != oldobj.Travel__c)
            {
                newobj.LEOM_Travel_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Travel_Plan__c) && newobj.Travel_Plan__c != oldobj.Travel_Plan__c)
            {
                newobj.LEOM_Travel_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Travel_Timeframe__c) && newobj.Travel_Timeframe__c != oldobj.Travel_Timeframe__c)
            {
                newobj.LEOM_Travel_Update__c = system.today();
            }
            
            if (!string.isEmpty(newobj.Life_Events__c) && newobj.Life_Events__c != oldobj.Life_Events__c)
            {
                newobj.LEOM_Life_Events_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Life_Events_Timeframe__c) && newobj.Life_Events_Timeframe__c != oldobj.Life_Events_Timeframe__c)
            {
                newobj.LEOM_Life_Events_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Life_Events_Plan__c) && newobj.Life_Events_Plan__c != oldobj.Life_Events_Plan__c)
            {
                newobj.LEOM_Life_Events_Update__c = system.today();
            }
            
            
            
            if (!string.isEmpty(newobj.Other__c) && newobj.Other__c != oldobj.Other__c)
            {
                newobj.LEOM_Other_Expenses_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Other_Timeframe__c) && newobj.Other_Timeframe__c != oldobj.Other_Timeframe__c)
            {
                newobj.LEOM_Other_Expenses_Update__c = system.today();
            }
            if (!string.isEmpty(newobj.Other_Plan__c) && newobj.Other_Plan__c != oldobj.Other_Plan__c)
            {
                newobj.LEOM_Other_Expenses_Update__c = system.today();
            }
            
            
            // Check for updates recomendation
            
            if (newobj.REC_LECF_1__c == false   && oldobj.REC_LECF_1__c == true  )
            {
                newobj.REC_LECF_Outcome_1__c= null;
            }
            if (newobj.REC_LECF_2__c  == false   && oldobj.REC_LECF_2__c  == true  )
            {
                newobj.REC_LECF_Outcome_2__c= null;
            }
            if (newobj.REC_LECF_3__c  == false   && oldobj.REC_LECF_3__c  == true  )
            {
                newobj.REC_LECF_Outcome_3__c= null;
            }
            if (newobj.REC_LECF_4__c == false   && oldobj.REC_LECF_4__c == true  )
            {
                newobj.REC_LECF_Outcome_4__c= null;
            }
            if (newobj.Rec_LEOM_1__c == false   && oldobj.Rec_LEOM_1__c == true  )
            {
                newobj.Rec_LEOM_Outcome_1__c= null;
            }
            if (newobj.Rec_LEOM_2__c  == false   && oldobj.Rec_LEOM_2__c  == true  )
            {
                newobj.Rec_LEOM_Outcome_2__c= null;
            }
            if (newobj.REC_LEEM_2__c == false   && oldobj.REC_LEEM_2__c == true  )
            {
                newobj.Rec_LEEM_Outcome_2__c= null;
            }
            
            
            if (newobj.Rec_LEOM_3__c == false   && oldobj.Rec_LEOM_3__c == true  )
            {
                newobj.Rec_LEOM_Outcome_3__c= null;
            }
            if (newobj.Rec_LEOM_4__c == false   && oldobj.Rec_LEOM_4__c == true  )
            {
                newobj.Rec_LEOM_Outcome_4__c= null;
            }
            if (newobj.Rec_LEOM_5__c == false   && oldobj.Rec_LEOM_5__c == true  )
            {
                newobj.Rec_LEOM_Outcome_5__c= null;
            }
            if (newobj.Rec_LEOL_1__c == false   && oldobj.Rec_LEOL_1__c == true  )
            {
                newobj.Rec_LEOL_Outcome_1__c= null;
            }
            if (newobj.Rec_LEOL_2__c == false   && oldobj.Rec_LEOL_2__c == true  )
            {
                newobj.Rec_LEOL_Outcome_2__c= null;
            }
            if (newobj.REC_LEAV_1__c == false   && oldobj.REC_LEAV_1__c == true  )
            {
                newobj.REC_LEAV_Outcome_1__c= null;
            }
            
            if (newobj.Rec_LEHS_2__c == false   && oldobj.Rec_LEHS_2__c == true  )
            {
                newobj.Rec_LEHS_Outcome_2__c= null;
            }
            if (newobj.Rec_LEHS_1__c  == false   && oldobj.Rec_LEHS_1__c  == true  )
            {
                newobj.Rec_LEHS_1_Outcome__c= null;
            }
            if (newobj.REC_LEMD_3__c == false   && oldobj.REC_LEMD_3__c == true  )
            {
                newobj.REC_LEMD_Outcome_3__c= null;
            }
            if (newobj.REC_LEMD_2__c == false   && oldobj.REC_LEMD_2__c == true  )
            {
                newobj.REC_LEMD_Outcome_2__c= null;
            }
            if (newobj.REC_LEMD_1__c == false   && oldobj.REC_LEMD_1__c == true  )
            {
                newobj.REC_LEMD_Outcome_1__c= null;
            }
            if (newobj.REC_LEMP_1__c == false   && oldobj.REC_LEMP_1__c == true  )
            {
                newobj.REC_LEMP_Outcome_1__c= null;
            }
            if (newobj.REC_LEMP_2__c == false   && oldobj.REC_LEMP_2__c == true  )
            {
                newobj.REC_LEMP_Outcome_2__c= null;
            }
            if (newobj.REC_LEMP_3__c == false   && oldobj.REC_LEMP_3__c == true  )
            {
                newobj.REC_LEMP_Outcome_3__c= null;
            }
            if (newobj.REC_LEMP_4__c == false   && oldobj.REC_LEMP_4__c == true  )
            {
                newobj.REC_LEMP_Outcome_4__c= null;
            }
            if (newobj.REC_LEMP_5__c == false   && oldobj.REC_LEMP_5__c == true  )
            {
                newobj.REC_LEMP_Outcome_5__c= null;
            }
            if (newobj.REC_LEMP_6__c == false   && oldobj.REC_LEMP_6__c == true  )
            {
                newobj.REC_LEMP_Outcome_6__c= null;
            }
            if (newobj.REC_LEMP_7__c == false   && oldobj.REC_LEMP_7__c == true  )
            {
                newobj.REC_LEMP_Outcome_7__c= null;
            }
            if (newobj.REC_LEMP_8__c == false   && oldobj.REC_LEMP_8__c == true  )
            {
                newobj.REC_LEMP_Outcome_8__c= null;
            }
            if (newobj.REC_LEPT_1__c == false   && oldobj.REC_LEPT_1__c == true  )
            {
                newobj.REC_LEPT_Outcome_1__c= null;
            }
            if (newobj.REC_LEEM_1__c == false   && oldobj.REC_LEEM_1__c == true  )
            {
                newobj.Rec_LEEM_Outcome_1__c= null;
            }
            if (newobj.Rec_LEMQ_1__c == false   && oldobj.Rec_LEMQ_1__c == true  )
            {
                newobj.REC_LEMQ_Outcome_1__c= null;
            }
            
            
        }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        for (Needs_Assesment__c newobj : Trigger.new)
        {
            if (newObj.Id == null)
            {
                return;
            }
            Needs_Assesment__c oldobj = Trigger.oldMap.get(newobj.Id);
            
            system.debug('' + oldobj);
            system.debug('' + newobj);
            
            //Milestone fields
            if (!string.isEmpty(newobj.Home_Improvement__c) && newobj.Home_Improvement__c != oldobj.Home_Improvement__c)
            {
                
                ctrl.InsertDataHistoryTable(newobj.Home_Improvement__c, oldobj.Home_Improvement__c, 'Home_Improvement__c', '' + newobj.Id);
                
            }
            if (!string.isEmpty(newobj.Home_Improvement_Timeframe__c) && newobj.Home_Improvement_Timeframe__c != oldobj.Home_Improvement_Timeframe__c)
            {
                
                ctrl.InsertDataHistoryTable(newobj.Home_Improvement_Timeframe__c, oldobj.Home_Improvement_Timeframe__c, 'Home_Improvement_Timeframe__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Home_Improvement_Plan__c) && newobj.Home_Improvement_Plan__c != oldobj.Home_Improvement_Plan__c)
            {
                
                ctrl.InsertDataHistoryTable(newobj.Home_Improvement_Plan__c, oldobj.Home_Improvement_Plan__c, 'Home_Improvement_Plan__c', '' + newobj.Id);
            }
            
            
            if (!string.isEmpty(newobj.College__c) && newobj.College__c != oldobj.College__c)
            {
                ctrl.InsertDataHistoryTable(newobj.College__c, oldobj.College__c, 'College__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.College_Timeframe__c) && newobj.College_Timeframe__c != oldobj.College_Timeframe__c)
            {
                ctrl.InsertDataHistoryTable(newobj.College_Timeframe__c, oldobj.College_Timeframe__c, 'College_Timeframe__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.College_Plan__c) && newobj.College_Plan__c != oldobj.College_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.College_Plan__c, oldobj.College_Plan__c, 'College_Plan__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.Medical__c) && newobj.Medical__c != oldobj.Medical__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Medical__c, oldobj.Medical__c, 'Medical__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Medical_Timeframe__c) && newobj.Medical_Timeframe__c != oldobj.Medical_Timeframe__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Medical_Timeframe__c, oldobj.Medical_Timeframe__c, 'Medical_Timeframe__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Medical_Plan__c) && newobj.Medical_Plan__c != oldobj.Medical_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Medical_Plan__c, oldobj.Medical_Plan__c, 'Medical_Plan__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.Purchase_RV_Boat__c) && newobj.Purchase_RV_Boat__c != oldobj.Purchase_RV_Boat__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Purchase_RV_Boat__c, oldobj.Purchase_RV_Boat__c, 'Purchase_RV_Boat__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Purchase_RV_Boat_Timeframe__c) && newobj.Purchase_RV_Boat_Timeframe__c != oldobj.Purchase_RV_Boat_Timeframe__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Purchase_RV_Boat_Timeframe__c, oldobj.Purchase_RV_Boat_Timeframe__c, 'Purchase_RV_Boat_Timeframe__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Purchase_RV_Boat_Plan__c) && newobj.Purchase_RV_Boat_Plan__c != oldobj.Purchase_RV_Boat_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Purchase_RV_Boat_Plan__c, oldobj.Purchase_RV_Boat_Plan__c, 'Purchase_RV_Boat_Plan__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.Retirement_Plan__c) && newobj.Retirement_Plan__c != oldobj.Retirement_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Retirement_Plan__c, oldobj.Retirement_Plan__c, 'Retirement_Plan__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Retirement_Timeframe__c) && newobj.Purchase_RV_Boat_Timeframe__c != oldobj.Retirement_Timeframe__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Retirement_Timeframe__c, oldobj.Retirement_Timeframe__c, 'Retirement_Timeframe__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Retirement__c) && newobj.Purchase_RV_Boat_Plan__c != oldobj.Retirement__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Retirement__c, oldobj.Retirement__c, 'Retirement__c', '' + newobj.Id);
            }
            
            
            if (!string.isEmpty(newobj.Travel__c) && newobj.Travel__c != oldobj.Travel__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Travel__c, oldobj.Travel__c, 'Travel__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Travel_Plan__c) && newobj.Travel_Plan__c != oldobj.Travel_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Travel_Plan__c, oldobj.Travel_Plan__c, 'Travel_Plan__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Travel_Timeframe__c) && newobj.Travel_Timeframe__c != oldobj.Travel_Timeframe__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Travel_Timeframe__c, oldobj.Travel_Timeframe__c, 'Travel_Timeframe__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.Life_Events__c) && newobj.Life_Events__c != oldobj.Life_Events__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Life_Events__c, oldobj.Life_Events__c, 'Life_Events__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Life_Events_Timeframe__c) && newobj.Life_Events_Timeframe__c != oldobj.Life_Events_Timeframe__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Life_Events_Timeframe__c, oldobj.Life_Events_Timeframe__c, 'Life_Events_Timeframe__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Life_Events_Plan__c) && newobj.Life_Events_Plan__c != oldobj.Life_Events_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Life_Events_Plan__c, oldobj.Life_Events_Plan__c, 'Life_Events_Plan__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.LEOM_Comments__c) && newobj.LEOM_Comments__c != oldobj.LEOM_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEOM_Comments__c, oldobj.LEOM_Comments__c, 'LEOM_Comments__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.LEOM_PlanUnforeseen__c) && newobj.LEOM_PlanUnforeseen__c != oldobj.LEOM_PlanUnforeseen__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEOM_PlanUnforeseen__c, oldobj.LEOM_PlanUnforeseen__c, 'LEOM_PlanUnforeseen__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.Life_Events_Plan__c) && newobj.Life_Events_Plan__c != oldobj.Life_Events_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Life_Events_Plan__c, oldobj.Life_Events_Plan__c, 'Life_Events_Plan__c', '' + newobj.Id);
            }
            
            
            
            if (!string.isEmpty(newobj.Other__c) && newobj.Other__c != oldobj.Other__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Other__c, oldobj.Other__c, 'Other__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Other_Timeframe__c) && newobj.Other_Timeframe__c != oldobj.Other_Timeframe__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Other_Timeframe__c, oldobj.Other_Timeframe__c, 'Other_Timeframe__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.Other_Plan__c) && newobj.Other_Plan__c != oldobj.Other_Plan__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Other_Plan__c, oldobj.Other_Plan__c, 'Other_Plan__c', '' + newobj.Id);
            }
            
            
            
            //Housig
            if (!string.isEmpty(newobj.Do_you_Rent_or_Own__c) && newobj.Do_you_Rent_or_Own__c != oldobj.Do_you_Rent_or_Own__c)
            {
                ctrl.InsertDataHistoryTable(newobj.Do_you_Rent_or_Own__c, oldobj.Do_you_Rent_or_Own__c, 'Do_you_Rent_or_Own__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEHS_Current_Lender__c) && newobj.LEHS_Current_Lender__c != oldobj.LEHS_Current_Lender__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEHS_Current_Lender__c, oldobj.LEHS_Current_Lender__c, 'LEHS_Current_Lender__c', '' + newobj.Id);
            }
            if (newobj.LEHS_Rate__c != null && newobj.LEHS_Rate__c != oldobj.LEHS_Rate__c)
            {
                ctrl.InsertDataHistoryTable(string.valueof(newobj.LEHS_Rate__c), string.valueof(oldobj.LEHS_Rate__c), 'LEHS_Rate__c', '' + newobj.Id);
            }
            if (newobj.LEHS_Current_Balance__c != null && newobj.LEHS_Current_Balance__c != oldobj.LEHS_Current_Balance__c)
            {
                ctrl.InsertDataHistoryTable(string.valueof(newobj.LEHS_Current_Balance__c), string.valueof(oldobj.LEHS_Current_Balance__c), 'LEHS_Current_Balance__c', '' + newobj.Id);
            }
            if (newobj.LEHS_End_Year__c != null && newobj.LEHS_End_Year__c != oldobj.LEHS_End_Year__c)
            {
                string enddate_old = '';
                if (oldobj.LEHS_End_Year__c != null)
                {
                    enddate_old = oldobj.LEHS_End_Year__c.format();
                }
                ctrl.InsertDataHistoryTable(newobj.LEHS_End_Year__c.format(), enddate_old, 'LEHS_End_Year__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEHS_Planning_to_Purchase__c) && newobj.LEHS_Planning_to_Purchase__c != oldobj.LEHS_Planning_to_Purchase__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEHS_Planning_to_Purchase__c, oldobj.LEHS_Planning_to_Purchase__c, 'LEHS_Planning_to_Purchase__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEHS_Purchase_When__c) && newobj.LEHS_Purchase_When__c != oldobj.LEHS_Purchase_When__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEHS_Purchase_When__c, oldobj.LEHS_Purchase_When__c, 'LEHS_Purchase_When__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEHS_Have_Realtor__c) && newobj.LEHS_Have_Realtor__c != oldobj.LEHS_Have_Realtor__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEHS_Have_Realtor__c, oldobj.LEHS_Have_Realtor__c, 'LEHS_Have_Realtor__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEHS_Comment__c) && newobj.LEHS_Have_Realtor__c != oldobj.LEHS_Comment__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEHS_Comment__c, oldobj.LEHS_Comment__c, 'LEHS_Comment__c', '' + newobj.Id);
            }
            
            
            //Feedback
            if (!string.isEmpty(newobj.LECF_Branch_Feedback__c) && newobj.LECF_Branch_Feedback__c != oldobj.LECF_Branch_Feedback__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECF_Branch_Feedback__c, oldobj.LECF_Branch_Feedback__c, 'LECF_Branch_Feedback__c', '' + newobj.Id);
            }
            if (newobj.LECF_Branch__c != oldobj.LECF_Branch__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECF_Branch__c), string.valueOf(oldobj.LECF_Branch__c), 'LECF_Branch__c', '' + newobj.Id);
            }
            
            
            if (!string.isEmpty(newobj.LECF_800_Feedback__c) && newobj.LECF_800_Feedback__c != oldobj.LECF_800_Feedback__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECF_800_Feedback__c, oldobj.LECF_800_Feedback__c, 'LECF_800_Feedback__c', '' + newobj.Id);
            }
            if (newobj.LECF_800__c != oldobj.LECF_800__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECF_800__c), string.valueOf(oldobj.LECF_800__c), 'LECF_800__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.LECF_Online_banking_Feedback__c) && newobj.LECF_Online_banking_Feedback__c != oldobj.LECF_Online_banking_Feedback__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECF_Online_banking_Feedback__c, oldobj.LECF_Online_banking_Feedback__c, 'LECF_Online_banking_Feedback__c', '' + newobj.Id);
            }
            if (newobj.LECF_Online_banking__c != oldobj.LECF_Online_banking__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECF_Online_banking__c), string.valueOf(oldobj.LECF_Online_banking__c), 'LECF_Online_banking__c', '' + newobj.Id);
            }
            
            
            if (!string.isEmpty(newobj.LECF_ATM_Feedback__c) && newobj.LECF_ATM_Feedback__c != oldobj.LECF_ATM_Feedback__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECF_ATM_Feedback__c, oldobj.LECF_ATM_Feedback__c, 'LECF_ATM_Feedback__c', '' + newobj.Id);
            }
            if (newobj.LECF_ATM__c != oldobj.LECF_ATM__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECF_ATM__c), string.valueOf(oldobj.LECF_ATM__c), 'LECF_ATM__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.LECF_Mobile_banking_Feedback__c) && newobj.LECF_Mobile_banking_Feedback__c != oldobj.LECF_Mobile_banking_Feedback__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECF_Mobile_banking_Feedback__c, oldobj.LECF_Mobile_banking_Feedback__c, 'LECF_Mobile_banking_Feedback__c', '' + newobj.Id);
            }
            if (newobj.LECF_Mobile_banking__c != oldobj.LECF_Mobile_banking__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECF_Mobile_banking__c), string.valueOf(oldobj.LECF_Mobile_banking__c), 'LECF_Mobile_banking__c', '' + newobj.Id);
            }
            
            
            if (!string.isEmpty(newobj.LECF_Comment__c) && newobj.LECF_Comment__c != oldobj.LECF_Comment__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECF_Comment__c, oldobj.LECF_Comment__c, 'LECF_Comment__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.LECF_Experience_Improvement_Feedback__c) && newobj.LECF_Experience_Improvement_Feedback__c != oldobj.LECF_Experience_Improvement_Feedback__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECF_Experience_Improvement_Feedback__c, oldobj.LECF_Experience_Improvement_Feedback__c, 'LECF_Experience_Improvement_Feedback__c', '' + newobj.Id);
            }
            
            
            //Withdrawal
            if (newobj.LEWS_CFCU_ATM__c != oldobj.LEWS_CFCU_ATM__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEWS_CFCU_ATM__c), string.valueOf(oldobj.LEWS_CFCU_ATM__c), 'LEWS_CFCU_ATM__c', '' + newobj.Id);
            }
            if (newobj.LEWS_InPerson__c != oldobj.LEWS_InPerson__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEWS_InPerson__c), string.valueOf(oldobj.LEWS_InPerson__c), 'LEWS_InPerson__c', '' + newobj.Id);
            }
            if (newobj.LEWS_Other_ATM__c != oldobj.LEWS_Other_ATM__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEWS_Other_ATM__c), string.valueOf(oldobj.LEWS_Other_ATM__c), 'LEWS_Other_ATM__c', '' + newobj.Id);
            }
            if (newobj.LEWS_Shared_ATM__c != oldobj.LEWS_Shared_ATM__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEWS_Shared_ATM__c), string.valueOf(oldobj.LEWS_Shared_ATM__c), 'LEWS_Shared_ATM__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.LEWS_Comment__c) && newobj.LEWS_Comment__c != oldobj.LEWS_Comment__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEWS_Comment__c, oldobj.LEWS_Comment__c, 'LEWS_Comment__c', '' + newobj.Id);
            }
            
            
            //Move your money
            if (!string.isEmpty(newobj.LEMP_Carry_Credit_Card_Balance__c) && newobj.LEMP_Carry_Credit_Card_Balance__c != oldobj.LEMP_Carry_Credit_Card_Balance__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Carry_Credit_Card_Balance__c, oldobj.LEMP_Carry_Credit_Card_Balance__c, 'LEMP_Carry_Credit_Card_Balance__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Number_of_Credit_Card__c != null && newobj.LEMP_Number_of_Credit_Card__c != oldobj.LEMP_Number_of_Credit_Card__c)
            {
                ctrl.InsertDataHistoryTable(string.valueof(newobj.LEMP_Number_of_Credit_Card__c), string.valueof(oldobj.LEMP_Number_of_Credit_Card__c), 'LEMP_Number_of_Credit_Card__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Your_Current_Rate__c != null && newobj.LEMP_Your_Current_Rate__c != oldobj.LEMP_Your_Current_Rate__c)
            {
                ctrl.InsertDataHistoryTable(string.valueof(newobj.LEMP_Your_Current_Rate__c), string.valueof(oldobj.LEMP_Your_Current_Rate__c), 'LEMP_Your_Current_Rate__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_Usage_Cash_Back__c != oldobj.LEMP_Credit_Card_Usage_Cash_Back__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_Usage_Cash_Back__c), string.valueOf(oldobj.LEMP_Credit_Card_Usage_Cash_Back__c), 'LEMP_Credit_Card_Usage_Cash_Back__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Credit_Card_Usage_Comments__c) && newobj.LEMP_Credit_Card_Usage_Comments__c != oldobj.LEMP_Credit_Card_Usage_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Credit_Card_Usage_Comments__c, oldobj.LEMP_Credit_Card_Usage_Comments__c, 'LEMP_Credit_Card_Usage_Comments__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_Usage_Low_Interest_Rate__c != oldobj.LEMP_Credit_Card_Usage_Low_Interest_Rate__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_Usage_Low_Interest_Rate__c), string.valueOf(oldobj.LEMP_Credit_Card_Usage_Low_Interest_Rate__c), 'LEMP_Credit_Card_Usage_Low_Interest_Rate__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_Usage_No_Annual_Fee__c != oldobj.LEMP_Credit_Card_Usage_No_Annual_Fee__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_Usage_No_Annual_Fee__c), string.valueOf(oldobj.LEMP_Credit_Card_Usage_No_Annual_Fee__c), 'LEMP_Credit_Card_Usage_No_Annual_Fee__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Credit_Card_Usage_Other__c) && newobj.LEMP_Credit_Card_Usage_Other__c != oldobj.LEMP_Credit_Card_Usage_Other__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Credit_Card_Usage_Other__c, oldobj.LEMP_Credit_Card_Usage_Other__c, 'LEMP_Credit_Card_Usage_Other__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Credit_Card_Usage_Reason_Comments__c) && newobj.LEMP_Credit_Card_Usage_Reason_Comments__c != oldobj.LEMP_Credit_Card_Usage_Reason_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Credit_Card_Usage_Reason_Comments__c, oldobj.LEMP_Credit_Card_Usage_Reason_Comments__c, 'LEMP_Credit_Card_Usage_Reason_Comments__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_Usage_Rewards__c != oldobj.LEMP_Credit_Card_Usage_Rewards__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_Usage_Rewards__c), string.valueOf(oldobj.LEMP_Credit_Card_Usage_Rewards__c), 'LEMP_Credit_Card_Usage_Rewards__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Credit_Card_You_Use_Often__c) && newobj.LEMP_Credit_Card_You_Use_Often__c != oldobj.LEMP_Credit_Card_You_Use_Often__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Credit_Card_You_Use_Often__c, oldobj.LEMP_Credit_Card_You_Use_Often__c, 'LEMP_Credit_Card_You_Use_Often__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Debit_Card_Usage_Comments__c) && newobj.LEMP_Debit_Card_Usage_Comments__c != oldobj.LEMP_Debit_Card_Usage_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Debit_Card_Usage_Comments__c, oldobj.LEMP_Debit_Card_Usage_Comments__c, 'LEMP_Debit_Card_Usage_Comments__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Debit_Card_Usage_Gasstation__c != oldobj.LEMP_Debit_Card_Usage_Gasstation__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Debit_Card_Usage_Gasstation__c), string.valueOf(oldobj.LEMP_Debit_Card_Usage_Gasstation__c), 'LEMP_Debit_Card_Usage_Gasstation__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Debit_Card_Usage_Grocries__c != oldobj.LEMP_Debit_Card_Usage_Grocries__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Debit_Card_Usage_Grocries__c), string.valueOf(oldobj.LEMP_Debit_Card_Usage_Grocries__c), 'LEMP_Debit_Card_Usage_Grocries__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Debit_Card_Usage_Online__c != oldobj.LEMP_Debit_Card_Usage_Online__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Debit_Card_Usage_Online__c), string.valueOf(oldobj.LEMP_Debit_Card_Usage_Online__c), 'LEMP_Debit_Card_Usage_Online__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Debit_Card_Usage_Other__c != oldobj.LEMP_Debit_Card_Usage_Other__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Debit_Card_Usage_Other__c), string.valueOf(oldobj.LEMP_Debit_Card_Usage_Other__c), 'LEMP_Debit_Card_Usage_Other__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Debit_Card_Usage_Retail__c != oldobj.LEMP_Debit_Card_Usage_Retail__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Debit_Card_Usage_Retail__c), string.valueOf(oldobj.LEMP_Debit_Card_Usage_Retail__c), 'LEMP_Debit_Card_Usage_Retail__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_International_Transfer_Comments__c) && newobj.LEMP_International_Transfer_Comments__c != oldobj.LEMP_International_Transfer_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_International_Transfer_Comments__c, oldobj.LEMP_International_Transfer_Comments__c, 'LEMP_International_Transfer_Comments__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_International_Transfer_Frequency__c) && newobj.LEMP_International_Transfer_Frequency__c != oldobj.LEMP_International_Transfer_Frequency__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_International_Transfer_Frequency__c, oldobj.LEMP_International_Transfer_Frequency__c, 'LEMP_International_Transfer_Frequency__c', '' + newobj.Id);
            }
            
            if (newobj.LEMP_Pay_Individuals_A2A__c != oldobj.LEMP_Pay_Individuals_A2A__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Individuals_A2A__c), string.valueOf(oldobj.LEMP_Pay_Individuals_A2A__c), 'LEMP_Pay_Individuals_A2A__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Individuals_ACH__c != oldobj.LEMP_Pay_Individuals_ACH__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Individuals_ACH__c), string.valueOf(oldobj.LEMP_Pay_Individuals_ACH__c), 'LEMP_Pay_Individuals_ACH__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Individuals_BillPay__c != oldobj.LEMP_Pay_Individuals_BillPay__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Individuals_BillPay__c), string.valueOf(oldobj.LEMP_Pay_Individuals_BillPay__c), 'LEMP_Pay_Individuals_BillPay__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Individuals_CC__c != oldobj.LEMP_Pay_Individuals_CC__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Individuals_CC__c), string.valueOf(oldobj.LEMP_Pay_Individuals_CC__c), 'LEMP_Pay_Individuals_CC__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Individuals_Check__c != oldobj.LEMP_Pay_Individuals_Check__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Individuals_Check__c), string.valueOf(oldobj.LEMP_Pay_Individuals_Check__c), 'LEMP_Pay_Individuals_Check__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Individuals_DC__c != oldobj.LEMP_Pay_Individuals_DC__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Individuals_DC__c), string.valueOf(oldobj.LEMP_Pay_Individuals_DC__c), 'LEMP_Pay_Individuals_DC__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Individuals_Other__c != oldobj.LEMP_Pay_Individuals_Other__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Individuals_Other__c), string.valueOf(oldobj.LEMP_Pay_Individuals_Other__c), 'LEMP_Pay_Individuals_Other__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_MoveMoney_A2A__c != oldobj.LEMP_Pay_MoveMoney_A2A__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_MoveMoney_A2A__c), string.valueOf(oldobj.LEMP_Pay_MoveMoney_A2A__c), 'LEMP_Pay_MoveMoney_A2A__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_MoveMoney_ACH__c != oldobj.LEMP_Pay_MoveMoney_ACH__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_MoveMoney_ACH__c), string.valueOf(oldobj.LEMP_Pay_MoveMoney_ACH__c), 'LEMP_Pay_MoveMoney_ACH__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_MoveMoney_BillPay__c != oldobj.LEMP_Pay_MoveMoney_BillPay__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_MoveMoney_BillPay__c), string.valueOf(oldobj.LEMP_Pay_MoveMoney_BillPay__c), 'LEMP_Pay_MoveMoney_BillPay__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_MoveMoney_CC__c != oldobj.LEMP_Pay_MoveMoney_CC__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_MoveMoney_CC__c), string.valueOf(oldobj.LEMP_Pay_MoveMoney_CC__c), 'LEMP_Pay_MoveMoney_CC__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_MoveMoney_Check__c != oldobj.LEMP_Pay_MoveMoney_Check__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_MoveMoney_Check__c), string.valueOf(oldobj.LEMP_Pay_MoveMoney_Check__c), 'LEMP_Pay_MoveMoney_Check__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_MoveMoney_DC__c != oldobj.LEMP_Pay_MoveMoney_DC__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_MoveMoney_DC__c), string.valueOf(oldobj.LEMP_Pay_MoveMoney_DC__c), 'LEMP_Pay_MoveMoney_DC__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_MoveMoney_Other__c != oldobj.LEMP_Pay_MoveMoney_Other__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_MoveMoney_Other__c), string.valueOf(oldobj.LEMP_Pay_MoveMoney_Other__c), 'LEMP_Pay_MoveMoney_Other__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Recurring_A2A__c != oldobj.LEMP_Pay_Recurring_A2A__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Recurring_A2A__c), string.valueOf(oldobj.LEMP_Pay_Recurring_A2A__c), 'LEMP_Pay_Recurring_A2A__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Recurring_ACH__c != oldobj.LEMP_Pay_Recurring_ACH__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Recurring_ACH__c), string.valueOf(oldobj.LEMP_Pay_Recurring_ACH__c), 'LEMP_Pay_Recurring_ACH__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Recurring_BillPay__c != oldobj.LEMP_Pay_Recurring_BillPay__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Recurring_BillPay__c), string.valueOf(oldobj.LEMP_Pay_Recurring_BillPay__c), 'LEMP_Pay_Recurring_BillPay__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Recurring_CC__c != oldobj.LEMP_Pay_Recurring_CC__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Recurring_CC__c), string.valueOf(oldobj.LEMP_Pay_Recurring_CC__c), 'LEMP_Pay_Recurring_CC__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Recurring_Check__c != oldobj.LEMP_Pay_Recurring_Check__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Recurring_Check__c), string.valueOf(oldobj.LEMP_Pay_Recurring_Check__c), 'LEMP_Pay_Recurring_Check__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Recurring_DC__c != oldobj.LEMP_Pay_Recurring_DC__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Recurring_DC__c), string.valueOf(oldobj.LEMP_Pay_Recurring_DC__c), 'LEMP_Pay_Recurring_DC__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Pay_Recurring_Other__c != oldobj.LEMP_Pay_Recurring_Other__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Pay_Recurring_Other__c), string.valueOf(oldobj.LEMP_Pay_Recurring_Other__c), 'LEMP_Pay_Recurring_Other__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Payment_Transfer_Comments__c) && newobj.LEMP_Payment_Transfer_Comments__c != oldobj.LEMP_Payment_Transfer_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Payment_Transfer_Comments__c, oldobj.LEMP_Payment_Transfer_Comments__c, 'LEMP_Payment_Transfer_Comments__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Transfer_Comments__c) && newobj.LEMP_Transfer_Comments__c != oldobj.LEMP_Transfer_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Transfer_Comments__c, oldobj.LEMP_Transfer_Comments__c, 'LEMP_Transfer_Comments__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEMP_Transfer_Frequency__c) && newobj.LEMP_Transfer_Frequency__c != oldobj.LEMP_Transfer_Frequency__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMP_Transfer_Frequency__c, oldobj.LEMP_Transfer_Frequency__c, 'LEMP_Transfer_Frequency__c', '' + newobj.Id);
            }
            
            //Contact Preference
            if (newobj.LECP_Written_Materials_Way_To_Send_Email__c!= oldobj.LECP_Written_Materials_Way_To_Send_Email__c)
            {
                system.debug('Contact Email###');
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECP_Written_Materials_Way_To_Send_Email__c), string.valueOf(oldobj.LECP_Written_Materials_Way_To_Send_Email__c), 'LECP_Written_Materials_Way_To_Send_Email__c', '' + newobj.Id);
            }
            if (newobj.LECP_Written_Materials_Way_To_Send_Mail__c!= oldobj.LECP_Written_Materials_Way_To_Send_Mail__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECP_Written_Materials_Way_To_Send_Mail__c), string.valueOf(oldobj.LECP_Written_Materials_Way_To_Send_Mail__c), 'LECP_Written_Materials_Way_To_Send_Mail__c', '' + newobj.Id);
            }
            if (newobj.LECP_ContactPhone_Yes__c!= oldobj.LECP_ContactPhone_Yes__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECP_ContactPhone_Yes__c), string.valueOf(oldobj.LECP_ContactPhone_Yes__c), 'LECP_ContactPhone_Yes__c', '' + newobj.Id);
            }
            
            
            if (newobj.LECP_ContactPhone_No__c!= oldobj.LECP_ContactPhone_No__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECP_ContactPhone_No__c), string.valueOf(oldobj.LECP_ContactPhone_No__c), 'LECP_ContactPhone_No__c', '' + newobj.Id);
            }
            
            if (!string.isEmpty(newobj.LECP_Comments__c) && newobj.LECP_Comments__c!= oldobj.LECP_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LECP_Comments__c, oldobj.LECP_Comments__c, 'LECP_Comments__c', '' + newobj.Id);
            }
            
            if (newobj.LEOL_Other_Existing_Loans__c!= oldobj.LEOL_Other_Existing_Loans__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEOL_Other_Existing_Loans__c), string.valueOf(oldobj.LEOL_Other_Existing_Loans__c), 'LEOL_Other_Existing_Loans__c', '' + newobj.Id);
            }
            
            //Auto vehicle
            
            if (newobj.LEAV_Current__c!= oldobj.LEAV_Current__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_Current__c), string.valueOf(oldobj.LEAV_Current__c), 'LEAV_Current__c', '' + newobj.Id);
            }
            
            if (newobj.LEAV_CurrentLoanProvider__c != oldobj.LEAV_CurrentLoanProvider__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_CurrentLoanProvider__c), string.valueOf(oldobj.LEAV_CurrentLoanProvider__c), 'LEAV_CurrentLoanProvider__c', '' + newobj.Id);
            }
            
            if (newobj.LEAV_CurrentRate__c != oldobj.LEAV_CurrentRate__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_CurrentRate__c), string.valueOf(oldobj.LEAV_CurrentRate__c), 'LEAV_CurrentRate__c', '' + newobj.Id);
            }
            
            if (newobj.LEAV_CurrentBalance__c != oldobj.LEAV_CurrentBalance__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_CurrentBalance__c), string.valueOf(oldobj.LEAV_CurrentBalance__c), 'LEAV_CurrentBalance__c', '' + newobj.Id);
            }
            
            if (newobj.LEAV_EndDateLoan__c != oldobj.LEAV_EndDateLoan__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_EndDateLoan__c), string.valueOf(oldobj.LEAV_EndDateLoan__c), 'LEAV_EndDateLoan__c', '' + newobj.Id);
            }
            if (newobj.LEAV_PlanningToBuy__c != oldobj.LEAV_PlanningToBuy__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_PlanningToBuy__c), string.valueOf(oldobj.LEAV_PlanningToBuy__c), 'LEAV_PlanningToBuy__c', '' + newobj.Id);
            }
            if (newobj.LEAV_PlanningToBuy__c != oldobj.LEAV_PlanningToBuy__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_PlanningToBuy__c), string.valueOf(oldobj.LEAV_PlanningToBuy__c), 'LEAV_PlanningToBuy__c', '' + newobj.Id);
            }
            
            if (newobj.LEAV_PlanningToBuy__c != oldobj.LEAV_PlanningToBuy__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_PlanningToBuy__c), string.valueOf(oldobj.LEAV_PlanningToBuy__c), 'LEAV_PlanningToBuy__c', '' + newobj.Id);
            }
            
            if (newobj.LEAV_PlanDate__c != oldobj.LEAV_PlanDate__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_PlanDate__c), string.valueOf(oldobj.LEAV_PlanDate__c), 'LEAV_PlanDate__c', '' + newobj.Id);
            }
            
            if (newobj.LEAV_AnticipateFinance__c != oldobj.LEAV_AnticipateFinance__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_AnticipateFinance__c), string.valueOf(oldobj.LEAV_AnticipateFinance__c), 'LEAV_AnticipateFinance__c', '' + newobj.Id);
            }
            if (newobj.LEAV_ContactPreferences__c != oldobj.LEAV_ContactPreferences__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_ContactPreferences__c), string.valueOf(oldobj.LEAV_ContactPreferences__c), 'LEAV_ContactPreferences__c', '' + newobj.Id);
            }
            
            
            //PrimaryTransaction Account 
            if (!string.isEmpty(newobj.LEPT_Financial_Institution__c) && newobj.LEPT_Financial_Institution__c != oldobj.LEPT_Financial_Institution__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEPT_Financial_Institution__c, oldobj.LEPT_Financial_Institution__c, 'LEPT_Financial_Institution__c', '' + newobj.Id);
            }
            if (newobj.LEPT_Deposit_rates__c != oldobj.LEPT_Deposit_rates__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEPT_Deposit_rates__c), string.valueOf(oldobj.LEPT_Deposit_rates__c), 'LEPT_Deposit_rates__c', '' + newobj.Id);
            }
            if (newobj.LEPT_Convenient_locations__c != oldobj.LEPT_Convenient_locations__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEPT_Convenient_locations__c), string.valueOf(oldobj.LEPT_Convenient_locations__c), 'LEPT_Convenient_locations__c', '' + newobj.Id);
            }
            if (newobj.LEPT_Have_financial_advisor_there__c != oldobj.LEPT_Have_financial_advisor_there__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEPT_Have_financial_advisor_there__c), string.valueOf(oldobj.LEPT_Have_financial_advisor_there__c), 'LEPT_Have_financial_advisor_there__c', '' + newobj.Id);
            }       
            if (newobj.LEPT_Loan_rates__c != oldobj.LEPT_Loan_rates__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEPT_Loan_rates__c), string.valueOf(oldobj.LEPT_Loan_rates__c), 'LEPT_Loan_rates__c', '' + newobj.Id);
            }
            if (newobj.LEPT_Online_mobile_apps__c != oldobj.LEPT_Online_mobile_apps__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEPT_Online_mobile_apps__c), string.valueOf(oldobj.LEPT_Online_mobile_apps__c), 'LEPT_Online_mobile_apps__c', '' + newobj.Id);
            }
            if (newobj.LEPT_Other__c != oldobj.LEPT_Other__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEPT_Other__c), string.valueOf(oldobj.LEPT_Other__c), 'LEPT_Other__c', '' + newobj.Id);
            }
            if (!string.isEmpty(newobj.LEPT_Comments__c) && newobj.LEPT_Comments__c != oldobj.LEPT_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEPT_Comments__c, oldobj.LEPT_Comments__c, 'LEPT_Comments__c', '' + newobj.Id);
            }
            
            //MakingDeposite
            if (!string.isEmpty(newobj.LEMD_CommentsDC__c) && newobj.LEMD_CommentsDC__c!= oldobj.LEMD_CommentsDC__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMD_CommentsDC__c, oldobj.LEMD_CommentsDC__c, 'LEMD_CommentsDC__c', '' + newobj.Id);
            }
            if (newobj.LEMD_ATM__c != oldobj.LEMD_ATM__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_ATM__c), string.valueOf(oldobj.LEMD_ATM__c), 'LEMD_ATM__c', '' + newobj.Id);
            } 
            if (newobj.LEMD_CFCU_Spectrum__c != oldobj.LEMD_CFCU_Spectrum__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_CFCU_Spectrum__c), string.valueOf(oldobj.LEMD_CFCU_Spectrum__c), 'LEMD_CFCU_Spectrum__c', '' + newobj.Id);
            } 
            if (!string.isEmpty(newobj.LEMD_CommentsForDD__c) && newobj.LEMD_CommentsForDD__c != oldobj.LEMD_CommentsForDD__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LEMD_CommentsForDD__c, oldobj.LEMD_CommentsForDD__c, 'LEMD_CommentsForDD__c', '' + newobj.Id);
            } 
            
            
            
            if (newobj.LEMD_In_person_branch__c != oldobj.LEMD_In_person_branch__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_In_person_branch__c), string.valueOf(oldobj.LEMD_In_person_branch__c), 'LEMD_In_person_branch__c', '' + newobj.Id);
            } 
            if (newobj.LEMD_Last_Updated_On__c != oldobj.LEMD_Last_Updated_On__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_Last_Updated_On__c), string.valueOf(oldobj.LEMD_Last_Updated_On__c), 'LEMD_Last_Updated_On__c', '' + newobj.Id);
            } 
            if (newobj.LEMD_Mobile__c != oldobj.LEMD_Mobile__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_Mobile__c), string.valueOf(oldobj.LEMD_Mobile__c), 'LEMD_Mobile__c', '' + newobj.Id);
            } 
            if (newobj.LEMD_No__c != oldobj.LEMD_No__c)
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_No__c), string.valueOf(oldobj.LEMD_No__c), 'LEMD_No__c', '' + newobj.Id);
            } 
            if (newobj.LEMD_Online__c != oldobj.LEMD_Online__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_Online__c), string.valueOf(oldobj.LEMD_Online__c), 'LEMD_Online__c', '' + newobj.Id);
            } 
            if (newobj.LEMD_At_another_financial_institution__c != oldobj.LEMD_At_another_financial_institution__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_At_another_financial_institution__c), string.valueOf(oldobj.LEMD_At_another_financial_institution__c), 'LEMD_At_another_financial_institution__c', '' + newobj.Id);
            }
            
            //Shared Branching
            if (!string.isEmpty(newobj.LESB_SharedBranching_Comments__c) && newobj.LESB_SharedBranching_Comments__c != oldobj.LESB_SharedBranching_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LESB_SharedBranching_Comments__c, oldobj.LESB_SharedBranching_Comments__c, 'LESB_SharedBranching_Comments__c', '' + newobj.Id);
            }
            
            if (newobj.LESB_Aware_SharedBranching__c != oldobj.LESB_Aware_SharedBranching__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LESB_Aware_SharedBranching__c), string.valueOf(oldobj.LESB_Aware_SharedBranching__c), 'LESB_Aware_SharedBranching__c', '' + newobj.Id);
            } 
            
            if (newobj.LESB_Aware_ConvBranching__c != oldobj.LESB_Aware_ConvBranching__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LESB_Aware_ConvBranching__c), string.valueOf(oldobj.LESB_Aware_ConvBranching__c), 'LESB_Aware_ConvBranching__c', '' + newobj.Id);
            } 
            
            
            //ATM Newwork
            if (newobj.LESF_ATM_Location__c != oldobj.LESF_ATM_Location__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LESF_ATM_Location__c), string.valueOf(oldobj.LESF_ATM_Location__c), 'LESF_ATM_Location__c', '' + newobj.Id);
            } 
            if (newobj.LESF_Aware_ATM_Netword__c != oldobj.LESF_Aware_ATM_Netword__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LESF_Aware_ATM_Netword__c), string.valueOf(oldobj.LESF_Aware_ATM_Netword__c), 'LESF_Aware_ATM_Netword__c', '' + newobj.Id);
            } 
            if (!string.isEmpty(newobj.LESF_Comments__c) && newobj.LESF_Comments__c != oldobj.LESF_Comments__c)
            {
                ctrl.InsertDataHistoryTable(newobj.LESF_Comments__c, oldobj.LESF_Comments__c, 'LESF_Comments__c', '' + newobj.Id);
            }
            
            /*CRM-1485 Begin here*/
            if (newobj.LEHS_Type_of_Mortgage__c != oldobj.LEHS_Type_of_Mortgage__c )
            {
                system.debug('Home Mortgage###');
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEHS_Type_of_Mortgage__c), string.valueOf(oldobj.LEHS_Type_of_Mortgage__c), 'LEHS_Type_of_Mortgage__c', '' + newobj.Id);
            } 
            if (newobj.LEHS_Comment_New__c != oldobj.LEHS_Comment_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEHS_Comment_New__c), string.valueOf(oldobj.LEHS_Comment_New__c), 'LEHS_Comment_New__c', '' + newobj.Id);
            }
            if (newobj.LECF_Experience_Improvement_Feedback_New__c != oldobj.LECF_Experience_Improvement_Feedback_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECF_Experience_Improvement_Feedback_New__c), string.valueOf(oldobj.LECF_Experience_Improvement_Feedback_New__c), 'LECF_Experience_Improvement_Feedback_New__c', '' + newobj.Id);
            }
            if (newobj.LECF_Comment_New__c != oldobj.LECF_Comment_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LECF_Comment_New__c), string.valueOf(oldobj.LECF_Comment_New__c), 'LECF_Comment_New__c', '' + newobj.Id);
            }
            if (newobj.LEAV_ContactPreferences_New__c != oldobj.LEAV_ContactPreferences_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEAV_ContactPreferences_New__c), string.valueOf(oldobj.LEAV_ContactPreferences_New__c), 'LEAV_ContactPreferences_New__c', '' + newobj.Id);
            }
            if (newobj.LEOL_Other_Existing_Loans__c != oldobj.LEOL_Other_Existing_Loans__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEOL_Other_Existing_Loans__c), string.valueOf(oldobj.LEOL_Other_Existing_Loans__c), 'LEOL_Other_Existing_Loans__c', '' + newobj.Id);
            }
            if (newobj.LEOM_Comments_New__c != oldobj.LEOM_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEOM_Comments_New__c), string.valueOf(oldobj.LEOM_Comments_New__c), 'LEOM_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.Retirement_New__c != oldobj.Retirement_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.Retirement_New__c), string.valueOf(oldobj.Retirement_New__c), 'Retirement_New__c', '' + newobj.Id);
            }
            if (newobj.LEOM_PlanUnforeseen_New__c != oldobj.LEOM_PlanUnforeseen_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEOM_PlanUnforeseen_New__c), string.valueOf(oldobj.LEOM_PlanUnforeseen_New__c), 'LEOM_PlanUnforeseen_New__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Payment_Transfer_Comments_New__c != oldobj.LEMP_Payment_Transfer_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Payment_Transfer_Comments_New__c), string.valueOf(oldobj.LEMP_Payment_Transfer_Comments_New__c), 'LEMP_Payment_Transfer_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Transfer_Comments_New__c != oldobj.LEMP_Transfer_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Transfer_Comments_New__c), string.valueOf(oldobj.LEMP_Transfer_Comments_New__c), 'LEMP_Transfer_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEMP_International_Transfer_Comments_New__c != oldobj.LEMP_International_Transfer_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_International_Transfer_Comments_New__c), string.valueOf(oldobj.LEMP_International_Transfer_Comments_New__c), 'LEMP_International_Transfer_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Debit_Card_Usage_Comments_New__c != oldobj.LEMP_Debit_Card_Usage_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Debit_Card_Usage_Comments_New__c), string.valueOf(oldobj.LEMP_Debit_Card_Usage_Comments_New__c), 'LEMP_Debit_Card_Usage_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_Usage_Other_New__c != oldobj.LEMP_Credit_Card_Usage_Other_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_Usage_Other_New__c), string.valueOf(oldobj.LEMP_Credit_Card_Usage_Other_New__c), 'LEMP_Credit_Card_Usage_Other_New__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_You_Use_Often_New__c != oldobj.LEMP_Credit_Card_You_Use_Often_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_You_Use_Often_New__c), string.valueOf(oldobj.LEMP_Credit_Card_You_Use_Often_New__c), 'LEMP_Credit_Card_You_Use_Often_New__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_Usage_Reason_Comments_N__c != oldobj.LEMP_Credit_Card_Usage_Reason_Comments_N__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_Usage_Reason_Comments_N__c), string.valueOf(oldobj.LEMP_Credit_Card_Usage_Reason_Comments_N__c), 'LEMP_Credit_Card_Usage_Reason_Comments_N__c', '' + newobj.Id);
            }
            if (newobj.LEMP_Credit_Card_Usage_Comments_New__c != oldobj.LEMP_Credit_Card_Usage_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMP_Credit_Card_Usage_Comments_New__c), string.valueOf(oldobj.LEMP_Credit_Card_Usage_Comments_New__c), 'LEMP_Credit_Card_Usage_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEMD_CFCU_Spectrum_YesNo__c != oldobj.LEMD_CFCU_Spectrum_YesNo__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_CFCU_Spectrum_YesNo__c), string.valueOf(oldobj.LEMD_CFCU_Spectrum_YesNo__c), 'LEMD_CFCU_Spectrum_YesNo__c', '' + newobj.Id);
            }
            if (newobj.LEMD_At_another_financial_insti_YesNo__c != oldobj.LEMD_At_another_financial_insti_YesNo__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_At_another_financial_insti_YesNo__c), string.valueOf(oldobj.LEMD_At_another_financial_insti_YesNo__c), 'LEMD_At_another_financial_insti_YesNo__c', '' + newobj.Id);
            }
            if (newobj.LEMD_CommentsForDD_New__c != oldobj.LEMD_CommentsForDD_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_CommentsForDD_New__c), string.valueOf(oldobj.LEMD_CommentsForDD_New__c), 'LEMD_CommentsForDD_New__c', '' + newobj.Id);
            }
            if (newobj.LEMD_CommentsDC_New__c != oldobj.LEMD_CommentsDC_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEMD_CommentsDC_New__c), string.valueOf(oldobj.LEMD_CommentsDC_New__c), 'LEMD_CommentsDC_New__c', '' + newobj.Id);
            }
            if (newobj.LEWS_Comment_New__c != oldobj.LEWS_Comment_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEWS_Comment_New__c), string.valueOf(oldobj.LEWS_Comment_New__c), 'LEWS_Comment_New__c', '' + newobj.Id);
            }
            if (newobj.LESB_SharedBranching_Comments_New__c != oldobj.LESB_SharedBranching_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LESB_SharedBranching_Comments_New__c), string.valueOf(oldobj.LESB_SharedBranching_Comments_New__c), 'LESB_SharedBranching_Comments_New__c', '' + newobj.Id);
            }
            /*if (newobj.ESF_Aware_ATM_Network_YesNo__c != oldobj.ESF_Aware_ATM_Network_YesNo__c )
            {
            ctrl.InsertDataHistoryTable(string.valueOf(newobj.ESF_Aware_ATM_Network_YesNo__c), string.valueOf(oldobj.ESF_Aware_ATM_Network_YesNo__c), 'ESF_Aware_ATM_Network_YesNo__c', '' + newobj.Id);
            }*/
            if (newobj.LESF_ATM_Location_YesNo__c != oldobj.LESF_ATM_Location_YesNo__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LESF_ATM_Location_YesNo__c), string.valueOf(oldobj.LESF_ATM_Location_YesNo__c), 'LESF_ATM_Location_YesNo__c', '' + newobj.Id);
            }
            if (newobj.LESF_Comments_New__c != oldobj.LESF_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LESF_Comments_New__c), string.valueOf(oldobj.LESF_Comments_New__c), 'LESF_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEPT_Comments_New__c != oldobj.LEPT_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEPT_Comments_New__c), string.valueOf(oldobj.LEPT_Comments_New__c), 'LEPT_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Money_In_Primary_Account__c != oldobj.LEEM_Money_In_Primary_Account__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Money_In_Primary_Account__c), string.valueOf(oldobj.LEEM_Money_In_Primary_Account__c), 'LEEM_Money_In_Primary_Account__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Savings_For_Retirement_401__c != oldobj.LEEM_Savings_For_Retirement_401__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Savings_For_Retirement_401__c), string.valueOf(oldobj.LEEM_Savings_For_Retirement_401__c), 'LEEM_Savings_For_Retirement_401__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Savings_For_Retirement_IRA__c != oldobj.LEEM_Savings_For_Retirement_IRA__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Savings_For_Retirement_IRA__c), string.valueOf(oldobj.LEEM_Savings_For_Retirement_IRA__c), 'LEEM_Savings_For_Retirement_IRA__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Savings_For_Retirement_O_R_Account__c != oldobj.LEEM_Savings_For_Retirement_O_R_Account__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Savings_For_Retirement_O_R_Account__c), string.valueOf(oldobj.LEEM_Savings_For_Retirement_O_R_Account__c), 'LEEM_Savings_For_Retirement_O_R_Account__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Savings_For_Retirement_O_Account__c != oldobj.LEEM_Savings_For_Retirement_O_Account__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Savings_For_Retirement_O_Account__c), string.valueOf(oldobj.LEEM_Savings_For_Retirement_O_Account__c), 'LEEM_Savings_For_Retirement_O_Account__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Comments_New__c != oldobj.LEEM_Comments_New__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Comments_New__c), string.valueOf(oldobj.LEEM_Comments_New__c), 'LEEM_Comments_New__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Deductible_Plan__c != oldobj.LEEM_Deductible_Plan__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Deductible_Plan__c), string.valueOf(oldobj.LEEM_Deductible_Plan__c), 'LEEM_Deductible_Plan__c', '' + newobj.Id);
            }
            if (newobj.LEEM_Health_Savings_Account__c != oldobj.LEEM_Health_Savings_Account__c )
            {
                ctrl.InsertDataHistoryTable(string.valueOf(newobj.LEEM_Health_Savings_Account__c), string.valueOf(oldobj.LEEM_Health_Savings_Account__c), 'LEEM_Health_Savings_Account__c', '' + newobj.Id);
            }
            /*if (newobj.Needs_Assesment__c.Type__c != oldobj.Needs_Assesment__c.Type__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.NA_Deposit__r.Type__c), string.valueOf(oldobj.NA_Deposit__r.Type__c), 'Type__c', '' + newobj.Id);
}
if (newobj.Financial_Instituition__c != oldobj.Financial_Instituition__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Financial_Instituition__c), string.valueOf(oldobj.Financial_Instituition__c), 'Financial_Instituition__c', '' + newobj.Id);
}
if (newobj.Balance__c != oldobj.Balance__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Balance__c), string.valueOf(oldobj.Balance__c), 'Balance__c', '' + newobj.Id);
}
if (newobj.Rate__c != oldobj.Rate__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Rate__c), string.valueOf(oldobj.Rate__c), 'Rate__c', '' + newobj.Id);
}
if (newobj.Financial_Institution__c != oldobj.Financial_Institution__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Financial_Institution__c), string.valueOf(oldobj.Financial_Institution__c), 'Financial_Institution__c', '' + newobj.Id);
}
if (newobj.Type_of_Loan__c != oldobj.Type_of_Loan__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Type_of_Loan__c), string.valueOf(oldobj.Type_of_Loan__c), 'Type_of_Loan__c', '' + newobj.Id);
}
if (newobj.End_Date__c != oldobj.End_Date__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.End_Date__c), string.valueOf(oldobj.End_Date__c), 'End_Date__c', '' + newobj.Id);
}
if (newobj.Name__c != oldobj.Name__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Name__c), string.valueOf(oldobj.Name__c), 'Name__c', '' + newobj.Id);
}
if (newobj.Age__c != oldobj.Age__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Age__c), string.valueOf(oldobj.Age__c), 'Age__c', '' + newobj.Id);
}
if (newobj.Want_to_Refer_Membership__c != oldobj.Want_to_Refer_Membership__c )
{
ctrl.InsertDataHistoryTable(string.valueOf(newobj.Want_to_Refer_Membership__c), string.valueOf(oldobj.Want_to_Refer_Membership__c), 'Want_to_Refer_Membership__c', '' + newobj.Id);
}*/
            /*CRM-1485 Ends here*/
            
            
            
        }
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Needs_Assesment__c newobj : Trigger.New){
            Needs_Assesment__c oldobj = Trigger.oldMap.get(newobj.Id);
            if(oldobj.LEPT_Financial_Institution__c  != newobj.LEPT_Financial_Institution__c){
                newobj.LEPT_Last_Response_Date_For_FI__c =  system.today();
            }
            if(oldobj.LEPT_Comments__c != newobj.LEPT_Comments__c){
                newobj.LEPT_Last_Response_Date_for_Comments__c =  system.today();
            }        
        }    
    }
    if(Trigger.isInsert && Trigger.isBefore){
        for(Needs_Assesment__c newobj : Trigger.New){
            if(newobj.LEPT_Financial_Institution__c != Null){
                newobj.LEPT_Last_Response_Date_For_FI__c =  system.today();
            }
            if(newobj.LEPT_Comments__c != Null){
                newobj.LEPT_Last_Response_Date_for_Comments__c =  system.today();
            }        
        }  
    }
    
    
    
    
    if (Trigger.isafter)
    {
        List<NeedAssessmentScore__c> Assscore = new List<NeedAssessmentScore__c>();
        Map<string, MemberConnectScoreSetting__c> mcs = MemberConnectScoreSetting__c.getAll();
        for(Needs_Assesment__c newobj : Trigger.New)
        {
            //  Needs_Assesment__c oldobj = Trigger.oldMap.get(newobj.Id);
	            Account account = [select Id,BIRTH_DATE__pc, Last_NA_LEHS__c, Last_NA_LEOM__c, NA_LEHS_Complete__c, NA_LEWS_Complete__c, NA_Opt_Out_Updated__c,
	                               NA_LEMP_Complete__c, NA_LECF_Complete__c, NA_LEOM_Complete__c, NA_Opt_Out_Date__c, NA_LESF_Complete__c, NA_LESB_Complete__c,
	                               NA_LEHS_Expired__c, NA_LEOM_Expired__c, NA_Eligibility__c, NA_Opt_Out__c, NA_LECP_Complete__c, NA_LEPT_Complete__c, NA_LEMD_Complete__c,
	                               NA_LEOL_Complete__c,NA_LEAV_Complete__c,NA_LEEM_Complete__c,NA_LEMQ_Complete__c                            
	                               from Account where id =: newobj.Member__c limit 1];
            
            
            system.debug('newobj.LEOL_Other_Existing_Loans__c---' + newobj.LEOL_Other_Existing_Loans__c);
            
            system.debug('newobj.LECP_Partially_Completed__c---' + newobj.LECP_Partially_Completed__c);
            
            
            if (newobj.LEOL_Other_Existing_Loans__c != null)
            	{	
                    system.debug('newobj.ID---' + newobj.ID);
                if(newobj.LEOL_Other_Existing_Loans__c  == 'Yes')
                { 
                    system.debug('newobj.ID---111' + newobj.ID);
                    List<NA_Other_Existing_Loans__c> listOtherLoans = [select Id,Financial_Institution__c,Type_of_Loan__c from NA_Other_Existing_Loans__c where Needs_Assessment__c =: newobj.ID ];
                    account.NA_LEOL_Complete__c =false;
                    delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Existing Loan'];
                    
                    if(listOtherLoans.size() > 0)
                    {
                        
                        for(NA_Other_Existing_Loans__c item : listOtherLoans )
                        {
                            system.debug('newobj.ID---item' + item);
                            if(item.Financial_Institution__c != null && item.Type_of_Loan__c != null)
                            {
                            	if(mcs.containsKey('Existing Loan') && !account.NA_LEOL_Complete__c){
			                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
			                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Existing Loan',Score__c=mcs.get('Existing Loan').Score__C));
			                    }
                                account.NA_LEOL_Complete__c =true; 
                                break;     
                                
                            }
                        }
                    }
                    else
                    {
                        account.NA_LEOL_Complete__c =false;
                        delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Existing Loan'];
                    }
                    
                }
                else
                {
                    if(mcs.containsKey('Existing Loan') && !account.NA_LEOL_Complete__c){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Existing Loan',Score__c=mcs.get('Existing Loan').Score__C));
                    }
                    account.NA_LEOL_Complete__c =true;  
                    
                }
                
            }
            else
            {
                account.NA_LEOL_Complete__c =false;
                delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Existing Loan'];
            }
            
            system.debug('account.NA_LEOL_Complete__c---' + account.NA_LEOL_Complete__c);
            
            //LECP Contact Preferences
            if (newobj.LECP_Written_Materials_Way_To_Send_Email__c || newobj.LECP_Written_Materials_Way_To_Send_Mail__c)
            {
                account.NA_LECP_Complete__C = true;
            }
            else
            {
                account.NA_LECP_Complete__c =false;
            }
            
            //LEMQ Extend Benefits
            //if (newobj.LEMQ_Last_Updated_On__c != oldobj.LEMQ_Last_Updated_On__c)
            if (newobj.LEMQ_Last_Updated_On__c != null)
            {
               
                if(mcs.containsKey('Referrals') && !account.NA_LEMQ_Complete__C){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Extended benefits',Sub_Tab__c='Referrals',Score__c=mcs.get('Referrals').Score__C));
                }
                account.NA_LEMQ_Complete__C = true;
            }
            else
            {
                account.NA_LEMQ_Complete__C = false;
                
                delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Referrals'];
            }
            //LEOL
            //Thsi is implemented in OtherExistingLoanTrigger.trigger
            
            //LEAV  Auto / Vehicle
            if ((newobj.LEAV_Current__c == 'No' || newobj.LEAV_Current__c == 'Prefer Not to Answer' || newobj.LEAV_Current__c == 'Yes' || 
                   (newobj.LEAV_Current__c == 'Yes' && newobj.LEAV_CurrentLoanProvider__c != null &&  newobj.LEAV_CurrentRate__c != null)) 
                	&& 
                	(newobj.LEAV_PlanningToBuy__c == 'Prefer Not to Answer' ||  newobj.LEAV_PlanningToBuy__c == 'No' || newobj.LEAV_PlanningToBuy__c == 'Yes' || 
                 	(newobj.LEAV_PlanningToBuy__c == 'Yes' && 
                      newobj.LEAV_PlanDate__c != null && 
                      newobj.LEAV_AnticipateFinance__c != null  )  )  )
            	{
                ///newobj.NA_LEAV_Complete = true;
               
                if(mcs.containsKey('Auto') && !account.NA_LEAV_Complete__C){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Finance you life events',Sub_Tab__c='Auto',Score__c=mcs.get('Auto').Score__C));
                }
                account.NA_LEAV_Complete__C = true;
            }
            else
            {
                account.NA_LEAV_Complete__C = false;
                delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Auto'];
            }
            
            //LEEM Earn More
            if (newobj.LEEM_Money_In_Primary_Account__c != null   && 
                (newobj.LEEM_Savings_For_Retirement_401__c ==true || 
                 newobj.LEEM_Savings_For_Retirement_IRA__c==true  || 
                 newobj.LEEM_Savings_For_Retirement_O_R_Account__c==true || 
                 newobj.LEEM_Savings_For_Retirement_O_Account__c==true) 
                 && newobj.LEEM_Deductible_Plan__c != null  && newobj.LEEM_Health_Savings_Account__c != null )
            {
                if(mcs.containsKey('Earn More') && !account.NA_LEEM_Complete__C){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Earn more from saving',Sub_Tab__c='Earn More',Score__c=mcs.get('Earn More').Score__C));
                }
                account.NA_LEEM_Complete__C = true;
                //newobj.NA_LEEM_Complete = true;           
            }
            else
            {
                account.NA_LEEM_Complete__C = false; 
                delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Earn More'];           
            }
            
            
            //LEHS Housing
          /*  if ((newobj.Do_you_Rent_or_Own__c == 'Prefer Not to Answer' || 
                    newobj.Do_you_Rent_or_Own__c == 'Rent' ||
                    newobj.Do_you_Rent_or_Own__c == 'Live with Relatives' || 
                    newobj.Do_you_Rent_or_Own__c == 'Own - Paid Off' ||
                    ((newobj.Do_you_Rent_or_Own__c == 'Own') && 
                        newobj.LEHS_Current_Lender__c != null && 
                        newobj.LEHS_Rate__c != null  &&
                        newobj.LEHS_Current_Balance__c != null &&
                        newobj.LEHS_Type_of_Mortgage__c != null && 
                        newobj.LEHS_End_Year__c != null
                    ) )
                &&
                (
                    newobj.LEHS_Planning_to_Purchase__c == 'Prefer Not to Answer' ||
                    newobj.LEHS_Planning_to_Purchase__c == 'No' ||
                    (
                        newobj.Do_you_Rent_or_Own__c == 'Own - Paid Off' &&
                        newobj.LEHS_Planning_to_Purchase__c == 'Yes' && 
                        newobj.LEHS_Purchase_When__c != null 
                    ) ||
                    (
                        newobj.Do_you_Rent_or_Own__c != 'Own - Paid Off' &&
                        newobj.LEHS_Planning_to_Purchase__c == 'Yes' && 
                        newobj.LEHS_Purchase_When__c != null && 
                        
                        newobj.LEHS_Type_of_Mortgage__c != null && 
                        newobj.LEHS_End_Year__c != null
                    )
                )
            )*/
            // Below is the new logic as per crm-1463
            if (((newobj.Do_you_Rent_or_Own__c == 'Own') && ((newobj.LEHS_Current_Lender__c != null && newobj.LEHS_Rate__c != null)  ||
												(newobj.LEHS_Current_Lender__c != null && newobj.LEHS_Current_Balance__c != null) ||
												(newobj.LEHS_Current_Lender__c != null && newobj.LEHS_Type_of_Mortgage__c != null) || 
												(newobj.LEHS_Current_Lender__c != null && newobj.LEHS_End_Year__c != null)
												
												||
												(newobj.LEHS_Rate__c != null && newobj.LEHS_Current_Balance__c != null )||
												(newobj.LEHS_Rate__c != null && newobj.LEHS_Type_of_Mortgage__c != null )||
												(newobj.LEHS_Rate__c != null && newobj.LEHS_End_Year__c != null )
												||
												
												(newobj.LEHS_Current_Balance__c != null && newobj.LEHS_Type_of_Mortgage__c != null) ||
												(newobj.LEHS_Current_Balance__c != null && newobj.LEHS_End_Year__c != null) 
												
												||
												(newobj.LEHS_Type_of_Mortgage__c != null && newobj.LEHS_End_Year__c != null)))

												|| 
												(newobj.LEHS_Planning_to_Purchase__c == 'No')
												
												||
												(newobj.Do_you_Rent_or_Own__c == 'Live with Relatives')
												
												|| 
												(newobj.Do_you_Rent_or_Own__c == 'Prefer Not to Answer')
												
												||
												(newobj.LEHS_Planning_to_Purchase__c == 'Prefer Not to Answer')
												
												||
												(newobj.LEHS_Planning_to_Purchase__c == 'Yes' && newobj.LEHS_Purchase_When__c != null ))
            {
                ///newobj.member.NA LEHS Complete = true;
                if(mcs.containsKey('Housing') && !account.NA_LEHS_Complete__c){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Finance you life events',Sub_Tab__c='Housing',Score__c=mcs.get('Housing').Score__C));
                }
                account.NA_LEHS_Complete__c = true;
                
            }
            else
            {
                account.NA_LEHS_Complete__c = false;
                 delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Housing'];           
            }
            
            //LEMD - Deposits (making deposits)
            if((
                newobj.LEMD_CFCU_Spectrum_YesNo__c != null && 
                newobj.LEMD_At_another_financial_insti_YesNo__c != null
            ) 
               && 
               (
                   newobj.LEMD_In_person_branch__c || 
                   newobj.LEMD_ATM__c              || 
                   newobj.LEMD_Online__c           || 
                   newobj.LEMD_Mobile__c
               )
              )
            {
                ///newobj.member.NA_LEMD_Complete = true;
                if(mcs.containsKey('Deposits') && !account.NA_LEMD_Complete__c){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Optimization how you move money',Sub_Tab__c='Deposits',Score__c=mcs.get('Deposits').Score__C));
                }
                account.NA_LEMD_Complete__c = true;
            }
            else
            {
                account.NA_LEMD_Complete__c = false;
                delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Deposits'];           
            }
            
            //LEPT Primary Account
            if ( newobj.LEPT_Financial_Institution__c != null  && 
                ( newobj.LEPT_Convenient_locations__c || 
                 newobj.LEPT_Deposit_rates__c        || 
                 newobj.LEPT_Have_financial_advisor_there__c || 
                 newobj.LEPT_Loan_rates__c || 
                 newobj.LEPT_Online_mobile_apps__c || 
                 newobj.LEPT_Other__c)
               )         
            {
                if(mcs.containsKey('Primary Accounts') && !account.NA_LEPT_Complete__c){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Optimization how you move money',Sub_Tab__c='Primary Accounts',Score__c=mcs.get('Primary Accounts').Score__C));
                }
                account.NA_LEPT_Complete__c = true; 
                //newobj.NA_LEPT_Complete = true;
            }
            else
            {
                account.NA_LEPT_Complete__c = false;
                 delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Primary Accounts'];           
            }
            
            //LESB Shared Branching
            if (newobj.LESB_Aware_ConvBranching__c != null && 
                newobj.LESB_Aware_SharedBranching__c != null)
            {    
                if(mcs.containsKey('Shared Branches') && !account.NA_LESB_Complete__c){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Optimization how you move money',Sub_Tab__c='Shared Branches',Score__c=mcs.get('Shared Branches').Score__C));
                }       
                account.NA_LESB_Complete__c = true;
                ///newobj.NA_LESB_Complete = true;
            }
            else
            {
                account.NA_LESB_Complete__c = false;
                 delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Shared Branches'];           
            }
            
            //LESF   ATM Networks
            if (newobj.LESF_ATM_Location_YesNo__c != null && 
                newobj.LESF_Aware_ATM_Network_YesNo__c != null)
            {
                if(mcs.containsKey('ATM') && !account.NA_LESF_Complete__c){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Optimization how you move money',Sub_Tab__c='ATM',Score__c=mcs.get('ATM').Score__C));
                }   
                account.NA_LESF_Complete__c = true;
                ///newobj.NA_LESF_Complete = true;
            }
            else
            {
                account.NA_LESF_Complete__c = false;
                delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'ATM'];
            }
            
            //LEWS Withdrawals
            if (newobj.LEWS_CFCU_ATM__c == true ||  newobj.LEWS_Shared_ATM__c == true ||  newobj.LEWS_Other_ATM__c ==true ||  newobj.LEWS_InPerson__c == true               )
            {
                if(mcs.containsKey('Withdrawals') && !account.NA_LEWS_Complete__c){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Optimization how you move money',Sub_Tab__c='Withdrawals',Score__c=mcs.get('Withdrawals').Score__C));
                }
                account.NA_LEWS_Complete__c = true;
                ///newobj.NA_LEWS_Complete = true;  
            }
            else
            {
                account.NA_LEWS_Complete__c = false;
                 delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Withdrawals'];           
            }
            
            //LEOM Other Milestones
            if ( (newobj.Home_Improvement__c == 'Prefer Not to Answer' ||  newobj.Home_Improvement__c =='No' || (newobj.Home_Improvement__c == 'Yes' && newobj.Home_Improvement_Timeframe__c != null && newobj.Home_Improvement_Plan__c != null ) ) && 
                (newobj.College__c == 'Prefer Not to Answer' ||  newobj.College__c =='No' || ( newobj.College__c =='Yes' && newobj.College_Timeframe__c != null && newobj.College_Plan__c != null )) && 
                (newobj.Medical__c  == 'Prefer Not to Answer' ||  newobj.Medical__c =='No' || ( newobj.Medical__c =='Yes' && newobj.Medical_Timeframe__c != null && newobj.Medical_Plan__c != null )) && 
                (newobj.Purchase_RV_Boat__c  == 'Prefer Not to Answer' ||  newobj.Purchase_RV_Boat__c =='No' || ( newobj.Purchase_RV_Boat__c =='Yes' && newobj.Purchase_RV_Boat_Timeframe__c != null && newobj.Purchase_RV_Boat_Plan__c != null )) && 
                (newobj.Retirement_New__c == 'Prefer Not to Answer' ||  newobj.Retirement_New__c =='No' || newobj.Retirement_New__c =='Already Retired' ||( newobj.Retirement_New__c =='Yes' && newobj.Retirement_Timeframe__c != null && newobj.Retirement_Plan__c != null )) && 
                (newobj.Travel__c == 'Prefer Not to Answer' ||  newobj.Travel__c =='No' || ( newobj.Travel__c =='Yes' && newobj.Travel_Timeframe__c != null && newobj.Travel_Plan__c != null )) && 
                (newobj.Life_Events__c == 'Prefer Not to Answer' ||  newobj.Life_Events__c =='No' || ( newobj.Life_Events__c =='Yes' && newobj.Life_Events_Timeframe__c != null && newobj.Life_Events_Plan__c != null )) &&  
                (newobj.Other__c == 'Prefer Not to Answer' ||  newobj.Other__c =='No' || ( newobj.Other__c =='Yes' && newobj.Other_Timeframe__c != null && newobj.Other_Plan__c != null ))
               )
            {
                if(!account.NA_LEOM_Complete__c){
                    if(mcs.containsKey('Milestone Home Improvements')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planning any home improvements?',Score__c=mcs.get('Milestone Home Improvements').Score__C));
                    }
                    if(mcs.containsKey('Milestone College Expenses')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planning for college expenses?',Score__c=mcs.get('Milestone College Expenses').Score__C));
                    }
                    if(mcs.containsKey('Milestone Retirement')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planning for retirement?',Score__c=mcs.get('Milestone Retirement').Score__C));
                    }
                    if(mcs.containsKey('Milestone Travel')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planning to travel?',Score__c=mcs.get('Milestone Travel').Score__C));
                    }
                    if(mcs.containsKey('Milestone Medical Expenses')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planning for medical expenses?',Score__c=mcs.get('Milestone Medical Expenses').Score__C));
                    }
                    if(mcs.containsKey('Milestone Life Events')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planing for life events?',Score__c=mcs.get('Milestone Life Events').Score__C));
                    }
                    if(mcs.containsKey('Milestone Purchase Boat')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planing to purchase a boat or RV?',Score__c=mcs.get('Milestone Purchase Boat').Score__C));
                    }
                    if(mcs.containsKey('Milestone Other Expenses')){
                        Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                                Main_Tab__c='Finance you life events',Sub_Tab__c='Milestone',Sub_Tab_Section__c='Are you planning for other expenses?',Score__c=mcs.get('Milestone Other Expenses').Score__C));
                    }
                }
                account.NA_LEOM_Complete__c = true;
                //newobj.NA_LEOM_Complete = true;
            }
            else
            {
                account.NA_LEOM_Complete__c = false;
                 delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Milestone'];           
            }
            
            //LECF Provide Feedback
            //Krunal update: check for false instead of null on the checkbox fields                                        
            if ( (newobj.LECF_Comment__c!=null && newobj.LECF_Comment__c != '') || 
                newobj.LECF_Experience_Improvement_Feedback__c != null || 
                (newobj.LECF_Branch__c         == true|| 
                 newobj.LECF_800__c            == true || 
                 newobj.LECF_Online_banking__c == true || 
                 newobj.LECF_Mobile_banking__c == true || 
                 newobj.LECF_ATM__c            == true)
               )
            {
                
                account.NA_LECF_Complete__c = true;
                //newobj.NA_LECF_Complete = true;
            }
            else
            {
                account.NA_LECF_Complete__c = false;
            }
            
            //LEMP    Payments / Transfers
            if (
                (newobj.LEMP_Pay_Recurring_Check__c || 
                 newobj.LEMP_Pay_Recurring_BillPay__c || 
                 newobj.LEMP_Pay_Recurring_DC__c || 
                 newobj.LEMP_Pay_Recurring_CC__c || 
                 newobj.LEMP_Pay_Recurring_ACH__c || 
                 newobj.LEMP_Pay_Recurring_A2A__c || 
                 newobj.LEMP_Pay_Recurring_Other__c || 
                 newobj.LEMP_Pay_Individuals_Check__c || 
                 newobj.LEMP_Pay_Individuals_BillPay__c || 
                 newobj.LEMP_Pay_Individuals_DC__c || 
                 newobj.LEMP_Pay_Individuals_CC__c || 
                 newobj.LEMP_Pay_Individuals_ACH__c || 
                 newobj.LEMP_Pay_Individuals_A2A__c ||
                 newobj.LEMP_Pay_Individuals_Other__c || 
                 newobj.LEMP_Pay_MoveMoney_Check__c || 
                 newobj.LEMP_Pay_MoveMoney_BillPay__c || 
                 newobj.LEMP_Pay_MoveMoney_DC__c ||
                 newobj.LEMP_Pay_MoveMoney_CC__c || 
                 newobj.LEMP_Pay_MoveMoney_ACH__c || 
                 newobj.LEMP_Pay_MoveMoney_A2A__c || 
                 newobj.LEMP_Pay_MoveMoney_Other__c
                ) 
                && 
                newobj.LEMP_Transfer_Frequency__c !=null
                && 
                newobj.LEMP_International_Transfer_Frequency__c != null
                && 
                ( newobj.LEMP_Debit_Card_Usage_Retail__c || 
                 newobj.LEMP_Debit_Card_Usage_Grocries__c || 
                 newobj.LEMP_Debit_Card_Usage_Gasstation__c || 
                 newobj.LEMP_Debit_Card_Usage_Online__c || 
                 newobj.LEMP_Debit_Card_Usage_Other__c
                ) 
                &&
                (newobj.LEMP_Credit_Card_Usage_No_Annual_Fee__c    || 
                 newobj.LEMP_Credit_Card_Usage_Rewards__c || 
                 newobj.LEMP_Credit_Card_Usage_Cash_Back__c || 
                 newobj.LEMP_Credit_Card_Usage_Low_Interest_Rate__c ||
                 newobj.LEMP_Credit_Card_Usage_Other_New__c !=null
                ) 
                && 
                newobj.LEMP_Carry_Credit_Card_Balance__c != null && 
                newobj.LEMP_Credit_Card_You_Use_Often_New__c != null &&
                newobj.LEMP_Number_of_Credit_Card__c != null &&
                newobj.LEMP_Your_Current_Rate__c != null
                
                
                
                
            )
            {
                system.debug('-------payment---'+mcs.containsKey('Payments'));
                system.debug('-------account.NA_LEMP_Complete__c---'+account.NA_LEMP_Complete__c);
                if(mcs.containsKey('Payments') && !account.NA_LEMP_Complete__c){
                    Assscore.add(new NeedAssessmentScore__c(Member__c=account.id,Member_Connect__c=newobj.id,
                                                            Main_Tab__c='Optimization how you move money',Sub_Tab__c='Payments',Score__c=mcs.get('Payments').Score__C));
                }
                account.NA_LEMP_Complete__c = true;
                //newobj.NA_LEMP_Complete = true;
            } 
            else
            {
                account.NA_LEMP_Complete__c = false;
                delete [select id,name from NeedAssessmentScore__c where Member__c=:account.id AND Member_Connect__c=:newobj.id AND Sub_Tab__c=:'Payments'];           
            }
            
            
            
            update account;
            
            Needs_Assesment__c  NAObj = [select id, name, LEAV_Partially_Completed__c, LECF_Partially_Completed__c,
                                         LECP_Partially_Completed__c, LEEM_Partially_Completed__c, LEHS_Partially_Completed__c, 
                                         LEMD_Partially_Completed__c, LEMP_Partially_Completed__c, LEMQ_Partially_Completed__c, 
                                         LEOL_Partially_Completed__c, LEOM_Partially_Completed__c, LEPT_Partially_Completed__c, 
                                         LESB_Partially_Completed__c, LESF_Partially_Completed__c, LEWS_Partially_Completed__c 
                                         from Needs_Assesment__c  where id =: newobj.id];
            
            system.debug('NAObj.LECP_Partially_Completed__c=='+NAObj.LECP_Partially_Completed__c);
            
            system.debug('NAObj.LEAV_Partially_Completed__c=='+NAObj.LEAV_Partially_Completed__c);
            system.debug('NAObj.LECF_Partially_Completed__c=='+NAObj.LECF_Partially_Completed__c);
            system.debug('NAObj.LECP_Partially_Completed__c=='+NAObj.LECP_Partially_Completed__c);
            system.debug('NAObj.LEEM_Partially_Completed__c=='+NAObj.LEEM_Partially_Completed__c);
            system.debug('NAObj.LEHS_Partially_Completed__c=='+NAObj.LEHS_Partially_Completed__c);
            system.debug('NAObj.LEMD_Partially_Completed__c'+NAObj.LEMD_Partially_Completed__c);
            system.debug('NAObj.LEMP_Partially_Completed__c'+NAObj.LEMP_Partially_Completed__c);
            system.debug('NAObj.LEMQ_Partially_Completed__c'+NAObj.LEMQ_Partially_Completed__c);
            system.debug('NAObj.LEOL_Partially_Completed__c'+NAObj.LEOL_Partially_Completed__c);
            system.debug('NAObj.LEOM_Partially_Completed__c'+NAObj.LEOM_Partially_Completed__c);
            system.debug('NAObj.LEPT_Partially_Completed__c'+NAObj.LEPT_Partially_Completed__c);
            system.debug(' NAObj.LESB_Partially_Completed__c'+ NAObj.LESB_Partially_Completed__c);
            system.debug(' NAObj.LESF_Partially_Completed__c '+ NAObj.LESF_Partially_Completed__c );
            system.debug('NAObj.LEWS_Partially_Completed__c'+NAObj.LEWS_Partially_Completed__c);
            
            if(NAObj.LEAV_Partially_Completed__c ||
               NAObj.LECF_Partially_Completed__c ||
               NAObj.LECP_Partially_Completed__c ||
               NAObj.LEEM_Partially_Completed__c ||
               NAObj.LEHS_Partially_Completed__c ||
               NAObj.LEMD_Partially_Completed__c ||
               NAObj.LEMP_Partially_Completed__c ||
               NAObj.LEMQ_Partially_Completed__c ||
               NAObj.LEOL_Partially_Completed__c ||
               NAObj.LEOM_Partially_Completed__c ||
               NAObj.LEPT_Partially_Completed__c ||
               NAObj.LESB_Partially_Completed__c ||
               NAObj.LESF_Partially_Completed__c ||
               NAObj.LEWS_Partially_Completed__c){            	
                   account.NA_Partial__c = true;
               }
            else
            {            	
                account.NA_Partial__c = false;
            }
            
            update account;
            
            
            
        }
        insert Assscore;
        
    }
}