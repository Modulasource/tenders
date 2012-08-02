   function DragCorner(container, handle, container_right, container_left, right_width, left_width) {
      var container = $(container);
      var container_right = $(container_right);
      var container_left = $(container_left);
      var handle = $(handle);
      
      var handle_clone;
      
      function moveListener(event) {
    	  
          /* limit with min and max width */
          //if(handle_clone.moveposition.x > handle_clone.min.x
          //&& handle_clone.moveposition.x < handle_clone.max.x){

    	  /* Calculate how far the mouse moved */
         var moved = {
                     x:(event.pointerX() - handle_clone.moveposition.x),
                     y:(event.pointerY() - handle_clone.moveposition.y)
                  };
         /* Reset container's x/y utility property */
         handle_clone.moveposition = {x:event.pointerX(), y:event.pointerY()};
         
        
         /* Update container's size */
         /*
         var size = container.getDimensions();
         container.setStyle({
               height: size.height+moved.y-sizeAdjust+'px',
               width:size.width+moved.x-sizeAdjust+'px'
            });*/
         
        	 handle_clone.style.left  = event.pointerX()+'px';
             //handle_clone.style.top = event.pointerY()+'px';
         //}
      }
      
      /* Listen for 'mouse down' on handle to start the move listener */
      handle.observe('mousedown', function(event) {
    	  stopDefault(event);
    	  handle_clone = $(handle).cloneNode(true);
          handle_clone.style.backgroundColor = "#5F5F5F";
          handle_clone.style.position = "absolute";
          handle_clone.style.zIndex = "1000";
          
          var sizeRight = container_right.getDimensions();
          handle_clone.style.height = /*sizeRight.height+*/"500px";
          
          container.appendChild(handle_clone);
    	  
         /* Set starting x/y */
    	  handle_clone.moveposition = {x:event.pointerX(),y:event.pointerY()};
    	  handle_clone.start = {x:event.pointerX(), y:event.pointerY()};
    	  handle_clone.min = {x:event.pointerX()-left_width, y:event.pointerY()};
    	  handle_clone.max = {x:event.pointerX()+right_width, y:event.pointerY()};
    	  
    	  handle_clone.style.left  = event.pointerX()+'px';
    	  handle_clone.style.top  = getPosTop(container_right)+'px';
    	  
         /* Start listening for mouse move on body */
         Event.observe(document.body,'mousemove',moveListener);
      });
      
      /* Listen for 'mouse up' to cancel 'move' listener */
      Event.observe(document.body,'mouseup', function(event) {
    	  if(isNotNull(handle_clone)){
         Event.stopObserving(document.body,'mousemove',moveListener);
         var size = container.getDimensions();
         /* Border adds to dimensions */
         var borderStyle = container.getStyle('border-width');
         var borderSize = borderStyle.split(' ')[0].replace(/[^0-9]/g,'');
         /* Padding adds to dimensions */
         var paddingStyle = container.getStyle('padding');
         var paddingSize = paddingStyle.split(' ')[0].replace(/[^0-9]/g,'');
         /* Add things up that change dimensions */
         var sizeAdjust = (borderSize*2) + (paddingSize*2);
         var oldWidth = size.width;
         
         /** TODO real width */
         container.setStyle({
               height: /*size.height+*/handle_clone.moveposition.y-sizeAdjust+'px',
               width:/*size.width+*/handle_clone.moveposition.x-sizeAdjust+'px'
            });
         var newSize = container.getDimensions();
         if(container_right){
         var sizeRight = container_right.getDimensions();
         container_right.setStyle({
             width:sizeRight.width-(newSize.width-oldWidth)+'px'
          });
         }
         if(container_left){
         var sizeLeft = container_left.getDimensions();
         container_left.setStyle({
             width:sizeLeft.width-(newSize.width-oldWidth)+'px'
          });
         }
         Element.remove(handle_clone);
    	  }
      });
   }
   
   function stopDefault(e) {
	    if (e && e.preventDefault) {
	        e.preventDefault();
	    }
	    else {
	        window.event.returnValue = false;
	    }
	    return false;
	}
