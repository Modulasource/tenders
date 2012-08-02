var FeaturesUpload = {
	swfUploadLoaded: function () {
		FeaturesUpload.SU = this;
	},
	iCurrentIndex:0,
	bUploadStarted:false,
	sIdDiv:"FeaturesUploadDiv",
	sURLImageCross:"cross.gif",
	sURLImageUpload:"arrow_right.gif",
	sURLImageSuccess:"accept.gif",
	sURLImageError:"exclamation.gif",
	init:function(sIdDiv, sURLImageCross, sURLImageUpload, sURLImageSuccess, sURLImageError){
		FeaturesUpload.sIdDiv = sIdDiv;
		FeaturesUpload.sURLImageCross = sURLImageCross;
		FeaturesUpload.sURLImageUpload = sURLImageUpload;
		FeaturesUpload.sURLImageSuccess = sURLImageSuccess;
		FeaturesUpload.sURLImageError = sURLImageError;
		$(FeaturesUpload.sIdDiv).innerHTML = "";
		$(FeaturesUpload.sIdDiv).className = "features_upload_box";
	},
	fileDialogStart: function(){},
	arrFile : [],
	addFile : function (file) {
		FeaturesUpload.arrFile.push(file);
		var sFileId = file.id;
		var oDivItem = document.createElement("div");
		oDivItem.id = "item_"+sFileId;
		oDivItem.className = "features_upload_line";
		
		var oDivItem1 = document.createElement("div");
		oDivItem1.className = "features_upload_label";
		oDivItem1.innerHTML = file.name;
		
		var oDivItem2 = document.createElement("div");
		oDivItem2.className = "features_upload_item";
		
		var oSpanItem = document.createElement("span");
		oSpanItem.id = "pc_"+file.id;
		oSpanItem.innerHTML = "";
		
		var oImg = document.createElement("img");
		oImg.title = oImg.alt = "Retirer";
		oImg.src = FeaturesUpload.sURLImageCross;
		oImg.id = "img_"+file.id;
		oImg.onclick = function(){
			FeaturesUpload.deleteFile(sFileId);
		}
		oDivItem.appendChild(oDivItem1);
		oDivItem2.appendChild(oSpanItem);
		oDivItem2.appendChild(oImg);
		oDivItem.appendChild(oDivItem2);
		$(FeaturesUpload.sIdDiv).appendChild(oDivItem);
	},
	deleteFile:function (sFileId){
		for (var i=0;i<FeaturesUpload.arrFile.length;i++){
			if (FeaturesUpload.arrFile[i].id == sFileId){
				FeaturesUpload.arrFile.splice(i, 1);
				$(FeaturesUpload.sIdDiv).removeChild($("item_"+sFileId));
				FeaturesUpload.SU.cancelUpload(sFileId);
				return;
			}
		}
	},
	deleteAll : function(){
		$(FeaturesUpload.sIdDiv).innerHTML = "";
		for (var i=0;i<FeaturesUpload.arrFile.length;i++){
			FeaturesUpload.SU.cancelUpload(FeaturesUpload.arrFile[i].id);
		}
		FeaturesUpload.arrFile = [];
	},
	fileQueueError : function (file, errorCode, message) {
		try {
			var errorName = "";
			switch (errorCode) {
			case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED:
				errorName = "QUEUE LIMIT EXCEEDED";
				break;
			case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
				errorName = "FILE EXCEEDS SIZE LIMIT";
				break;
			case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
				errorName = "ZERO BYTE FILE";
				break;
			case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
				errorName = "INVALID FILE TYPE";
				break;
			default:
				errorName = "UNKNOWN";
				break;
			}

			var errorString = errorName + ":File ID: " + (typeof(file) === "object" && file !== null ? file.id : "na") + ":" + message;
			alert("File Queue Error: " + errorString);

		} catch (ex) {
			this.debug(ex);
		}
	},
	fileDialogComplete : function (numFilesSelected, numFilesQueued) {},
	displayStartedUpload : function(){
		FeaturesUpload.bUploadStarted = true;
		for (var i=0;i<FeaturesUpload.arrFile.length;i++){
			$("img_"+FeaturesUpload.arrFile[i].id).src = FeaturesUpload.sURLImageUpload;
			$("pc_"+FeaturesUpload.arrFile[i].id).innerHTML = "0 %";
		}
	},
	displayMessageInItem : function(iIndex, sMessage){
		$("pc_"+FeaturesUpload.arrFile[iIndex].id).innerHTML = sMessage;
	},
	uploadStart : function () {
		try {
			$("item_"+FeaturesUpload.arrFile[FeaturesUpload.iCurrentIndex].id).style.backgroundColor = "#FFFFD1";
			FeaturesUpload.displayMessageInItem(FeaturesUpload.iCurrentIndex, "En attente...");
		} catch (ex) {
			this.debug(ex);
		}

		return true;
	},
	uploadProgress : function (file, iBytesLoaded, iTotalBytes) {
		try {
			var iPercent = Math.ceil((iBytesLoaded / FeaturesUpload.arrFile[FeaturesUpload.iCurrentIndex].size) * 100);
			
			FeaturesUpload.displayMessageInItem(FeaturesUpload.iCurrentIndex, iPercent+" %");
		} catch (ex) {
			this.debug(ex);
		}
	},
	uploadSuccess : function (file, serverData) {
		try {
			FeaturesUpload.displayMessageInItem(FeaturesUpload.iCurrentIndex, "OK");
		} catch (ex) {
			this.debug(ex);
		}
	},

	uploadError : function (file, errorCode, message) {
		try {
			var errorName = "";
			switch (errorCode) {
			case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
				errorName = "HTTP ERROR";
				break;
			case SWFUpload.UPLOAD_ERROR.MISSING_UPLOAD_URL:
				errorName = "MISSING UPLOAD URL";
				break;
			case SWFUpload.UPLOAD_ERROR.IO_ERROR:
				errorName = "IO ERROR";
				break;
			case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
				errorName = "SECURITY ERROR";
				break;
			case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
				errorName = "UPLOAD LIMIT EXCEEDED";
				break;
			case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
				errorName = "UPLOAD FAILED";
				break;
			case SWFUpload.UPLOAD_ERROR.SPECIFIED_FILE_ID_NOT_FOUND:
				errorName = "SPECIFIED FILE ID NOT FOUND";
				break;
			case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
				errorName = "FILE VALIDATION FAILED";
				break;
			case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
				errorName = "FILE CANCELLED";
				break;
			case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
				errorName = "FILE STOPPED";
				break;
			default:
				errorName = "UNKNOWN";
				break;
			}

			var errorString = errorName + ":File ID: " + (typeof(file) === "object" && file !== null ? file.id : "na") + ":" + message;
			alert(errorString);

		} catch (ex) {
		  this.debug(ex);
		}
	},
	
	uploadComplete : function () {
		var iIndex = FeaturesUpload.iCurrentIndex;
		$("item_"+FeaturesUpload.arrFile[iIndex].id).style.backgroundColor = "transparent";
		$("img_"+FeaturesUpload.arrFile[iIndex].id).src = FeaturesUpload.sURLImageSuccess;
	},
	// This custom debug method sends all debug messages to the Firebug console.  If debug is enabled it then sends the debug messages
	// to the built in debug console.  Only JavaScript message are sent to the Firebug console when debug is disabled (SWFUpload won't send the messages
	// when debug is disabled).
	debug : function (message) {
		try {
			if (window.console && typeof(window.console.error) === "function" && typeof(window.console.log) === "function") {
				if (typeof(message) === "object" && typeof(message.name) === "string" && typeof(message.message) === "string") {
					window.console.error(message);
				} else {
					window.console.log(message);
				}
			}
		} catch (ex) {
		}
		try {
			if (this.settings.debug) {
				this.debugMessage(message);
			}
		} catch (ex1) {
		}
	}
}
