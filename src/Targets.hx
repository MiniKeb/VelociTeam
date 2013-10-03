package ;
import com.tamina.planetwars.data.Planet;

/**
 * ...
 * @author MiniKeb
 */
class Targets
{
	public var origin:Planet;
	private var targets : Array<Target>;

	public function new(origin:Planet) 
	{
		this.origin = origin;
		this.targets = new Array<Target>();
	}
	
	public function addTarget(target:Target):Void {
		this.targets.push(target);
	}
	
	public function clean():Void {
	}
	
	public function getSmallest():Target {
		var smallest : Target;
		smallest = null;
		
		for (i in 0...this.targets.length) 
		{
			if (smallest == null || smallest.score > this.targets[i].score){
				smallest =  this.targets[i];
			}
		}
		
		return smallest;
	}
}

