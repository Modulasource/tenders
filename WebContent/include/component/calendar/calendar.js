mt.component.Calendar = function(elm) {
	var self = this;
	this.days = MESSAGE_CALENDAR_DAY;
	this.weekend = {0: true, 6: true};
	this.months = MESSAGE_CALENDAR_MONTH;
	this.firstDayOfWeek = 1;
		
	this.updateCalendar = function(date) {
		var today = new Date();
		var year = date.getFullYear();
		var month = date.getMonth();
		var mday = date.getDate();

		date.setDate(1);
		var day1 = (date.getDay() - this.firstDayOfWeek) % 7;
		if (day1<0) day1 += 7;
		date.setDate(-day1);
		date.setDate(date.getDate()+1);

		this.domNode.innerHTML = '';
		
		var div = document.createElement("div");
		div.style.border = "1px solid #999";
		div.style.width = "15em";
		
		Event.observe(div, 'click', Event.stop);
		
		var table = document.createElement("table");
		table.className = "cpt-calendar";
		var thead = document.createElement("thead");
		
		// header table
		var tableHeader = document.createElement("table");
		tableHeader.className = "month_header";
		var tbody = document.createElement("tbody");	
		var tr = document.createElement("tr");		

        var td = document.createElement("td");
        td.style.width = "20px";
        td.style.textAlign = "left";
        var btn = document.createElement("img");
        btn.style.cursor = "pointer";
        btn.src = rootPath+"images/icons/control_start_blue.gif";
        Event.observe(btn, 'click', function(e) {
            var newDate = new Date(year-1, month, 1);
            self.onYearChange(newDate);
            self.updateCalendar(newDate);
            Event.stop(e);
        });
        td.appendChild(btn);
        tr.appendChild(td);

		var td = document.createElement("td");
		td.style.width = "20px";
		td.style.textAlign = "left";
		var btn = document.createElement("img");
		btn.style.cursor = "pointer";
		btn.src = rootPath+"images/icons/control_rewind_blue.gif";
		Event.observe(btn, 'click', function(e) {
			var newDate = new Date(year, month-1, 1);
			self.onMonthChange(newDate);
			self.updateCalendar(newDate);
			Event.stop(e);
		});
		td.appendChild(btn);
		tr.appendChild(td);
		
		var td = document.createElement("td");
		td.style.textAlign = "center";
		td.innerHTML = self.months[month] + " " + year;
		tr.appendChild(td);
	
		var td = document.createElement("td");
		td.style.width = "20px";
		td.style.textAlign = "right";
		var btn = document.createElement("img");
		btn.style.cursor = "pointer";
		btn.src = rootPath+"images/icons/control_fastforward_blue.gif";
		Event.observe(btn, 'click', function(e) {
			var newDate = new Date(year, month+1, 1);
			self.onMonthChange(newDate);
			self.updateCalendar(newDate);
			Event.stop(e);
		});		
		td.appendChild(btn);
		tr.appendChild(td);
		
		var td = document.createElement("td");
        td.style.width = "20px";
        td.style.textAlign = "right";
        var btn = document.createElement("img");
        btn.style.cursor = "pointer";
        btn.src = rootPath+"images/icons/control_end_blue.gif";
        Event.observe(btn, 'click', function(e) {
            var newDate = new Date(year+1, month, 1);
            self.onYearChange(newDate);
            self.updateCalendar(newDate);
            Event.stop(e);
        });     
        td.appendChild(btn);
        tr.appendChild(td);
		
		tbody.appendChild(tr);
		tableHeader.appendChild(tbody);
		// -------------
		
		var tr = document.createElement("tr");
		var td = document.createElement("td");
		td.colSpan = 7;
		td.style.padding = "2px";
		td.appendChild(tableHeader);
		tr.appendChild(td);
		thead.appendChild(tr);
		
		var tr = document.createElement("tr");
		tr.className = "days";
		var td, img;
		for (var i = 0; i < 7; ++i) {
			d = (i + this.firstDayOfWeek) % 7;
			td = document.createElement("td");
			if (self.weekend[d]) {
				td.className = "weekend";
			}
			td.innerHTML = self.days[d];
			tr.appendChild(td);
		}
		thead.appendChild(tr);		
		table.appendChild(thead);
		
		var tbody = document.createElement("tbody");
		tr = document.createElement("tr");
		
		var iday = date.getDate();
		var first = true;
		for (var i = 0; i < 42; ++i, date.setDate(iday + 1)) {
			td = document.createElement("td");
			iday = date.getDate();
			var wday = date.getDay();
			var m = date.getMonth();
			if (wday == this.firstDayOfWeek) {
				if (!first && m != month) {
					break;
				};
				tbody.appendChild(tr);
				tr = document.createElement("tr");
				first = false;
			};
			td.className = '';
			if (m != month) {
				td.className += ' lastmonth';
			} else {
				td.style.cursor = "pointer";
				td.setAttribute("date", date.toString());
				td.onclick = function() {
					if (self.selectedDomElement) {
						if (self.selectedDomElement.className.indexOf('weekend')!=-1) {
							self.selectedDomElement.style.backgroundColor = "#F4F4F4"
						} else {
							self.selectedDomElement.style.backgroundColor = "#FFF";
						}
						self.selectedDomElement.style.border = "1px solid #DDD";
					}
					var d = new Date(this.getAttribute("date"));
					self.selectedDate = d;
					self.selectedDomElement = this;
					self.onSelect(self.selectedDate);
					this.style.backgroundColor = "#F4DEE7";
					this.style.border = "1px solid #CA95AB";
				}
				td.onmouseover = function() {
					this.style.backgroundColor = "#D5DFE9";
					this.style.border = "1px dotted #555";
				}
				td.onmouseout = function() {
					if (this.className.indexOf('weekend')!=-1) {
						this.style.backgroundColor = "#F4F4F4"
					} else {
						this.style.backgroundColor = "#FFF";
					}
					this.style.border = "1px solid #DDD";
					
					var d = new Date(this.getAttribute("date"));
					if (self.selectedDate)
					if (self.selectedDate.getFullYear() == d.getFullYear() && self.selectedDate.getMonth() == d.getMonth() && self.selectedDate.getDate() == d.getDate()) {
						this.style.backgroundColor = "#F4DEE7";
						this.style.border = "1px solid #CA95AB";
					}
				}
				if (self.weekend[wday]) td.className += ' weekend';				
			}
			if (date.getFullYear() == today.getFullYear() && date.getMonth() == today.getMonth() && date.getDate() == today.getDate()) {
				td.className += ' today';
			}
			if (this.selectedDate){
				if (date.getFullYear() == this.selectedDate.getFullYear() && date.getMonth() == this.selectedDate.getMonth() && date.getDate() == this.selectedDate.getDate()) {
					this.selectedDomElement = td;
					td.style.backgroundColor = "#F4DEE7";
					td.style.border = "1px solid #CA95AB";
				}
			}
			
			td.className += ' day';

			td.innerHTML = iday;
			tr.appendChild(td);
		}
	
		tbody.appendChild(tr);
		
		var trClean = document.createElement("tr");
		var tdClean = document.createElement("td");
		tdClean.colSpan = "7";
		tdClean.style.cursor = "pointer";
		tdClean.style.backgroundColor = "#F4F4F4"
        tdClean.style.border = "1px solid #DDD";
		tdClean.onmouseover = function() {
            this.style.backgroundColor = "#D5DFE9";
            this.style.border = "1px dotted #555";
        }
        tdClean.onmouseout = function() {
            this.style.backgroundColor = "#F4F4F4"
            this.style.border = "1px solid #DDD";
        }
        tdClean.onclick = function(){
            self.clean();
        }
		tdClean.innerHTML = MESSAGE_CALENDAR_CLEAN;
		trClean.appendChild(tdClean);
		tbody.appendChild(trClean);
		
		table.appendChild(tbody);
		div.appendChild(table);
		this.domNode.appendChild(div);
	}
	
	this.setSelectedDate = function(date){
		this.selectedDate = date;
	}
	
	this.getSelectedDate = function() {
		return this.selectedDate;
	}

	this.render = function() {
		this.domNode = $(elm);
		if (this.selectedDate) {
			this.updateCalendar(new Date(this.selectedDate));
		} else {
			this.updateCalendar(new Date());
		}
	}
	
	this.onMonthChange = function(){}
	this.onYearChange = function(){}
}
