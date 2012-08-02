function clVector(x, y, z)
{
 this.x = x;
 this.y = y;
 this.z = z;
}

function setPosition(div, iPosX, iPosY){
	document.getElementById(div).style.left = iPosX + "px";
	document.getElementById(div).style.top = iPosY + "px";
}

function normVectorFromCanevas(vect, iCanevasSize)
{

	var w = new clVector(
  			vect.x - (vect.x % iCanevasSize),
  			vect.y - (vect.y % iCanevasSize),
  			vect.x - (vect.z % iCanevasSize));

	return w;

}

function normDivPositionFromCanevas(div, iCanevasSize)
{
	var point = getVectorFromDivTopLeftCorner(div);
	point = normVectorFromCanevas(point,iCanevasSize);
	setPosition(div, point.x, point.y);

}


function getVectorFromDiv2(a, height, width)
{
	var eltA = document.getElementById(a);

	var w = new clVector(
  			parseInt(eltA.style.left) + height /2,
  			parseInt(eltA.style.top) + width /2,
  			0);

	return w;

}


function getVectorFromDiv(a)
{
	var eltA = document.getElementById(a);

	var w = new clVector(
  			parseInt(eltA.style.left) + g_box_height /2,
  			parseInt(eltA.style.top) + g_box_width /2,
  			0);

	return w;

}

function getVectorFromDivTopLeftCorner(a)
{
	var eltA = document.getElementById(a);

	var w = new clVector(
  			parseInt(eltA.style.left) ,
  			parseInt(eltA.style.top) ,
  			0);

	return w;

}


function getMiddlePointOfSegment(a, b)
{

	var w = new clVector(
  			(b.x + a.x) /2,
  			(b.y + a.y) /2,
  			(b.z + a.z) /2);

	return w;

}


function addVector(a, b)
{

	var c = new clVector(
  			b.x + a.x,
  			b.y + a.y,
  			b.z + a.z);

	return c;

}

function substractVector(a, b)
{

	var c = new clVector(
  			a.x - b.x,
  			a.y - b.y,
  			a.z - b.z);

	return c;

}


function getVector(a, b)
{

	var c = new clVector(
  			b.x - a.x,
  			b.y - a.y,
  			b.z - a.z);

	return c;

}

function scaleVector(a, scale)
{

	var c = new clVector(
  			a.x * scale,
  			a.y * scale,
  			a.z * scale);

	return c;

}


function normVector(a)
{

	var scale = 0.5;

	scale = Math.sqrt(
				Math.pow( a.x , 2)
				+ Math.pow( a.y , 2)
				+ Math.pow( a.z , 2) );

	var c = new clVector(
  			a.x / scale,
  			a.y / scale,
  			a.z / scale);

	return c;

}


function mt_drawSegment(a, b)
{
	jg_doc.drawLine(
  			a.x,
  			a.y,
  			b.x,
  			b.y	);

}




function  computeProduitVectoriel(
	u,
	v)
{
	var w = new clVector(
		( u.y * v.z ) - ( v.y * u.z ),
		( v.x * u.z ) - ( u.x * v.z ),
		( u.x * v.y ) - ( v.x * u.y ) );

	return w;

}


function mt_drawVectorWithArrowInMiddle(a, b, arrowMagnifyX, arrowMagnifyY )
{
	var pointA = getVectorFromDiv(a);
	var pointB = getVectorFromDiv(b);
	mt_drawSegment(pointA , pointB );

	var pointC = getMiddlePointOfSegment(pointA ,pointB );
	var vectAB = getVector(pointA ,pointB );
	var normZ = new clVector( 0, 0, 1);

	var scalarAB = computeProduitVectoriel(vectAB ,normZ );
	var normAB = scaleVector(normVector(vectAB ) ,arrowMagnifyX ) ;

	var normScalarAB ;
	normScalarAB =  normVector(scalarAB );
	normScalarAB =  scaleVector(normScalarAB , arrowMagnifyY);
	var pointD = addVector(pointC,normScalarAB );
	var pointE = substractVector(pointC,normScalarAB );
	pointD = substractVector(pointD,normAB );
	pointE = substractVector(pointE,normAB );

	mt_drawSegment(pointC, pointD );
	mt_drawSegment(pointC, pointE );

}

function mt_drawVectorWithCorner(a, b)
{
	var pointA = getVectorFromDiv(a);
	var pointB = getVectorFromDiv(b);
	var pointC = getMiddlePointOfSegment(pointA ,pointB );
	var pointD = new clVector(pointA.x, pointC.y, 0);
	var pointE = new clVector(pointB.x, pointC.y, 0);

	mt_drawSegment(pointA, pointD );
	mt_drawSegment(pointD, pointE );
	mt_drawSegment(pointE, pointB );

}
