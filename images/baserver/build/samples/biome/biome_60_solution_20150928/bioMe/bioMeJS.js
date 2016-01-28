define(['cdf/lib/jquery'], function($) {
    
    // display at top left corner
    var mastheadContent = 
    '<div class="col-xs-12">'+
    '   <div id="logoObj" class="logoObj ">'+
    '       <div id="imgPh" class="imgPh ">'+
    '       </div>'+
    '   </div>'+
    '</div>';
    
    // append contents to html
    $('#logoRow').html(mastheadContent);
    
    
    var overlayMessage = 
    '<div>'+
    	'<div id="overlayMessage" class="overlayMessage">'+
    		'<div id="overlayHeaderRow" class="row clearfix ">'+
    			'<div class="col-xs-12 last">'+
    				'<div id="overlayHeaderObj" class="overlayHeader ">Welcome to the BioMe Data Portal</div>'+
    			'</div>'+
    		'</div>'+
    		'<div id="overlayText" class="row clearfix ">'+
    			'<div class="col-xs-12 last">'+
    				'<div id="overlayTextObj" class="overlayText ">'+
    					'<p>BioMe provides connected <b>health/fitness monitoring devices</b> to consumers for improved well-being,and the company has recently allowed healthcare organizations to subscribe to its device analytics via a cloud data service.</p>'+
    					'<p>Here a hospital analyst blends BioMe data with <b>Electronic Health Record</b> (EHR) data to identify populations experiencing health improvements from personal device usage. By analyzing individuals who opted into sharing their device data, the hospital will be able to target outreach campaigns at groups who stand to benefit the most from device usage.</p>'+
    					'<p>This app is run using <b>Pentaho\'s \'Virtual\' blending</b> capability, creating a governed set of device and EHR data on the fly wihtout staging the data or bringing it into the secure EHR repository. This promotes governance and security as the data is not persisted, reducing future risk.</p>'+
    					'<p>Feel free to play around with the main dashboard showcasing this architected blend of data</p>'+
    				'</div>'+
    			'</div>'+
    			'<div id="overlayNote" class="row clearfix ">'+
    			'<div class="col-xs-12 last">'+
    				'<div id="overlayFootnoteObj" class="overlayFootnote ">'+
    					'<p><b>Note:</b> The data and information displayed in this dashboard is for demonstration purposes only. The figures have been randomly generated and are not based on any survey or research</p>'+
    				'</div>'+
    			'</div>'+
    		'</div>'+
    		'</div>'+
    	'</div>'+
    '</div>' ;
    
    $('#overlayMessageObj').html(overlayMessage);
    
    // About message we want to present
    var aboutMsg = '<a>About</a>';
    
    //append to html
    $('.aboutClass').html(aboutMsg);
    
    // display message dialog
    $('.aboutClass').click(function(){
        $('#overlayMessage').dialog({
            resizable: false,
            height:600,
            width:500,
            modal: true,
            dialogClass: "clickoncloseoutside",
            buttons: {
                "Proceed": function() {
                  $( this ).dialog( "close" );
                }
            },
            
            
            create:function () {
            $(this).closest(".ui-dialog")
                .find(".ui-button:first") // the first button
                .addClass("proceedClass");
            }
        });
    });
    
    $(document).ready(function(){
        $('#overlayMessage').dialog({
            resizable: false,
            height:600,
            width:500,
            modal: true,
            dialogClass: "clickoncloseoutside",
            buttons: {
                "Proceed": function() {
                  $( this ).dialog( "close" );
                }
            },
            create:function () {
            $(this).closest(".ui-dialog")
                .find(".ui-button:first") // the first button
                .addClass("proceedClass");
            }
        });
        
    $("body").on("click", "div.ui-widget-overlay:visible", function() {
        $(".ui-dialog.clickoncloseoutside:visible").find(".ui-dialog-content").dialog("close");
        });
    });
});