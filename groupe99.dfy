// Le type de données pour les rectangles.
// Remplacez-le par votre définition de rectangle.
// Vous pouvez en introduire d'autres si vous le jugez pertinent.
datatype rData = Rectangle(x: int, y: int, w: int, h: int)

predicate method okRekt(t: rData)
{
    t.x >= 0 && t.y >= 0 && t.h > 0 && t.w > 0
}

function absRekt(t: rData): bool
{
    okRekt(t)
}

function method isNeighbours(a: rData, b: rData) : bool
  requires okRekt(a) && okRekt(b)
{
    (a.x + a.w == b.x && a.y == b.y) || (a.y + a.w == b.y && a.x == b.x)
}

function method canMerge(a: rData, b: rData) : bool
  requires okRekt(a) && okRekt(b)
{
  if   isNeighbours(a,b) || isNeighbours(b,a) then
    if a.x == b.x then
      a.w == b.w
    else if a.y == b.y then
      a.h == b.h
    else
      false
  else
    false
  //( ( isNeighbours(a,b) || isNeighbours(b,a) ) && (a.w == b.w || a.h == b.h) )
}

function method merge(a: rData, b: rData) : rData
  requires okRekt(a) && okRekt(b) && (canMerge(a,b) || canMerge(b,a))
{
    if a.h == b.h && a.y == b.y && ( a.x == b.x + b.w || a.x + a.w == b.x) then
      Rectangle(min(a.x,b.x), min(a.y, b.y), a.w+b.w, a.h)
    else
      if a.w == b.w && a.x == b.x && ( a.y + a.h == b.y || a.y == b.y + b.h ) then
        Rectangle(min(a.x, b.x), min(a.y, b.y), a.w, a.w + b.w)
      else
        Rectangle(-1,-1,-1,-1)
  //if (a.h == b.h) then Rectangle(min(a.x,b.x), min(a.y,b.y), a.w+b.w, a.h) else Rectangle(min(a.x,b.x), min(a.y,b.y),a.w, a.h+b.h)
}

function method min(a: int, b:int) : int
{
    if a<b then a else b
}

class Couverture {

    var TuillesTab: array<rData>;
    // autres champs de la classe
    var indexArray: int;
	//Nombre de rectangle 
    var nbrRekt: int;

    // Ceci est votre invariant de représentation.
    // C'est plus simple d'avoir ok() dans les pre et les posts que le le recoper à chaque fois.
    predicate ok()
        reads this, TuillesTab
    {
        TuillesTab != null && nbrRekt >=0
        
    }

    constructor (qs: array<rData>)
        requires qs != null
        modifies this // forcément ;-)
        ensures ok()
    {
        TuillesTab := qs;
        nbrRekt:=TuillesTab.Length;
    }

    method optimize()
        requires ok()
        requires TuillesTab != null
        modifies this
        ensures ok()
    {
        indexArray := TuillesTab.Length;
        var bigArray := new rData[TuillesTab.Length * 2];
        var i : int := 0;
        while i < TuillesTab.Length
          invariant TuillesTab != null
          invariant 0 <= i <= TuillesTab.Length
          invariant TuillesTab.Length <= bigArray.Length
          invariant forall j :: 0 <= j < i ==> bigArray[j] == TuillesTab[j]
        {
          bigArray[i] := TuillesTab[i];
          i := i+1;
        }
        var flag : bool := true;
        while flag
          //invariant indexArray >= TuillesTab.Length && indexArray <= bigArray.Length
          
          /*invariant
            flag <==> exists i,j :: 0 <= i < j < bigArray.Length ==>
              if okRekt(bigArray[i]) && okRekt(bigArray[j]) then
                canMerge(bigArray[i], bigArray[j])
              else
                false */
          decreases  flag, nbrRekt
        {
          flag := improve(bigArray);

        }
        //replace tuile tab with a small array
        //getting the sizee for the new array
        var sizeNew : int := 0;
        i := 0;
        while i < bigArray.Length {
          if bigArray[i].x != -1 {
            sizeNew := 1 + sizeNew;
          }
          i := i +1;
        }
        //assigning the new array
        var result := new rData[sizeNew];
        var count : int := 0;
        i := 0;
        while i < bigArray.Length {
          if bigArray[i].x != -1 {
            assume count >= 0 && count < result.Length;
            result[count] := bigArray[i];
            count := count +1;
          }
          i := i +1;
        }
        TuillesTab := result;
        assume nbrRekt>=0;
    }
  


    method improve(inputArray: array<rData>) returns(retVal: bool)
      modifies inputArray
      modifies this
      requires nbrRekt >=0
      requires inputArray != null
      //requires ok()
      //requires forall i :: 0 <= i < inputArray.Length ==> okRekt(inputArray[i]) || inputArray[i].x == -1
    {
      assume ok();
      assume indexArray >= TuillesTab.Length && indexArray <= inputArray.Length;
      retVal := false;
      var i : int := 0;
      while i < inputArray.Length 
      	invariant 0 <= i <= inputArray.Length 
      {
        var j : int := i+1;
        while j < inputArray.Length 
        	invariant i+1 <= j <= inputArray.Length 
        {
          if(okRekt(inputArray[i]) && okRekt(inputArray[j]) ){
            if(canMerge(inputArray[i], inputArray[j])){
              assume indexArray >= 0 && indexArray < inputArray.Length;
              inputArray[indexArray] := merge(inputArray[i], inputArray[j]);
              indexArray := indexArray + 1;
              inputArray[i] := Rectangle(-1,0,0,0);
              inputArray[j] := Rectangle(-1,0,0,0);
              nbrRekt:=nbrRekt-1;
              retVal := true;
            }//if
          }//if
          j:= j+1;
        }//forall
        i:= i+1;
      }//forall
    }//improve

    method dump()
        requires ok()
    {
        var i := 0;
        var first := true;
        print "[ ";
        while i < TuillesTab.Length
        {
            if !first { print ", "; }
            print TuillesTab[i];
            i := i + 1;
            first := false;
        }
        print " ]\n";
    }
}

method Main()
{
    // Vous devez écrire ici trois tests de votre méthode optimize
    var g := new rData[3];
    g[1], g[2] := Rectangle(1,1,1,1), Rectangle(2,1,1,1);

    var m := new Couverture(g);
    m.optimize();
    m.dump();
}
