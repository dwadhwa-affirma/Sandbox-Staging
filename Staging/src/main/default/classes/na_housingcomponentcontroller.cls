public with sharing class na_housingcomponentcontroller {
    
    
   
    
    public void na_housingcomponentcontroller()
    {
        System.debug('Saumil say111...' +   ApexPages.currentPage().getParameters().get('id'));
        save();
    }
   
    public void Save(){
        System.debug('Saumil say...' +  ApexPages.currentPage().getParameters().get('id'));
    }
  
 }