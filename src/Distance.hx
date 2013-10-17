package ;
import com.tamina.planetwars.data.Planet;

/**
 * ...
 * @author MiniKeb
 */
class Distance {
	public var planet : Planet;
	public var meanTravelTurnCount : Float;
	
	public function new (planet:Planet, meanTravelTurnCount:Float) {
		this.planet = planet;
		this.meanTravelTurnCount = meanTravelTurnCount;
	}
}