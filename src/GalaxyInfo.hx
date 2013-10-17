package ;
import com.tamina.planetwars.data.Planet;

/**
 * ...
 * @author MiniKeb
 */
class GalaxyInfo {
	public var biggestPlanet : Planet;
	public var lessPopulatePlanet : Planet;
	
	public var sparsestPlanet : Planet;
	public var densestPlanet : Planet;
	
	public var closestPlanet : Distance;
	public var farestPlanet : Distance;
	
	public var bestRatio : Distance;
	
	public var myTotalPopulation : Int;
	public var myTotalSize : Int;
	public var myAvailableResource : Int;
	
	public function new() { }
}