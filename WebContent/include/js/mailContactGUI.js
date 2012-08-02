var ORGANISATION_SERVICE_STATE_ACTIVE = 1;
var ORGANISATION_SERVICE_STATE_ARCHIVED = 2;

/**
 * Mail Contact GUI
 * 
 * It needs the SingleListAdminGUI classes. Please include it.
 * At the moment, this class is used in reminderMailDataForm.jsp and inputReportMailDataForm.jsp
 *
 * @author Juan José A. Paz
 */
function MailContactGUI (services, idIndividualContact){
	/**
	 * The service is available in the list when it contains persons and its state is not archived.
	 */
	this.isServiceAvailable = function (service){
		return service.personnes.length > 0
				&& (service.lIdOrganisationServiceState == 0
					|| service.lIdOrganisationServiceState == ORGANISATION_SERVICE_STATE_ACTIVE);
	};

	this.services = services;
	this.listBoxServices = new ListBox ();
	this.lstIndividualContact = $(idIndividualContact);

	/** Init the Services List Box **/
	this.listBoxServices.parent = this;
	for (var i = 0; i < this.services.length; ++i){
		var service = this.services [i];
		if (this.isServiceAvailable (service)){
			this.listBoxServices.addItem (service.lId, service.sNom);
			var options = this.listBoxServices.getElement ().options;
			var item = options [options.length - 1];
			item.service = service;
		}
	}
	this.listBoxServices.getElement ().size = 1;
	this.listBoxServices.getElement ().style.width = "310px";
	this.listBoxServices.getElement ().onchange = function (){
		var mailContactGUI = this.listBox.parent;
		var lstIndividualContact = mailContactGUI.lstIndividualContact;
		var listBoxServices = mailContactGUI.listBoxServices;
		
		/** Clear the contact list **/
		while (lstIndividualContact.childNodes.length > 0)
			lstIndividualContact.removeChild (lstIndividualContact.childNodes [0]);

		/** Pupulate with addresses **/
		var service = listBoxServices.getElement ().options [listBoxServices.getElement ().selectedIndex].service;
		var personnes = service.personnes;
		for (var i = 0; i < personnes.length; ++i){
			var personne = personnes [i];
			if (!personne.selected){
				var item = new ListBoxItem (personne.lId, personne.sFullName);
				item.personne = personne;
				lstIndividualContact.appendChild (item.getElement ());		
		
				personne.selected = false;
				personne.service = service;
			}
		}
	};
	this.listBoxServices.setSelectedIndex (0);

	/**
	 * Moves the selected contacts from the contact list to a recipient list (TO or CC).
	 * 
	 * @param idRecipient	String with a select id.
	 */
	this.selectContacts = function selectContacts (idRecipient){
		var lstIndividualContact = this.lstIndividualContact; // $("idIndividualContact");
		var lstIndividualRecipient = $(idRecipient);

		var options = lstIndividualContact.options;
		for (var i = 0; i < options.length;)
			if (options [i].selected){
				var item = options [i].listBoxItem;
				var newItem = new ListBoxItem (item.value, item.label);
				var personne = item.personne;
				personne.selected = true;
				
				newItem.personne = personne;
				lstIndividualRecipient.appendChild (newItem.getElement ());
				lstIndividualContact.removeChild (item.getElement ());
			} else
				++i;
	};

	/**
	 * Moves the selected contacts from a recipient list (TO or CC) to the contact list.
	 * 
	 * @param idRecipient	String with a select id.
	 */
	this.deselectContacts = function (idRecipient){
		var lstIndividualContact = this.lstIndividualContact; // $("idIndividualContact");
		var lstIndividualRecipient = $(idRecipient);
		var listBoxServices = this.listBoxServices;

		var options = lstIndividualRecipient.options;
		for (var i = 0; i < options.length;)
			if (options [i].selected){
				var item = options [i].listBoxItem;
				var personne = item.personne;

				if (personne){
					personne.selected = false;
					
					var service = listBoxServices.getElement ().options [listBoxServices.getElement ().selectedIndex].service;
					if (personne.service == service){
						var newItem = new ListBoxItem (item.value, item.label);
						newItem.personne = personne;
						lstIndividualContact.appendChild (newItem.getElement ());
					}
				} 
				
				lstIndividualRecipient.removeChild (item.getElement ());
			} else
				++i;
	};

	/**
	 * Returns the main HTML element of the component.
	 */
	this.getElement = function (){
		return this.listBoxServices.getElement ();
	};
}
