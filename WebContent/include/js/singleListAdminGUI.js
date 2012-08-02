/**
 * Single List Admin GUI
 * 
 * @author Juan José A. Paz
 */

/**
 * ListBoxItem
 */
function ListBoxItem (value, label){
	this.value = value;
	this.label = label;

	/** HTML Option **/
	this.option = document.createElement ("option");
	this.option.value = this.value;
	this.option.innerHTML = this.label;
	this.option.listBoxItem = this;

	/**
	 * Returns the main HTML node.
	 */
	this.getElement = function (){
		return this.option;
	};

	this.setValue = function (value){
		this.value = value;
		this.option.value = value;
		return this;
	};

	this.setLabel = function (label){
		this.label = label;
		this.option.innerHTML = label;
		return this;
	};
}

/**
 * ListBox
 */
function ListBox (){
	this.select = null;
	
	this.buildSelect = function (){
		this.select = document.createElement ("select");
		this.select.size = 6;
		this.select.style.width = "200px";
		this.select.listBox = this;
	};

	this.addItem = function (value, label){
		var item = new ListBoxItem (value, label);
		this.select.appendChild (item.getElement ());

		this.select.selectedIndex = this.select.options.length - 1;
		if (this.select.onchange)
			this.select.onchange ();

		return this;
	};

	this.removeItem = function (item){
		this.select.removeChild (item.getElement ());
		this.select.selectedIndex = 0;

		return this;
	};

	/**
	 * Returns the main HTML node.
	 */
	this.getElement = function (){
		return this.select;
	};

	this.buildSelect ();

	/**
	 * Returns the ListBoxItem object associated to the selected option.
	 */
	this.getSelectedItem = function (){
		return (this.select.selectedIndex >= 0) ?
			this.select.options [this.select.selectedIndex].listBoxItem :
			null;
	};

	this.getItemsCount = function (){
		return this.select.options.length;
	};

	this.setSelectedIndex = function (index){
		this.select.selectedIndex = index;
		if (this.select.onchange)
			this.select.onchange ();
	};
}

/**
 * ButtonBar
 */
