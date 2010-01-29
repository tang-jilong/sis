/**
 * @author ibm
 */
var gPopupMask = null;
var gPopupContainer = null;

/**
 * Initializes popup code on load.	
 */
function sis_initPopUp() {
	// Add the HTML to the body
	s_theBody = document.getElementsByTagName('BODY')[0];
	s_popmask = document.createElement('div');
	s_popmask.id = 's_popupMask';
	s_popcont = document.createElement('div');
	s_popcont.id = 's_popupContainer';
	s_popcont.innerHTML = ''+'<div id="uploadprogressbar">'+'</div>';
	s_theBody.appendChild(s_popmask);
	s_theBody.appendChild(s_popcont);
	
	s_gPopupMask = document.getElementById("s_popupMask");
	s_gPopupContainer = document.getElementById("s_popupContainer");
}

addEvent(window, "load", sis_initPopUp);

function sis_showPopWin() {
	// show or hide the window close widget
	s_gPopupMask.style.display = "block";
	s_gPopupContainer.style.display = "block";
	s_gPopupContainer.style.width = 120 + "px";
	s_gPopupContainer.style.height =16 + "px";	
	sis_centerPopWin();
	setMaskSize();
}

function sis_centerPopWin(width, height) {
	if (gPopupIsShown == true) {
		if (width == null || isNaN(width)) {
			width = s_gPopupContainer.offsetWidth;
		}
		if (height == null) {
			height = s_gPopupContainer.offsetHeight;
		}
		//var theBody = document.documentElement;
		var s_theBody = document.getElementsByTagName("BODY")[0];
		//theBody.style.overflow = "hidden";
		var scTop = parseInt(getScrollTop(),10);
		var scLeft = parseInt(s_theBody.scrollLeft,10);
		setMaskSize();
		//window.status = gPopupMask.style.top + " " + gPopupMask.style.left + " " + gi++;
		
		//var titleBarHeight = parseInt(document.getElementById("popupTitleBar").offsetHeight, 10);
		
		var fullHeight = getViewportHeight();
		var fullWidth = getViewportWidth();
		
		s_gPopupContainer.style.top = (scTop + ((fullHeight - height) / 2)) + "px";
		s_gPopupContainer.style.left =  (scLeft + ((fullWidth - width) / 2)) + "px";
		//alert(fullWidth + " " + width + " " + gPopupContainer.style.left);
	}
}

/**************FILTER VALIDATION*********************/
jQuery(document).ready(function(){
	/************ Bonus Filter Validation *********/
	jQuery("#bonus_filter_form").validate({
		rules: {
			
			"bonus[fDate]": {
				required: true,
			},
			
			"bonus[eDate]": {
				required: true,
			},
			
			"bonus[type_name]": {
				required: true,
			}
		},
		
	  messages: {
	  		"bonus[fDate]": {
				required: "Please select a From Date",					
			},
			"bonus[eDate]": {
				required: "Please select a End Date",					
			}
	  },
		
	 submitHandler: function(form) {
//            alert("submitted!");
                form.submit();
        }	
	})
	
	/*************** Comparator Validation *********/
	jQuery("#add_user_form").validate({
		rules: {
			"user[fDate]": {
				required: true,
			},
			
			"user[eDate]": {
				required: true,
			},
			
		},
		
	  messages: {
	  		"user[fDate]": {
				required: "Please select a From Date",					
			},
			"user[eDate]": {
				required: "Please select a End Date",					
			}
	  },
		
	 submitHandler: function(form) {
//	 	Element.show('indicator');
            //alert("submitted!");
                form.submit();
//				showPopWin('/comparator/add_to_comparator_ajax', 800, 500, null, true);
        }	
	})
	/*************** Insurance Filter Validation *********/
	jQuery("#insurance_filter_form").validate({
		rules: {
			"sal[fDate]": {
				required: true,
			},
			
			"sal[eDate]": {
				required: true,
			},
			
		},
		
	  messages: {
	  		"sal[fDate]": {
				required: "Please select a From Date",					
			},
			"sal[eDate]": {
				required: "Please select a End Date",					
			}
	  },
		
	 submitHandler: function(form) {
//	 	Element.show('indicator');
            //alert("submitted!");
                form.submit();
        }	
	})
	
	/*************** Salary Filter Validation *********/
	jQuery("#salary_filter_form").validate({
		rules: {
			"salary[fDate]": {
				required: true,
			},
			
			"salary[eDate]": {
				required: true,
			},
			
		},
		
	  messages: {
	  		"salary[fDate]": {
				required: "Please select a From Date",					
			},
			"salary[eDate]": {
				required: "Please select a End Date",					
			}
	  },
		
	 submitHandler: function(form) {
//	 	Element.show('indicator');
//            alert("submitted!");
                form.submit();
        }	
	})
	
	/************ Department Summary Validation***********/
	jQuery("#dept_summary_form").validate({
		rules: {
			"salary[fDate]": {
				required: true,
			},
			
			"salary[eDate]": {
				required: true,
			},
			
		},
		
	  messages: {
	  		"salary[fDate]": {
				required: "Please select a From Date",					
			},
			"salary[eDate]": {
				required: "Please select a End Date",					
			}
	  },
		
	 submitHandler: function(form) {
//	 	Element.show('indicator');
//            alert("submitted!");
                form.submit();
        }	
	})
});
    

/**************FILTER VALIDATION END*********************/

