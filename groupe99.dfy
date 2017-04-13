
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

function isNeighbours(a: rData, b: rData) : bool 
  requires okRekt(a) && okRekt(b) 
{
    (a.x + a.w == b.x) || (a.y + a.w == b.y)
}

function canMerge(a: rData, b: rData) : bool 
  requires okRekt(a) && okRekt(b)
{
  ( ( isNeighbours(a,b) || isNeighbours(b,a) ) && (a.w == b.w || a.h == b.h) )
}

function merge(a: rData, b: rData) : rData
  requires okRekt(a) && okRekt(b) && canMerge(a,b)
{
    if (a.h == b.h) then Rectangle(min(a.x,b.x), min(a.y,b.y), a.w+b.w, a.h) else Rectangle(min(a.x,b.x), min(a.y,b.y),a.w, a.h+b.h)
}

function min(a: int, b:int) : int 
{
    if a<b then a else b
}

class Node
{
  var InnerR: rData;
  var neightbourgs: array<Node>;
  var isVisited: bool;
}


class Couverture {

    var TuillesTab: array<rData>;
    // autres champs de la classe
    var graph : Node;

    // Ceci est votre invariant de représentation.
    // C'est plus simple d'avoir ok() dans les pre et les posts que le le recoper à chaque fois.
    predicate ok()
        reads this, TuillesTab
    {
        TuillesTab != null
    }

    constructor (qs: array<rData>)
        // ...
        requires qs != null
        modifies this // forcément ;-)
        ensures ok()
    {
        TuillesTab := qs;
        //ici , on fait le graphe
    }

    method buildGraph(){
      var isMod: bool;
      isMod := true;
      while(isMod){

      }
    }

    method inkInvasion(){

    }

    method mergeNode(){

    }

    method optimize()
        requires ok()
        ensures ok()
    {
        /* ... */
        //ici, on merge
    }

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
    m.dump();
}
