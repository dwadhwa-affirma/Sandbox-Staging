trigger EventTrigger on Event (before delete) {

    String ProfileId = UserInfo.getProfileId(); 
    List<Profile> profiles = [Select id from Profile where name = 'CFCU Admin'];
    
    if(System.Trigger.isDelete){
        for(Event e : Trigger.old){
            if(ProfileId != profiles[0].id){
            if(e.Subject != null && e.Subject != ''){
                e.addError('You are not allowed to delete an Event. Please contact your System Administrator for assistance.');
            }
          }
       }
    }
}