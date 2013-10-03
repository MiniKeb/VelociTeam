package ;
import com.tamina.planetwars.data.Planet;

/**
 * ...
 * @author MiniKeb
 */
class Target {
	public var planet:Planet;
	public var score:Int;
	
	public function new(planet:Planet, score:Int = 0) {
		this.planet = planet;
		this.score = score;
	}
}