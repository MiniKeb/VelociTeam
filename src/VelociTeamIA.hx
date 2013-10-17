package ;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.geom.Point;
/**
 * Model d'IA de base au SDK. Il a le même niveau que le robot de validation des combats
 * @author d.mouton
 */

class VelociTeamIA extends WorkerIA
{
	private var ennemyId : String;
	
	/**
	 * @internal
	 */
	public static function main():Void {
		WorkerIA.instance = new VelociTeamIA();
	}
	
	public function new() 
	{
		super("", 0);
		this.ennemyId = null;
	}
	
	
	/**
	 * @inheritDoc
	 */
	override public function getOrders( context:Galaxy ):Array<Order>
	{
		var result:Array<Order> = new Array<Order>();
		var allTargets = getPlanetsScore(context);
		var minimumPopulation = Game.PLANET_GROWTH * 2;
		var fleets = GameUtil.getEnnemyFleet(id, context);
		
		if (this.ennemyId == null && fleets.length > 0) {
			this.ennemyId = fleets[0].owner.id;
		}
		
		for (i in 0...allTargets.length) 
		{
			var killer = allTargets[i].origin;
			var smallest = allTargets[i].getSmallest();
			
			var units = smallest.planet.population + (GameUtil.getTravelNumTurn(killer, smallest.planet) * Game.PLANET_GROWTH) + minimumPopulation;
			
			if (killer.population >= units){
				result.push(new Order(killer.id, smallest.planet.id, units));
			}
		}
		
		return result;
	}
	
	public function getPlanetsScore(context:Galaxy):Array<Targets> {
		var myPlanets = GameUtil.getPlayerPlanets(id, context);
		var ennemyPlanets = GameUtil.getEnnemyPlanets(id, context);
		var allTargets = new Array<Targets>();
		
		for (i in 0...myPlanets.length) 
		{
			var targets = new Targets(myPlanets[i]);
			for (j in 0...ennemyPlanets.length) {
				targets.addTarget(getPlanetScore(myPlanets[i], ennemyPlanets[j]));
			}
			allTargets.push(targets);
		}
		
		return allTargets;
	}
	
	public function getPlanetScore(origin:Planet, target:Planet):Target
	{
		var score = Math.round((target.population / target.size) + GameUtil.getTravelNumTurn(origin, target) * Game.PLANET_GROWTH);
		if (ennemyId != null && target.owner.id == ennemyId) {
			score = score - (Game.PLANET_GROWTH * target.size);
		}
		return new Target(target, score);
	}
	
}
