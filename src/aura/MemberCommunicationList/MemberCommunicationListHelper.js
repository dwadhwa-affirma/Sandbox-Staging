({
    getData : function(component, event, helper) {
        
        var data = [];
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
        
        var allData = component.get("v.Alldata"); 
        
        if(allData != null && allData != ''){    
         component.set('v.dataSize',allData.length);
	        var x= (pageNumber-1)*pageSize; 
	        var xl = parseInt(x) + parseInt(pageSize);
	        
	        if(allData.length < xl)
	           xl =  allData.length;     
	        //creating data-table data
	       
	        component.set("v.isLastPage",false);
	        for(var i = x ; i < xl ; i++){
	            
	                data.push(allData[i]);
	                if(i == allData.length-1){
	                    component.set("v.isLastPage",true);
	                    break;
	                }
	        }
	           component.set('v.nodata', false);
	       }
	       else{
	      
	          component.set('v.nodata', true);
	       }
	        component.set("v.data", data);
	        
	     
        
        component.set('v.loaded', false);
       
        
    },
      sortData: function (cmp, fieldName, sortDirection,event, helper) {
        var data = cmp.get("v.Alldata");
        var reverse = sortDirection !== 'asc';

        data = Object.assign([],
            data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        cmp.set("v.Alldata", data);
        helper.getData(cmp,event, helper)
        
    },
    sortBy: function (field, reverse, primer) {
    
        var key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };
        
        return function (a, b) {
            var A = key(a) ? key(a).toLowerCase() : '';
            var B = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((A > B) - (B > A));
        };
    },
    fetchAllData: function (cmp, event, helper) {
       
        cmp.set("v.pageNumber", 1);
        cmp.set('v.Alldata', null );
        cmp.set('v.columns', [
        	{label: 'Source',fieldName: 'DataSource',type:'text',initialWidth: 130},
            {label: 'Description', fieldName: 'dateDesc',type:'text',sortable : true,initialWidth: 400},
            {label: 'Date', fieldName: 'documentDate',type:'date',sortable : true,initialWidth: 150,typeAttributes: {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',  
                minute: '2-digit',  
                hour12: false
                
            },},
            {label: 'Member', fieldName: '',type:'text',sortable : true,initialWidth: 200},
           
            {label: 'Account # ',fieldName: 'Account',type:'text',initialWidth: 150},
            {label: 'Case #' ,fieldName: '',type:'text',initialWidth: 150},
            {label: 'Link', fieldName: 'hyperlinkPDF',type: 'url', typeAttributes: { label: 'Download'}},
            
        ]);
            cmp.set('v.loadchk1', false);
            cmp.set('v.loadchk2', false);
            cmp.set('v.loadchk3', false);
             cmp.set('v.nochk1', false);
            cmp.set('v.nochk2', false);
            cmp.set('v.nochk3', false);
            var paramVal=cmp.get('v.selectedCheckBoxes');
            var todate=cmp.get('v.todate');
            var fromdate=cmp.get('v.fromdate');
            var keyword =cmp.get('v.keyword');
            
            if(fromdate == "")
            {
            	fromdate = null;
            }
            if(todate == "")
            {
            	todate = null;
            }
            if(keyword == "")
            {
            	keyword = null;
            }
            var recid=cmp.get('v.pageReference.state.c__id');
            if(recid == null || recid == '')
            {
            recid =cmp.get('v.recordId');
            }
                       
            if(cmp.find('chk1').get("v.checked")){ 
                    cmp.set('v.progchk1', true );
                 	var action = cmp.get('c.GetMemberCommData'); 
			        action.setParams({
			            source : paramVal,
			            fromdate : fromdate,
			            todate : todate,
			            recid:recid,
			            keyword:keyword
			        });     
			        action.setCallback(this, function(a){
			            var state = a.getState(); // get the response state
			              
			            if(state == 'SUCCESS') {
			            
			            /*    var obj = a.getReturnValue();
			                var jsonString = JSON.parse(JSON.stringify(obj));
			                if(jsonString != null && jsonString != ''){
				                cmp.set('v.Alldata',jsonString );                  
				                
				                cmp.set('v.loadchk1', true); 
				                
				                }         
			               else{
			                cmp.set('v.nochk1', true); 
			                
			               }
			               helper.getData(cmp, event, helper);    
			               cmp.set('v.Approve', true);   
			               cmp.set('v.progchk1', false);   */
			               
			                var obj = a.getReturnValue();
			                var alldata = cmp.get('v.Alldata');
			                var result = JSON.parse(JSON.stringify(obj));
			                    if(result != null && result != ''){
				            		if(alldata != null){
				                        var x = parseInt(alldata.length);
				                        for(var a in result){
				                            x += 1;
				                            alldata.push(result[a]);
				    					}
				                        cmp.set('v.Alldata',alldata ); 
									}
									else {
									
									    cmp.set('v.Alldata',result );
									}
									cmp.set('v.loadchk1',true);
								}
								else{
									cmp.set('v.nochk1', true); 
								}
								helper.getData(cmp, event, helper);
								cmp.set('v.Approve', true);
								cmp.set('v.progchk1', false );
			            }
			        });
			            
			        $A.enqueueAction(action);                
            }
			if(cmp.find('chk3').get("v.checked") && cmp.find('chk1').get("v.checked") ){
			      cmp.set('v.progchk3', true );
				    setTimeout(function(){
	                	helper.fetchchk3(cmp, event, helper,paramVal,fromdate,todate,recid,keyword); 
	                },5);
				 
			}
			if(cmp.find('chk3').get("v.checked") && !cmp.find('chk1').get("v.checked") ){
			      cmp.set('v.progchk3', true );				   
	              helper.fetchchk3(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);  
			}
			if(cmp.find('chk2').get("v.checked") && (cmp.find('chk1').get("v.checked") || cmp.find('chk3').get("v.checked"))){
                
                cmp.set('v.progchk2', true );
                setTimeout(function(){

                	helper.fetchchk2(cmp, event, helper,paramVal,fromdate,todate,recid,keyword); 
                },10);
               
            }
            else if(cmp.find('chk2').get("v.checked") && !cmp.find('chk1').get("v.checked") && !cmp.find('chk3').get("v.checked")){          
            	cmp.set('v.progchk2', true );
                helper.fetchchk2(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
                
            } 
	} ,  
    MergeData: function ( cmp, event, helper){
      
        helper.getData(cmp, event, helper);        
        cmp.set('v.loadchk2', true); 
        cmp.set('v.isSalesforce', false); 
        cmp.set('v.Approve', true);
        cmp.set('v.progchk2', false);
        
       
            
    } ,      
    fetchchk1: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) { 
        
        var action = cmp.get('c.GetMemberCommData'); 
        action.setParams({
            source : paramVal,
            fromdate : fromdate,
            todate : todate,
            recid:recid,
            keyword:keyword
        });     
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
              
            if(state == 'SUCCESS') {
                var obj = a.getReturnValue();
                var jsonString = JSON.parse(JSON.stringify(obj));
                if(jsonString != null && jsonString != ''){
	                cmp.set('v.Alldata',jsonString );                  
	                
	                cmp.set('v.loadchk1', true); 
	                
	                }         
               else{
                cmp.set('v.nochk1', true); 
                
               }
               helper.getData(cmp, event, helper);    
               cmp.set('v.Approve', true);      
            }
        });
            
        $A.enqueueAction(action);
	},
	 fetchchk3: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) { 
        var action = cmp.get('c.GetBDICommData'); 
        action.setParams({
            source : paramVal,
            fromdate : fromdate,
            todate : todate,
            recid:recid,
            keyword:keyword
        });     
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
              
            if(state == 'SUCCESS') {
                var obj = a.getReturnValue();
                var alldata = cmp.get('v.Alldata');
                var result = JSON.parse(JSON.stringify(obj));
                    if(result != null && result != ''){
	            		if(alldata != null ){
	                        var x = parseInt(alldata.length);
	                        for(var a in result){
	                            x += 1;
	                            alldata.push(result[a]);
	    					}
	                        cmp.set('v.Alldata',alldata );   							
	                       
						}
						else {
						
						    cmp.set('v.Alldata',result ); 				
							
						}   
						cmp.set('v.loadchk3', true);       
					} 
					else{
						cmp.set('v.nochk3', true); 
					}
                cmp.set('v.Approve', true); 
                helper.getData(cmp, event, helper); 
                cmp.set('v.progchk3', false); 
                    
            }
        });
            
        $A.enqueueAction(action);
	},
	fetchchk2: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
		var action = cmp.get('c.GetSalesforceData'); 
        action.setParams({
            source : paramVal,
            fromdate : fromdate,
            todate : todate,
            recid:recid,
            keyword:keyword
        });        
      	action.setCallback(this, function(a){       
       	var state = a.getState(); // get the response state          
           	if(state == 'SUCCESS') {
            
                var obj = a.getReturnValue();
                var alldata = cmp.get('v.Alldata');
                var result = JSON.parse(JSON.stringify(obj));
                    if(result != null && result != ''){
	            		if(alldata != null){
	                        var x = parseInt(alldata.length);
	                        for(var a in result){
	                            x += 1;
	                            alldata.push(result[a]);
	    					}
	                        cmp.set('v.Alldata',alldata ); 
						}
						else {
						
						    cmp.set('v.Alldata',result );
						}
						cmp.set('v.loadchk2',true);
					}
					else{
						cmp.set('v.nochk2', true); 
					}
					helper.getData(cmp, event, helper);
					cmp.set('v.Approve', true);
					cmp.set('v.progchk2', false );
					
				}
                
                }); 
			$A.enqueueAction(action);
               
            
	}
})