({
    doInit : function(component, event, helper) {
            var canvas, ctx, flag = false,
            prevX = 0,
            currX = 0,
            prevY = 0,
            currY = 0,
            dot_flag = false;
       
        var x = "black",
            y = 2,
            w,h;
        canvas=component.find('can').getElement();
        var ratio = Math.max(window.devicePixelRatio || 1, 1);
        w = canvas.width*ratio;
        h = canvas.height*ratio;
        ctx = canvas.getContext("2d");
        console.log('ctx:='+ctx);
       
        canvas.addEventListener("mousemove", function (e) {
            findxy('move', e)
        }, false);
        canvas.addEventListener("mousedown", function (e) {
            findxy('down', e)
        }, false);
        canvas.addEventListener("mouseup", function (e) {
            findxy('up', e)
        }, false);
        canvas.addEventListener("mouseout", function (e) {
            findxy('out', e)
        }, false);
        // Set up touch events for mobile, etc
        canvas.addEventListener("touchstart", function (e) {
            var touch = e.touches[0];
            console.log('touch start:='+touch);
            var mouseEvent = new MouseEvent("mousedown", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas.dispatchEvent(mouseEvent);
             e.preventDefault();
        }, false);
        canvas.addEventListener("touchend", function (e) {
            var mouseEvent = new MouseEvent("mouseup", {});
            canvas.dispatchEvent(mouseEvent);
        }, false);
        canvas.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas.dispatchEvent(mouseEvent);
             e.preventDefault();
           
        }, false);
       
        // Get the position of a touch relative to the canvas
        function getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                x: touchEvent.touches[0].clientX - rect.left,
                y: touchEvent.touches[0].clientY - rect.top
            };
        }
       
        function findxy(res, e){
            const rect = canvas.getBoundingClientRect();
            if (res == 'down') {
                prevX = currX;
                prevY = currY;
                currX = e.clientX - rect.left ;
                currY = e.clientY -  rect.top;
               
                flag = true;
                dot_flag = true;
                if (dot_flag) {
                    ctx.beginPath();
                    ctx.fillStyle = x;
                    ctx.fillRect(currX, currY, 2, 2);
                    ctx.closePath();
                    dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                flag = false;
            }
            if (res == 'move') {
                if (flag) {
                    prevX = currX;
                    prevY = currY;
                    currX = e.clientX -  rect.left;
                    currY = e.clientY - rect.top;
                    draw(component,ctx);
                }
            }
        }
        function draw() {
            ctx.beginPath();
            ctx.moveTo(prevX, prevY);
            ctx.lineTo(currX, currY);
            ctx.strokeStyle = x;
            ctx.lineWidth = y;
            ctx.stroke();
            ctx.closePath();
        }
       
    },
    eraseHelper: function(component, event, helper){
        var m = confirm("Are you sure you want to clear?");
        if (m) {
            var canvas=component.find('can').getElement();
            var ctx = canvas.getContext("2d");
            var w = canvas.width;
            var h = canvas.height;
            ctx.clearRect(0, 0, w, h);
       }
    },
    getRecordData:function(component, event, helper) {
        /*var recordId = component.get("v.recordId");
        var action = component.get("c.getWireTransactionData");
        action.setParams({
            wiresId: recordId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            var response=res.getReturnValue();
            if(state==="SUCCESS"){
                component.set("v.wireDetail",response);
            }
        }); */      
       // $A.enqueueAction(action);
    },
    saveHelper:function(component, event, helper){         
        var recordId = component.get("v.EFTRecord.Id");
        var pad=component.find('can').getElement();
        var dataUrl = pad.toDataURL();
        console.log('dataUrl:='+dataUrl);
        var strDataURI=dataUrl.replace(/^data:image\/(png|jpg);base64,/, "");
        var action = component.get("c.saveSignature");
        action.setParams({
            signatureBody : strDataURI,
            EFTId: recordId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            var response=res.getReturnValue();
            if(state==="SUCCESS"){
                component.set("v.attachmentId",response);
                console.log(response);
                var eSignDiv=component.find("eSignDiv");
                $A.util.removeClass(eSignDiv, 'showdiv');
                $A.util.addClass(eSignDiv, 'hidediv');
        
        		var authwrapDiv=component.find("authwrap");
                $A.util.removeClass(authwrapDiv, 'hidediv');
                $A.util.addClass(authwrapDiv,'showdiv');
                
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:closeQuickAction').fire();
                
               $A.get('e.force:closeQuickAction').fire(); 
                
                var recordId = component.get("v.recordId");
                if(recordId != undefined)
               {
                var url = '/apex/eSignature?id=' + recordId;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url
                });
                urlEvent.fire();
                    }
             }
            component.set('v.loading', true);
        });       
        //$A.enqueueAction(action);
    },
     savePDF:function(component, event, helper){ 
        var recordId = component.get("v.recordId");
        var action = component.get("c.savePDF");
        action.setParams({
            wiresId: recordId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            var response=res.getReturnValue();
            if(state==="SUCCESS"){
                alert('PDF has been saved');
            }
        });       
       // $A.enqueueAction(action);
    }
})