function getNode(iIdNode)
{
	var i;
	var node;
	var	nodeName = "node_" + iIdNode;
	
	node = document.forms['formulaire'].elements[nodeName];

	if(node == null) return null;
		
	return node;	
}

function visitAndCheck (iIdNode, bForceChecked)
{
	if(iIdNode == 0) return;
	var iFirstChildNode;
	var iNextSiblingNode ;	
	var node;
	
	node = getNode(iIdNode);

	// traitement
	node.checked = bForceChecked;

	iFirstChildNode = node.value;
	if(iFirstChildNode != 0)
	{
		visitAndCheck (iFirstChildNode , bForceChecked);
	}
	
	iNextSiblingNode = node.title;
	if(iNextSiblingNode != 0)
	{
		visitAndCheck (iNextSiblingNode , bForceChecked );
	}
	
}


function visitAndCheckNonRecursif (iIdNode, bForceChecked)
{
// à faire !	
	
}
