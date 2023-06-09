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
        
        debugger;
        cmp.set("v.pageNumber", 1);
        cmp.set('v.Alldata', null );
        var linklabel ;
        
        debugger;

        if(cmp.get('v.selectedCheckBoxes')== 'OOW'){
            linklabel = 'Log';
        }
        else if(cmp.get('v.selectedCheckBoxes')== 'Wires' || cmp.get('v.selectedCheckBoxes')== 'Wires Transactions'){
            linklabel = 'View';
        }
        else {
            
            linklabel= 'Download';
        }
       
        
        cmp.set('v.columns', [
            {label: 'Source',fieldName: 'DataSource',type:'text', initialWidth: 130},
            {label: 'Description', fieldName: 'dateDesc',type:'text',sortable : true,initialWidth: 300, wrapText:true},
            {label: 'Date', fieldName: 'documentDate',type:'date-local',sortable : true,initialWidth: 110,typeAttributes: {day: '2-digit',
                                                                                                                     month: '2-digit',
                                                                                                                     year: 'numeric',
                                                                                                                    }},
            {label: 'Member', fieldName: 'MemberName',type:'text',sortable : true,initialWidth: 200},
            {label: 'Account # ',fieldName: 'Account',type:'text',sortable : true,initialWidth: 110},
            
            {label: 'Case #' ,fieldName: 'caseLink',type:'url',initialWidth: 130,typeAttributes: { label:{fieldName:'caseLinkLabel'}, target:'_blank'}},
            {label: 'Link',fieldName:'hyperlinkPDF',type: 'url', typeAttributes: { label: linklabel, target:'_blank'}},
          // {label: 'Wire Status',fieldName: 'wirestatus',type:'text', initialWidth: 200},
        ]);


       
           
            cmp.set('v.loadchk1', false);
            cmp.set('v.loadchk2', false);
            cmp.set('v.loadchk3', false);
            cmp.set('v.loadchk5', false);
            cmp.set('v.loadchk6', false);
            cmp.set('v.loadchk7', false);
            cmp.set('v.loadchk8', false);
            cmp.set('v.loadchk9', false);
            cmp.set('v.loadchk10', false);
            cmp.set('v.loadchk11', false);
            
            cmp.set('v.nochk1', false);
            cmp.set('v.nochk2', false);
            cmp.set('v.nochk3', false);
            cmp.set('v.nochk5', false);
            cmp.set('v.nochk6', false);
            cmp.set('v.nochk7', false);
            cmp.set('v.nochk8', false);
            cmp.set('v.nochk9', false);
            cmp.set('v.nochk10', false);
            cmp.set('v.nochk11', false);
            
            var paramVal=cmp.get('v.selectedCheckBoxes');
            var todate=cmp.get('v.todate');
            var fromdate=cmp.get('v.fromdate');
            var keyword =cmp.get('v.keyword');
            
            if(fromdate == ""){
            	fromdate = null;
            }
            if(todate == ""){
            	todate = null;
            }
            if(keyword == ""){
                keyword = null;
            }
            var recid=cmp.get('v.pageReference.state.c__id');
            if(recid == null || recid == ''){
            	recid =cmp.get('v.recordId');
            }
            
            if(cmp.get('v.ischk1')){
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
                            var obj = a.getReturnValue();
                            var alldata = cmp.get('v.Alldata');
            				var isRestricteAccess = false;                            
                                        var result = JSON.parse(JSON.stringify(obj));
            				if(alldata != null && alldata.length > 0){
                            	isRestricteAccess = alldata[0].EmployeeRestictedAccess;
                            }
                            else{
                				if(result.length > 0)
                            		isRestricteAccess = result[0].EmployeeRestictedAccess;
                            }
                            if(result != null && result != ''){
                                if(alldata != null){
                                    var x = parseInt(alldata.length);
                                    for(var a in result){
                                        x += 1;
                                        alldata.push(result[a]);
                                    }
                                    cmp.set('v.Alldata',alldata ); 
                                }
                                else{
                                    cmp.set('v.Alldata',result );
                                }
                                
                                debugger;
                                cmp.set('v.loadchk1',true);
                                if(isRestricteAccess){
                                    cmp.set('v.columns', [
                                        {label: 'Source',fieldName: 'DataSource',type:'text', initialWidth: 130},
                                        {label: 'Description', fieldName: 'dateDesc',type:'text',sortable : true,initialWidth: 300, wrapText:true},
                                        {label: 'Date', fieldName: 'documentDate',type:'date-local',sortable : true,initialWidth: 110,typeAttributes: {day: '2-digit',
                                                                                                                                                 month: '2-digit',
                                                                                                                                                 year: 'numeric',
                                                                                                                                                }},
                                        {label: 'Member', fieldName: 'MemberName',type:'text',sortable : true,initialWidth: 200},
                                        {label: 'Account # ',fieldName: 'Account',type:'text',sortable : true,initialWidth: 110},
                                        
                                        {label: 'Case #' ,fieldName: 'caseLink',type:'url',initialWidth: 130,typeAttributes: { label:{fieldName:'caseLinkLabel'}, target:'_blank'}},
                                        {label: 'Link',fieldName:'hyperlinkPDF',type: 'text'},
                                        //{label: 'Wire Status', fieldName: 'wirestatus',type:'text',initialWidth: 200},

                                    ]);
                                }
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
			}
			if(cmp.get('v.ischk1') && cmp.get('v.ischk3')){
    			if(cmp.find('chk3').get("v.checked") && cmp.find('chk1').get("v.checked") ){
        			cmp.set('v.progchk3', true );
        			setTimeout(function(){
            			helper.fetchchk3(cmp, event, helper,paramVal,fromdate,todate,recid,keyword); 
        			},5);
    			}
    			else if(cmp.find('chk3').get("v.checked") && !cmp.find('chk1').get("v.checked")){
        			cmp.set('v.progchk3', true );				   
        			helper.fetchchk3(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);  
    			}
			}
			else if(cmp.get('v.ischk3')){
    			if(cmp.find('chk3').get("v.checked")){
        			cmp.set('v.progchk3', true );				   
        			helper.fetchchk3(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);  
    			}
			}
			if(cmp.get('v.ischk2') && cmp.get('v.ischk3')){
    			if(cmp.find('chk2').get("v.checked") &&  cmp.find('chk3').get("v.checked")){
        			cmp.set('v.progchk2', true );
        			setTimeout(function(){
                    	helper.fetchchk2(cmp, event, helper,paramVal,fromdate,todate,recid,keyword); 
        			},10);
        
    			}
    			else if(cmp.find('chk2').get("v.checked") &&  !cmp.find('chk3').get("v.checked")){
        			cmp.set('v.progchk2', true );
        			helper.fetchchk2(cmp, event, helper,paramVal,fromdate,todate,recid,keyword); 
            	}
			}
			else if(cmp.get('v.ischk2') && cmp.get('v.ischk1')){
    			if(cmp.find('chk2').get("v.checked") && cmp.find('chk1').get("v.checked") ){
                    cmp.set('v.progchk2', true );
        			setTimeout(function(){	          
            			helper.fetchchk2(cmp, event, helper,paramVal,fromdate,todate,recid,keyword); 
        			},10);
        		}
    			else if(cmp.find('chk2').get("v.checked") &&  !cmp.find('chk1').get("v.checked")){
                	cmp.set('v.progchk2', true );
        			helper.fetchchk2(cmp, event, helper,paramVal,fromdate,todate,recid,keyword); 
        		}
			}
    		else if(cmp.get('v.ischk2')){
        		if(cmp.find('chk2').get("v.checked")){          
            		cmp.set('v.progchk2', true );
            		helper.fetchchk2(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
        		} 
    		}
			if(cmp.get('v.ischk5')){
    	        if(cmp.find('chk5').get("v.checked")){          
        	    	cmp.set('v.progchk5', true );
            		helper.fetchchk5(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
            	} 
    		}
    		if(cmp.get('v.ischk6')){
        		if(cmp.find('chk6').get("v.checked")){          
            		cmp.set('v.progchk6', true );
            		helper.fetchchk6(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
        		} 
    		}
    		if(cmp.get('v.ischk7')){
        		if(cmp.find('chk7').get("v.checked")){          
            		cmp.set('v.progchk7', true );
            		helper.fetchchk7(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
        		} 
    		}	
        	/*if(cmp.get('v.ischk8')){
            	if(cmp.find('chk8').get("v.checked")){          
                	cmp.set('v.progchk8', true );
                	helper.fetchchk8(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
            	} 
        	}*/
            if(cmp.get('v.ischk8')){
            	if(cmp.find('chk8').get("v.checked")){ 
                    cmp.set('v.progchk8', true );
                    var action = cmp.get('c.GetWiresData'); 
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
            				var isRestricteAccess = false;                            
                                        var result = JSON.parse(JSON.stringify(obj));
            				/*if(alldata != null && alldata.length > 0){
                            	isRestricteAccess = alldata[0].EmployeeRestictedAccess;
                            }
                            else{
                				if(result.length > 0)
                            		isRestricteAccess = result[0].EmployeeRestictedAccess;
                            }*/
                            if(result != null && result != ''){
                                if(alldata != null){
                                    var x = parseInt(alldata.length);
                                    for(var a in result){
                                        x += 1;
                                        alldata.push(result[a]);
                                    }
                                    cmp.set('v.Alldata',alldata ); 
                                }
                                else{
                                    cmp.set('v.Alldata',result );
                                }
                                
                                debugger;
                                cmp.set('v.loadchk8',true);
                               // if(isRestricteAccess){
                                    cmp.set('v.columns', [
                                        {label: 'Source',fieldName: 'DataSource',type:'text', initialWidth: 130},
                                        {label: 'Description', fieldName: 'dateDesc',type:'text',sortable : true,initialWidth: 300, wrapText:true},
                                        {label: 'Date', fieldName: 'documentDate',type:'date-local',sortable : true,initialWidth: 110,typeAttributes: {day: '2-digit',
                                                                                                                                                 month: '2-digit',
                                                                                                                                                 year: 'numeric',
                                                                                                                                                }},
                                        {label: 'Member', fieldName: 'MemberName',type:'text',sortable : true,initialWidth: 200},
                                        {label: 'Account # ',fieldName: 'Account',type:'text',sortable : true,initialWidth: 110},
                                        
                                        {label: 'Case #' ,fieldName: 'caseLink',type:'url',initialWidth: 130,typeAttributes: { label:{fieldName:'caseLinkLabel'}, target:'_blank'}},
                                        {label: 'Link',fieldName:'hyperlinkPDF',type: 'url', typeAttributes: { label: linklabel, target:'_blank'}},
                                        {label: 'Wire Status', fieldName: 'wirestatus',type:'text',initialWidth: 200},
 
                                    ]);
                                //}
                            }
                            else{
                                cmp.set('v.nochk1', true); 
                            }
                            helper.getData(cmp, event, helper);
                            cmp.set('v.Approve', true);
                            cmp.set('v.progchk8', false );
                        }
					});

					$A.enqueueAction(action);                
				}	
			}
            
        	if(cmp.get('v.ischk9')){
            	if(cmp.find('chk9').get("v.checked")){          
                	cmp.set('v.progchk9', true );
                	helper.fetchchk9(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
            	} 
        	}
            if(cmp.get('v.ischk10')){
                if(cmp.find('chk10').get("v.checked")){          
                    cmp.set('v.progchk10', true );
                    helper.fetchchk10(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
                } 
            }
			/*if(cmp.get('v.ischk11')){
                if(cmp.find('chk11').get("v.checked")){          
                    cmp.set('v.progchk11', true );
                    helper.fetchchk11(cmp, event, helper,paramVal,fromdate,todate,recid,keyword);    
                } 
            }*/
            if(cmp.get('v.ischk11')){
            	if(cmp.find('chk11').get("v.checked")){ 
                    cmp.set('v.progchk11', true );
                    var action = cmp.get('c.GetBDIestatements'); 
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
            				var isRestricteAccess = false;                            
                                        var result = JSON.parse(JSON.stringify(obj));
            				if(alldata != null && alldata.length > 0){
                            	isRestricteAccess = alldata[0].EmployeeRestictedAccess;
                            }
                            else{
                				if(result.length > 0)
                            		isRestricteAccess = result[0].EmployeeRestictedAccess;
                            }
                            if(result != null && result != ''){
                                if(alldata != null){
                                    var x = parseInt(alldata.length);
                                    for(var a in result){
                                        x += 1;
                                        alldata.push(result[a]);
                                    }
                                    cmp.set('v.Alldata',alldata ); 
                                }
                                else{
                                    cmp.set('v.Alldata',result );
                                }
                                
                                debugger;
                                cmp.set('v.loadchk11',true);
                                if(isRestricteAccess){
                                    cmp.set('v.columns', [
                                        {label: 'Source',fieldName: 'DataSource',type:'text', initialWidth: 130},
                                        {label: 'Description', fieldName: 'dateDesc',type:'text',sortable : true,initialWidth: 300, wrapText:true},
                                        {label: 'Date', fieldName: 'documentDate',type:'date-local',sortable : true,initialWidth: 110,typeAttributes: {day: '2-digit',
                                                                                                                                                 month: '2-digit',
                                                                                                                                                 year: 'numeric',
                                                                                                                                                }},
                                        {label: 'Member', fieldName: 'MemberName',type:'text',sortable : true,initialWidth: 200},
                                        {label: 'Account # ',fieldName: 'Account',type:'text',sortable : true,initialWidth: 110},
                                        
                                        {label: 'Case #' ,fieldName: 'caseLink',type:'url',initialWidth: 130,typeAttributes: { label:{fieldName:'caseLinkLabel'}, target:'_blank'}},
                                        {label: 'Link',fieldName:'hyperlinkPDF',type: 'text'},
                                        //{label: 'Wire Status', fieldName: 'wirestatus',type:'text',initialWidth: 200},
 
                                    ]);
                                }
                            }
                            else{
                                cmp.set('v.nochk1', true); 
                            }
                            helper.getData(cmp, event, helper);
                            cmp.set('v.Approve', true);
                            cmp.set('v.progchk11', false );
                        }
					});

					$A.enqueueAction(action);                
				}	
			}
	},  
    MergeData: function ( cmp, event, helper){
        
        helper.getData(cmp, event, helper);        
        cmp.set('v.loadchk2', true); 
        cmp.set('v.isSalesforce', false); 
        cmp.set('v.Approve', true);
        cmp.set('v.progchk2', false);
        
    },      
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
    },
                    
    fetchchk5: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
        var action = cmp.get('c.GetOOWData'); 
        action.setParams({
            fromdate : fromdate,
            todate : todate,
            keyword:keyword,
            recid:recid,
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
                    cmp.set('v.loadchk5',true);
                }
                else{
                    cmp.set('v.nochk5', true); 
                }
                helper.getData(cmp, event, helper);
                cmp.set('v.Approve', true);
                cmp.set('v.progchk5', false );
            }            
        }); 
        $A.enqueueAction(action);  
    },
    
   fetchchk6: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
       var action = cmp.get('c.GetMCPingChangeData'); 
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
                   cmp.set('v.loadchk6',true);
               }
               else{
                   cmp.set('v.nochk6', true); 
               }
               helper.getData(cmp, event, helper);
               cmp.set('v.Approve', true);
               cmp.set('v.progchk6', false );               
           }           
       }); 
       $A.enqueueAction(action);      
   },
   
	fetchchk7: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
        var action = cmp.get('c.GetMCLimitChangeData'); 
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
                    cmp.set('v.loadchk7',true);
                }
                else{
                    cmp.set('v.nochk7', true); 
                }
                helper.getData(cmp, event, helper);
                cmp.set('v.Approve', true);
                cmp.set('v.progchk7', false );                
            }            
        }); 
        $A.enqueueAction(action);      
    },
    
	fetchchk8: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
        var action = cmp.get('c.GetWiresData'); 
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
                    cmp.set('v.loadchk8',true);
                }
                else{
                    cmp.set('v.nochk8', true); 
                }
                helper.getData(cmp, event, helper);
                cmp.set('v.Approve', true);
                cmp.set('v.progchk8', false );                
            }            
        }); 
        $A.enqueueAction(action);      
    },
                                    
    fetchchk9: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
        var action = cmp.get('c.GetNotesData'); 
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
                    cmp.set('v.loadchk9',true);
                }
                else{
                    cmp.set('v.nochk9', true); 
                }
                helper.getData(cmp, event, helper);
                cmp.set('v.Approve', true);
                cmp.set('v.progchk9', false );                
            }            
        }); 
        $A.enqueueAction(action);      
    },
        
    fetchchk10: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
        var action = cmp.get('c.GetWiresEDSData'); 
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
                    cmp.set('v.loadchk10',true);
                }
                else{
                    cmp.set('v.nochk10', true); 
                }
                helper.getData(cmp, event, helper);
                cmp.set('v.Approve', true);
                cmp.set('v.progchk10', false );                
            }            
        }); 
        $A.enqueueAction(action);      
    },

	fetchchk11: function (cmp, event, helper,paramVal,fromdate,todate,recid,keyword) {
        var action = cmp.get('c.GetBDIestatements'); 
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
                    cmp.set('v.loadchk11',true);
                }
                else{
                    cmp.set('v.nochk11', true); 
                }
                helper.getData(cmp, event, helper);
                cmp.set('v.Approve', true);
                cmp.set('v.progchk11', false );                
            }            
        }); 
        $A.enqueueAction(action);      
    },
    
    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	}
})