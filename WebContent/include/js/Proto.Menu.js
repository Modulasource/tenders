/** 
 * @description     prototype.js based context menu
 * @author          Juriy Zaytsev; kangax@gmail.com; http://thinkweb2.com/projects/prototype
 * @version         0.5
 * @date            8/22/07
 * @requires        prototype.js 1.6.0_rc0
 * @modified        !!!!by JR for prototype 1.5!!!! e. > Event.
*/

// temporary unobtrusive workaround for 'contextmenu' event missing from DOMEvents in 1.6.0_RC0
/*
if (!Event.DOMEvents.include('contextmenu')) {
    Event.DOMEvents.push('contextmenu')
}
*/

// nifty helper for setting element's property in a chain-friendly manner
Element.addMethods({
    __extend: function(element, hash) {
        return Object.extend($(element), hash);
    }
})

if (typeof Proto == "undefined") { var Proto = { } }

Proto.Menu = Class.create();
Proto.Menu.prototype = {
    initialize: function (options) {
        this.options = Object.extend({
            selector: '.contextmenu',
            className: '.protoMenu',
            pageOffset: 25,
            fade: false
        }, options || { });

        // Setting fade to true only if Effect is defined
        this.options.fade = this.options.fade && !Object.isUndefined(Effect);
        this.container = new Element('div', {className: this.options.className, style: 'display: none'});
        this.options.menuItems.each(function(item){
            this.container.insert(item.separator ? 
                new Element('div', {className: 'separator'}) :
                new Element('a', {
                        href: '#',
                        title: item.name,
                        className: item.disabled ? 'disabled' : ''
                    })
                    .observe('click', this.onClick.bind(this))
                    .update(item.name)
                    .__extend({_callback: item.callback})
                )
        }.bind(this));
        $(document.body).insert(this.container);

        Event.observe(document, 'click', function(e){
            this.container.hide();
        }.bind(this));
 
        //ADDED BY JR
        if(this.options.items){
            this.options.items.invoke('observe', Prototype.Browser.Opera ? 'click' : 'contextmenu', function(e){
	            if (Prototype.Browser.Opera && !Event.isLeftClick(e)) {
	                return;
	            }
	            this.show(e);
            }.bind(this));
        }else{
	        $$(this.options.selector).invoke('observe', Prototype.Browser.Opera ? 'click' : 'contextmenu', function(e){
	            if (Prototype.Browser.Opera && !Event.isLeftClick(e)) {
	                return;
	            }
	            this.show(e);
	        }.bind(this));
        }

        this.containerWidth = this.container.getWidth();
        this.containerHeight = this.container.getHeight();
    },
    show: function(e) {
        Event.stop(e);//e.stop();
        var viewport = document.viewport.getDimensions(),
            offset = document.viewport.getScrollOffsets(),
            containerWidth = this.container.getWidth(),
            containerHeight = this.container.getHeight();

        this.container.setStyle({
            left: ((Event.pointerX(e) + containerWidth + this.options.pageOffset) > viewport.width ? (viewport.width - containerWidth - this.options.pageOffset) : Event.pointerX(e)) + 'px',
            top: ((Event.pointerY(e) - offset.top + containerHeight) > viewport.height && (Event.pointerY(e) - offset.top) > containerHeight ? (Event.pointerY(e) - containerHeight) : Event.pointerY(e)) + 'px'
        }).hide();
        this.options.fade ? Effect.Appear(this.container, {duration: 0.25}) : this.container.show();
    },
    onClick: function(e) {
        Event.stop(e);//e.stop();
        if (Event.element(e)._callback && !Event.element(e).hasClassName('disabled')) {
            this.container.hide();
            Event.element(e)._callback();
        }
    }
}