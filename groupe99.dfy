
// Le type de données pour les rectangles.
// Remplacez-le par votre définition de rectangle.
// Vous pouvez en introduire d'autres si vous le jugez pertinent.
datatype rData = Rectangle(x: int, y: int, w: int, h: int)

predicate method okRekt(t: rData)
{
    t.x >= 0 && t.y >= 0 && t.h > 0 && t.w > 0
}

function method absRekt(t: rData): int
{
  //TODO modifier ca !
    true
}

function boll isNeighbourgs(a: rData, b: rData)
  assume a != null && b != null
{
  (a.x + a.l == b.x) || (a.y + a.w == b.y)
}

function bool canMerge(a: rData, b: rData)
  assume okRekt(a) && okRekt(b)
{
  isNeighbourgs(a,b) || isNeighbourgs(b,a);
}

function rData merge(a: rData, b: rData)
  assume okRekt(a) && okRekt(b)
{

}

class Node(){

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
