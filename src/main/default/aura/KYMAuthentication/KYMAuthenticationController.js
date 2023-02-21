({
  doInit: function (component, event, helper) {
    var memberId = component.get("v.recordId");
        //var PublicWalletStatusForDay = component.get("v.PublicWalletStatusForDay");
        var IVRGUIDFromUrl = component.get("v.IVRGUIDFromUrl");
       

    component.set("v.IsSubmitClicked",false);
    component.set("v.selectedKYMvalue", 'Select');
    $A.util.addClass(elementSecureEmail, "hidden");
    var elementSecureEmail = component.find("SecureEmailCase").set("v.value",'');
   
    $A.util.addClass(elementSecureEmail, "hidden");
    var IsReLoadRequired;
    var IsUserSessionLoaded;
    var params = event.getParam('arguments');
        if (params) {
             IsReLoadRequired =  params.param2;
             IsUserSessionLoaded = params.param3;
            component.set("v.IsReLoadRequired", IsReLoadRequired);
            component.set("v.IsUserSessionLoaded", IsUserSessionLoaded);
        }

       if(IsUserSessionLoaded){

        helper.getDataOnLoad(component, event, helper, memberId, IVRGUIDFromUrl);
       } 

  },

  onChange: function (component, event, helper) {
    var selectedPicklistValue = component.get("v.selectedKYMvalue");
    component.set("v.selectedKYMvalue", selectedPicklistValue);
    var element;
    var errorElement = document.getElementById("errorSpan");
    element = component.find("Otherreason");
    var elementSecureEmail = component.find("SecureEmailCase");
    var elementDriverLicenseNo = component.find("DriverLicenseNo");
    var elementWorkBadgeNo = component.find("WorkBadgeNo");
    if (selectedPicklistValue == "Other") {
      $A.util.addClass(element, "show");
      $A.util.removeClass(element, "hidden");
      errorElement.classList.remove("show");
      errorElement.classList.add("hidden");
      $A.util.addClass(elementSecureEmail, "hidden");
      $A.util.addClass(elementDriverLicenseNo, "hidden");
      $A.util.addClass(elementWorkBadgeNo, "hidden");
      $A.util.removeClass(elementSecureEmail, "show");
      $A.util.removeClass(elementDriverLicenseNo, "show");
      $A.util.removeClass(elementWorkBadgeNo, "show");
    } else if (selectedPicklistValue == "Secure Email") {
      $A.util.addClass(elementSecureEmail, "show");
      $A.util.removeClass(elementSecureEmail, "hidden");
      errorElement.classList.remove("show");
      errorElement.classList.add("hidden");
      $A.util.addClass(element, "hidden");
      $A.util.addClass(elementDriverLicenseNo, "hidden");
      $A.util.addClass(elementWorkBadgeNo, "hidden");
      $A.util.removeClass(element, "show");
      $A.util.removeClass(elementDriverLicenseNo, "show");
      $A.util.removeClass(elementWorkBadgeNo, "show");
    } else if (
      selectedPicklistValue == "Drivers license/passport/state-issued ID"
    ) {
      $A.util.addClass(elementDriverLicenseNo, "show");
      $A.util.removeClass(elementDriverLicenseNo, "hidden");
      errorElement.classList.remove("show");
      errorElement.classList.add("hidden");
      $A.util.addClass(element, "hidden");
      $A.util.addClass(elementSecureEmail, "hidden");
      $A.util.addClass(elementWorkBadgeNo, "hidden");
      $A.util.removeClass(element, "show");
      $A.util.removeClass(elementSecureEmail, "show");
      $A.util.removeClass(elementWorkBadgeNo, "show");
    } else if (selectedPicklistValue == "Work badge") {
      $A.util.addClass(elementWorkBadgeNo, "show");
      $A.util.removeClass(elementWorkBadgeNo, "hidden");
      errorElement.classList.remove("show");
      errorElement.classList.add("hidden");
      $A.util.addClass(element, "hidden");
      $A.util.addClass(elementSecureEmail, "hidden");
      $A.util.addClass(elementDriverLicenseNo, "hidden");
      $A.util.removeClass(element, "show");
      $A.util.removeClass(elementSecureEmail, "show");
      $A.util.removeClass(elementDriverLicenseNo, "show");
    } else if (selectedPicklistValue == "Select") {
      errorElement.classList.add("show");
      errorElement.classList.remove("hidden");
      $A.util.removeClass(element, "show");
      $A.util.addClass(element, "hidden");
      $A.util.addClass(element, "hidden");
      $A.util.addClass(elementSecureEmail, "hidden");
      $A.util.addClass(elementDriverLicenseNo, "hidden");
      $A.util.removeClass(element, "show");
      $A.util.removeClass(elementSecureEmail, "show");
      $A.util.removeClass(elementDriverLicenseNo, "show");
      $A.util.addClass(elementWorkBadgeNo, "hidden");
      $A.util.removeClass(elementWorkBadgeNo, "show");
    } else {
      $A.util.removeClass(element, "show");
      $A.util.addClass(element, "hidden");
      $A.util.removeClass(elementSecureEmail, "show");
      $A.util.addClass(elementSecureEmail, "hidden");
      $A.util.removeClass(elementDriverLicenseNo, "show");
      $A.util.addClass(elementDriverLicenseNo, "hidden");
      $A.util.removeClass(elementWorkBadgeNo, "show");
      $A.util.addClass(elementWorkBadgeNo, "hidden");
      errorElement.classList.remove("show");
      errorElement.classList.add("hidden");
    }
  },

  saveKYMLog: function (component, event, helper) {
    var reason = component.get("v.selectedKYMvalue");
    var element = document.getElementById("errorSpan");
    var InputElement = "";
    var SecureEmailInputElement = "";
    var DriverLicenseInputElement = "";
    var WorkBadgeInputElement = "";
	var errorOtherSpaninput = document.getElementById("errorSpaninput");
	var errorSecureEmailSpaninput = document.getElementById("errorSecureEmailSpaninput");
	var errorDriverLicenseNoinput =document.getElementById("errorDriverLicenseNoinput");
	var errorWorkBadgeNoinput = document.getElementById("errorWorkBadgeNoinput");
    if (reason == "Select") {
      element.classList.add("show");
      element.classList.remove("hidden");
      errorOtherSpaninput.classList.add("hidden");
      errorOtherSpaninput.classList.remove("show");
      errorSecureEmailSpaninput.classList.add("hidden");
      errorSecureEmailSpaninput.classList.remove("show");
      errorDriverLicenseNoinput.classList.add("hidden");
      errorDriverLicenseNoinput.classList.remove("show");
      errorWorkBadgeNoinput.classList.add("hidden");
      errorWorkBadgeNoinput.classList.remove("show");
    } else if (reason == "Other") {
      InputElement = component.find("Otherreason").get("v.value");
      var errorSpaninput = document.getElementById("errorSpaninput");
      if (InputElement == "") {
        errorSpaninput.classList.add("show");
        errorSpaninput.classList.remove("hidden");
		errorSecureEmailSpaninput.classList.add("hidden");
        errorSecureEmailSpaninput.classList.remove("show");
        errorDriverLicenseNoinput.classList.add("hidden");
        errorDriverLicenseNoinput.classList.remove("show");
        errorWorkBadgeNoinput.classList.add("hidden");
        errorWorkBadgeNoinput.classList.remove("show");
      } else {
        errorSpaninput.classList.remove("show");
        errorSpaninput.classList.add("hidden");        
        helper.saveMethod(
          component,
          event,
          reason,
          element,
          InputElement,
          SecureEmailInputElement,
          DriverLicenseInputElement,
          WorkBadgeInputElement
        );
      }
    } else if (reason == "Secure Email") {
      SecureEmailInputElement = component
        .find("SecureEmailCase")
        .get("v.value");
		var SecureEmailEle = component
        .find("SecureEmailCase");
		var SecureEmailValidity = SecureEmailEle.checkValidity();
      var errorSpaninput = document.getElementById("errorSecureEmailSpaninput");
      if (SecureEmailInputElement == "") {
        errorSpaninput.classList.add("show");
        errorSpaninput.classList.remove("hidden");

		errorOtherSpaninput.classList.add("hidden");
        errorOtherSpaninput.classList.remove("show");
        errorDriverLicenseNoinput.classList.add("hidden");
        errorDriverLicenseNoinput.classList.remove("show");
        errorWorkBadgeNoinput.classList.add("hidden");
        errorWorkBadgeNoinput.classList.remove("show");
      } 
	  else if(SecureEmailValidity == false){

	  }
	  else {
        errorSpaninput.classList.remove("show");
        errorSpaninput.classList.add("hidden");
        helper.saveMethod(
          component,
          event,
          reason,
          element,
          InputElement,
          SecureEmailInputElement,
          DriverLicenseInputElement,
          WorkBadgeInputElement
        );
      }
    } else if (reason == "Drivers license/passport/state-issued ID") {
      DriverLicenseInputElement = component
        .find("DriverLicenseNo")
        .get("v.value");
      var errorSpaninput = document.getElementById("errorDriverLicenseNoinput");
      if (DriverLicenseInputElement == "") {
        errorSpaninput.classList.add("show");
        errorSpaninput.classList.remove("hidden");

		errorOtherSpaninput.classList.add("hidden");
        errorOtherSpaninput.classList.remove("show");
        errorSecureEmailSpaninput.classList.add("hidden");
        errorSecureEmailSpaninput.classList.remove("show");
        errorWorkBadgeNoinput.classList.add("hidden");
        errorWorkBadgeNoinput.classList.remove("show");
      } else {
        errorSpaninput.classList.remove("show");
        errorSpaninput.classList.add("hidden");
        helper.saveMethod(
          component,
          event,
          reason,
          element,
          InputElement,
          SecureEmailInputElement,
          DriverLicenseInputElement,
          WorkBadgeInputElement
        );
      }
    } else if (reason == "Work badge") {
      WorkBadgeInputElement = component.find("WorkBadgeNo").get("v.value");
      var errorSpaninput = document.getElementById("errorWorkBadgeNoinput");
      if (WorkBadgeInputElement == "") {
        errorSpaninput.classList.add("show");
        errorSpaninput.classList.remove("hidden");

		errorOtherSpaninput.classList.add("hidden");
        errorOtherSpaninput.classList.remove("show");
        errorSecureEmailSpaninput.classList.add("hidden");
        errorSecureEmailSpaninput.classList.remove("show");
        errorDriverLicenseNoinput.classList.add("hidden");
        errorDriverLicenseNoinput.classList.remove("show");
      } else {
        errorSpaninput.classList.remove("show");
        errorSpaninput.classList.add("hidden");
        helper.saveMethod(
          component,
          event,
          reason,
          element,
          InputElement,
          SecureEmailInputElement,
          DriverLicenseInputElement,
          WorkBadgeInputElement
        );
      }
    } else {
      helper.saveMethod(
        component,
        event,
        reason,
        element,
        InputElement,
        SecureEmailInputElement,
        DriverLicenseInputElement,
        WorkBadgeInputElement
      );
    }
  },
});