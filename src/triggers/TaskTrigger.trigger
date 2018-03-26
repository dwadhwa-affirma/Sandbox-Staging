trigger TaskTrigger on Task (before delete) {
    
    String ProfileId = UserInfo.getProfileId(); 
    List<Profile> profiles = [Select id from Profile where name = 'CFCU Admin'];

    if(System.Trigger.isDelete){
        for(Task t : Trigger.old){
            if(ProfileId != profiles[0].id){
            if(t.Subject != null && t.Subject != ''){
                t.addError('You are not allowed to delete a Task. Please contact your System Administrator for assistance.');
            }
          } 
        }
     }
  }