function ButtonBar (){
	this.STATE_VIEW = 1;
	this.STATE_NEW = 2;
	this.STATE_EDIT = 3;

	this.newButton = function (id, label, urlIcon){
		var button = document.createElement ("button");
		if (button.type != "button")
			button.type = "button";
		button.innerHTML = label;
		button.id = id;
		button.style.width = "100px";
		button.bar = this;
		if (urlIcon != null){
			var icon = document.createElement ("img");
			icon.src = urlIcon;
			button.appendChild (icon);
		}
		return button;
	};

	this.buildTable = function () {
		this.vTD = [];
		for (var i = 0; i < 3; ++i)
			this.vTD [this.vTD.length] = document.createElement ("td"); 

		this.table = document.createElement ("table");
		var tbody = document.createElement ("tbody");
		this.table.appendChild (tbody);
		for (var i = 0; i < 3; ++i){
			var tr = document.createElement ("tr");
			tr.appendChild (this.vTD [i]);
			tbody.appendChild (tr);
		}

		this.updateTable ();
	};

	this.clearTD = function (){
		for (var i = 0; i < this.vTD.length; ++i)
			while (this.vTD [i].childNodes.length > 0)
				this.vTD [i].removeChild (this.vTD [i].childNodes [0]);
	};

	this.updateTable = function (){
		this.clearTD ();
		switch (this.state){
			case this.STATE_VIEW:
			this.vTD [0].appendChild (this.buttonNew);
			this.vTD [1].appendChild (this.buttonDelete);
			this.vTD [2].appendChild (this.buttonEdit);
			break;

			case this.STATE_NEW:
			this.vTD [0].appendChild (this.buttonOk);
			this.vTD [1].appendChild (this.buttonCancel);
			this.vTD [2].appendChild (this.buttonClear);
			break;

			case this.STATE_EDIT:
			this.vTD [0].appendChild (this.buttonOk);
			this.vTD [1].appendChild (this.buttonCancel);
			this.vTD [2].appendChild (this.buttonRestore);
			break;
		}
	};

	/**
	 * The "view" is a control or group of controls managed by the user to show the item information.
	 * For example, a textbox that shows an email.
	 */
	this.updateView = function (){
		switch (this.state){
			case this.STATE_VIEW:
			this.onSetViewEnabled (false);
			break;
			
			case this.STATE_NEW:
			this.onSetViewEnabled (true);
			break;
			
			case this.STATE_EDIT:
			this.onSetViewEnabled (true);
			break;
		}
	};

	/**
	 * The "list" is a control or group of controls managed by the user to show a list of items.
	 * For example, a listbox that shows an email list.
	 */
	this.updateList = function (){
		switch (this.state){
			case this.STATE_VIEW:
			this.onSetListEnabled (true);
			break;
			
			case this.STATE_NEW:
			this.onSetListEnabled (false);
			break;
			
			case this.STATE_EDIT:
			this.onSetListEnabled (false);
			break;
		}
	};

	/**
	 * Returns the main DOM element.
	 */
	this.getElement = function (){
		return this.table;
	};

	this.state = this.STATE_VIEW;

	/**
	 * Sets the state and updates the view.
	 */
	this.setState = function (state){
		if (this.onGetRecordCount () < 1)
			switch (state){
				case this.STATE_VIEW:
				state = this.STATE_NEW;
				break;
				
				case this.STATE_EDIT:
				state = this.STATE_NEW;
				break;
				
				case this.STATE_NEW:
				break;
			}
		
		this.state = state;
		this.updateTable ();
		this.updateView ();
		this.updateList ();
	}

	/** Buttons **/

	this.buttonNew = this.newButton ("buttonNew", MESSAGE_BUTTON[11]);
	this.buttonDelete = this.newButton ("buttonDelete", MESSAGE_BUTTON[4]);
	this.buttonEdit = this.newButton ("buttonEdit", MESSAGE_BUTTON[12]);
	this.buttonOk = this.newButton ("buttonOk", MESSAGE_BUTTON[1]);
	this.buttonCancel = this.newButton ("buttonCancel", MESSAGE_BUTTON[2]);
	this.buttonClear = this.newButton ("buttonClear", MESSAGE_BUTTON[13]);
	this.buttonRestore = this.newButton ("buttonRestore", MESSAGE_BUTTON[14]);

	/** Button handlers **/

	this.doNew = function (){
		switch (this.state){
			case this.STATE_VIEW:
			this.setState (this.STATE_NEW);
			this.onClearView ();
			break;
		}
	};

	this.doDelete = function (){
		switch (this.state){
			case this.STATE_VIEW:
			if (!this.onDeleteItem ())
				return;
			this.setState (this.STATE_VIEW);
			this.onUpdateView ();
			break;
		}
	};

	this.doEdit = function (){
		switch (this.state){
			case this.STATE_VIEW:
			this.setState (this.STATE_EDIT);
			break;
		}
	};

	this.doOk = function (){
		switch (this.state){
			case this.STATE_NEW:
			if (!this.onNewItem ())
				return;
			this.setState (this.STATE_VIEW);
			this.onUpdateView ();
			break;

			case this.STATE_EDIT:
			if (!this.onUpdateItem ())
				return;
			this.setState (this.STATE_VIEW);
			this.onUpdateView ();
			break;
		}
	};

	this.doCancel = function (){
		switch (this.state){
			case this.STATE_NEW:
			this.setState (this.STATE_VIEW);
			this.onUpdateView ();
			break;
			
			case this.STATE_EDIT:
			this.setState (this.STATE_VIEW);
			this.onUpdateView ();
			break;
		}
	};

	this.doClear = function (){
		switch (this.state){
			case this.STATE_NEW:
			this.onClearView ();
			break;
		}
	};

	this.doRestore = function (){
		switch (this.state){
			case this.STATE_EDIT:
			this.onUpdateView ();
			break;
		}
	};

	/** Button Handlers asignation **/

	this.buttonNew.onclick = function (){
		this.bar.doNew ();
	};
	this.buttonEdit.onclick = function (){
		this.bar.doEdit ();
	};
	this.buttonDelete.onclick = function (){
		this.bar.doDelete ();
	};
	this.buttonOk.onclick = function (){
		this.bar.doOk ();
	};
	this.buttonCancel.onclick = function (){
		this.bar.doCancel ();
	};
	this.buttonClear.onclick = function (){
		this.bar.doClear ();
	};
	this.buttonRestore.onclick = function (){
		this.bar.doRestore ();
	};

	/**
	 * Event handlers.
	 * They must be assigned by the user.
	 */
	this.onNewItem = function (){};
	this.onUpdateItem = function (){};
	this.onDeleteItem = function (){};
	this.onUpdateList = function (){};
	this.onUpdateView = function (){};
	this.onClearView = function (){};
	this.onSetViewEnabled = function (enabled){};
	this.onSetListEnabled = function (enabled){};
	this.onGetRecordCount = function (){return 0};

	this.buildTable ();
}

