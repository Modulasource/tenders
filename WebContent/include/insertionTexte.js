		function insertionTexte(textarea,texte) 
		{
		      if (textarea.createTextRange) 
		      {
		         var text;
		         textarea.focus(textarea.caretPos);
		         textarea.caretPos = document.selection.createRange().duplicate();
		         if(textarea.caretPos.text.length>0)
		         {
		             var sel = textarea.caretPos.text;
		            var fin = '';
		            while(sel.substring(sel.length-1, sel.length)==' ')
		            {
		               sel = sel.substring(0, sel.length-1)
		               fin += ' ';
		            }
		            textarea.caretPos.text = texte + fin;
		         }
		         else
		            textarea.caretPos.text = texte;
		      }
		      else textarea.value += texte;

		}