/** Utils **/

function newTable (rows, cols){
	var table = document.createElement ("table");

	var tbody = document.createElement ("tbody");
	table.appendChild (tbody);

	table.vCells = [];
	for (var i = 0; i < 2; ++i){
		var tr = document.createElement ("tr");
		table.vCells [i] = [];
		for (var j = 0; j < 2; ++j){
			var td = document.createElement ("td");
			tr.appendChild (td);
			table.vCells [i][j] = td;
		}
		tbody.appendChild (tr);
	}

	return table;
}

/** SingleListAdminGUI **/

function SingleListAdminGUI (){
	/** Main components **/
	this.buttonBar = new ButtonBar ();
	this.listBox = new ListBox ();
	
	/** Text box **/
	this.txtItem = document.createElement ("input");
	this.txtItem.type = "text";
	this.txtItem.style.width = "100%";

	/** Container **/
	this.table = newTable (2, 2);
	this.table.vCells [0][0].appendChild (this.txtItem);
	this.table.vCells [1][0].appendChild (this.listBox.getElement ());
	this.table.vCells [1][1].appendChild (this.buttonBar.getElement ());

	this.getElement = function (){
		return this.table;
	};

	/** Handlers **/
	this.onValidation = function (label){return true;};

	/** List Box events **/
	this.listBox.parent = this;
	this.listBox.getElement ().onchange = function (){
		var item = this.listBox.getSelectedItem ();
		this.listBox.parent.txtItem.value = (item == null) ? '' : item.label;
		this.listBox.parent.buttonBar.setState (this.listBox.parent.buttonBar.STATE_VIEW);
	};

	/** ButtonBar events **/
	this.buttonBar.parent = this;

	this.buttonBar.onNewItem = function (){
		var text = this.parent.txtItem.value;
		if (!this.parent.onValidation (text))
			return false;
		this.parent.listBox.addItem (text, text);
		return true;
	};

	this.buttonBar.onUpdateItem = function (){
		var item = this.parent.listBox.getSelectedItem ();
		var label = this.parent.txtItem.value;

		if (!this.parent.onValidation (label))
			return false;
		item.setLabel (label);
		return true;
	};

	this.buttonBar.onDeleteItem = function (){
		var item = this.parent.listBox.getSelectedItem ();
		this.parent.listBox.removeItem (item);
		return true;
	};

	this.buttonBar.onUpdateView = function (){
		var item = this.parent.listBox.getSelectedItem ();
		if (item == null)
			this.parent.buttonBar.onClearView ();
		else
			this.parent.txtItem.value = this.parent.listBox.getSelectedItem ().label;
	};
	
	this.buttonBar.onClearView = function (){
		this.parent.txtItem.value = "";
	};

	this.buttonBar.onSetViewEnabled = function (enabled){
		this.parent.txtItem.readOnly = !enabled;
		if (enabled)
			this.parent.txtItem.focus ();
	};

	this.buttonBar.onSetListEnabled = function (enabled){
		this.parent.listBox.getElement ().disabled = !enabled;
	};

	this.buttonBar.onGetRecordCount = function (){
		return this.parent.listBox.getItemsCount ();
	};

	/** Items management **/

	this.addItem = function (value, label){
		this.listBox.addItem (value, label);
	};

	this.setSelectedIndex = function (index){
		this.listBox.setSelectedIndex (0);
	};

	/** Init **/
	this.listBox.setSelectedIndex (0);
	this.buttonBar.setState (this.buttonBar.STATE_VIEW);
};
