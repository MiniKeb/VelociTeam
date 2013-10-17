package ;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Game;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.data.Player;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.geom.Point;
/**
 * Model d'IA de base au SDK. Il a le même niveau que le robot de validation des combats
 * @author d.mouton
 */

class VelociTeamIA extends WorkerIA
{
	private var logs : Logs;
	private var minPopulation : Int;
	private var ennemyId : String;
	
	/**
	 * @internal
	 */
	public static function main():Void {
		WorkerIA.instance = new VelociTeamIA();
	}
	
	public function new () {
		super("", 0);
		this.logs = new Logs();
		this.minPopulation = 20;
		this.ennemyId = null;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function getOrders( context:Galaxy ):Array<Order>
	{
		var info = new GalaxyInfoBuilder(id, context).build();
		var myPlanets = GameUtil.getPlayerPlanets(id, context);
		var otherPlanets = GameUtil.getEnnemyPlanets(id, context);
		var fleets = GameUtil.getEnnemyFleet(id, context);
		if (ennemyId == null && fleets.length > 0) {
			ennemyId = fleets[0].owner.id;
		}
		
		var result:Array<Order> = new Array<Order>();
		
		
		if (myPlanets.length == 1) {
			
			var source = myPlanets[0];
			var cheapCost : Float = 1000;
			var target : Planet = null;
			
			for (i in 0...otherPlanets.length) 
			{
				var otherPlanet = otherPlanets[i];
				var cost = (otherPlanet.population / otherPlanet.size) + GameUtil.getTravelNumTurn(source, otherPlanet) * Game.PLANET_GROWTH;
				if (cheapCost > cost) {
					cheapCost = cost;
					target = otherPlanet;
				}
			}
			
			if (target != null) {
				var availableUnitCount = source.population - (source.size * Game.PLANET_GROWTH);
				if (availableUnitCount > target.population + GameUtil.getTravelNumTurn(source, target) * Game.PLANET_GROWTH) {
					var units = availableUnitCount > PlanetPopulation.getMaxPopulation(target.size) + GameUtil.getTravelNumTurn(source, target) * Game.PLANET_GROWTH 
						? PlanetPopulation.getMaxPopulation(target.size) + GameUtil.getTravelNumTurn(source, target) * Game.PLANET_GROWTH 
						: availableUnitCount;
					
					result.push(new Order(source.id, target.id, units));
				}
			}
		}
		else if (myPlanets.length == 2) {
			var cheapCost : Float = 1000;
			var totalAvailableUnitCount = 0;
			var target : Planet = null;
			var totalTravelCost = 0;
			for (i in 0...otherPlanets.length) {
				var otherPlanet = otherPlanets[i];
				
				totalAvailableUnitCount = 0;
				var totalCost : Float = 0;
				var targetTotalTravelCost = 0;
				for (j in 0...myPlanets.length) {
					var myPlanet = myPlanets[j];
					var travelCost = GameUtil.getTravelNumTurn(myPlanet, otherPlanet) * Game.PLANET_GROWTH;
					totalCost = totalCost + (otherPlanet.population / otherPlanet.size) + travelCost;
					totalAvailableUnitCount = totalAvailableUnitCount + (myPlanet.population - (myPlanet.size * Game.PLANET_GROWTH));
					targetTotalTravelCost = targetTotalTravelCost + travelCost;
				}
				
				var meanCost = totalCost / myPlanets.length;
				if (cheapCost > meanCost) {
					cheapCost = meanCost;
					target = otherPlanet;
					totalTravelCost = targetTotalTravelCost;
				}
			}
			
			if (target != null) {
				if (totalAvailableUnitCount > target.population + totalTravelCost) {
					var sentUnits = 0;
					for (j in 0...myPlanets.length) {
						var myPlanet = myPlanets[j];
						var availableUnitCount = (myPlanet.population - (myPlanet.size * Game.PLANET_GROWTH));
						
						var units = availableUnitCount > PlanetPopulation.getMaxPopulation(target.size) + (GameUtil.getTravelNumTurn(myPlanet, target) * Game.PLANET_GROWTH) - sentUnits 
							? PlanetPopulation.getMaxPopulation(target.size) + (GameUtil.getTravelNumTurn(myPlanet, target) * Game.PLANET_GROWTH) - sentUnits
							: availableUnitCount;
						
						result.push(new Order(myPlanet.id, target.id, units));
						sentUnits = sentUnits + units;						
					}
				}
			}
			
		}
		else 
		{
			var cheapCost : Float = 1000;
			var totalAvailableUnitCount = 0;
			var target : Planet = null;
			var totalTravelCost = 0;
			for (i in 0...otherPlanets.length) {
				var otherPlanet = otherPlanets[i];
				
				if (otherPlanet.owner.id == ennemyId){
					totalAvailableUnitCount = 0;
					var totalCost : Float = 0;
					var targetTotalTravelCost = 0;
					for (j in 0...myPlanets.length) {
						var myPlanet = myPlanets[j];
						var travelCost = GameUtil.getTravelNumTurn(myPlanet, otherPlanet) * Game.PLANET_GROWTH;
						totalCost = totalCost + (otherPlanet.population / otherPlanet.size) + travelCost;
						totalAvailableUnitCount = totalAvailableUnitCount + (myPlanet.population - (myPlanet.size * Game.PLANET_GROWTH));
						targetTotalTravelCost = targetTotalTravelCost + travelCost;
					}
					
					var meanCost = totalCost / myPlanets.length;
					if (cheapCost > meanCost) {
						cheapCost = meanCost;
						target = otherPlanet;
						totalTravelCost = targetTotalTravelCost;
					}
				}
			}
			
			if (target != null) {
				if (totalAvailableUnitCount > target.population + totalTravelCost) {
					var sentUnits = 0;
					for (j in 0...myPlanets.length) {
						var myPlanet = myPlanets[j];
						var availableUnitCount = (myPlanet.population - (myPlanet.size * Game.PLANET_GROWTH));
						
						var units = availableUnitCount > PlanetPopulation.getMaxPopulation(target.size) + (GameUtil.getTravelNumTurn(myPlanet, target) * Game.PLANET_GROWTH) - sentUnits 
							? PlanetPopulation.getMaxPopulation(target.size) + (GameUtil.getTravelNumTurn(myPlanet, target) * Game.PLANET_GROWTH) - sentUnits
							: availableUnitCount;
						
						result.push(new Order(myPlanet.id, target.id, units));
						sentUnits = sentUnits + units;						
					}
				}
			}
		}
		
		/*
		var allTargets = getPlanetsScore(context);
		var fleets = GameUtil.getEnnemyFleet(id, context);
		
		for (i in 0...allTargets.length) 
		{
			var killer = allTargets[i].origin;
			var smallest = allTargets[i].getSmallest();
			
			var units = smallest.planet.population + (GameUtil.getTravelNumTurn(killer, smallest.planet) * Game.PLANET_GROWTH) + 10;
			
			var isAttacked = false;
			for (f in 0...fleets.length) {
				isAttacked = isAttacked || fleets[f].target == killer;
			}
			
			if (killer.population >= units && !isAttacked){
				result.push(new Order(killer.id, smallest.planet.id, units));
			} 
		}
		
		logs.addOrders(result);
		*/
		
		/*
		if (myPlanets.length <= 3) {
			var order = attack(myPlanets[0], info.bestRatio.planet, info);
			if (order != null) {
				result.push(order);
			}
				
			//var excessUnits = info.bestRatio.meanTravelTurnCount * Game.PLANET_GROWTH;
			//var sendUnits = Math.round(info.bestRatio.planet.population + excessUnits);
			//if (myPlanets[0].population - minPopulation > sendUnits + minPopulation) {
				//result.push(new Order(myPlanets[0].id, info.bestRatio.planet.id, sendUnits + minPopulation));
			//}
		} else if (myPlanets.length < 4) {
			var target : Planet = null;
			var availableResourceCount = info.myTotalPopulation - (myPlanets.length * minPopulation);
			if (availableResourceCount > info.closestPlanet.planet.population + GameUtil.getTravelNumTurn(myPlanets[0], info.closestPlanet.planet) * Game.PLANET_GROWTH) {
				target = info.closestPlanet.planet;
			} else if (availableResourceCount > info.sparsestPlanet.population + GameUtil.getTravelNumTurn(myPlanets[0], info.sparsestPlanet) * Game.PLANET_GROWTH) {
				target = info.sparsestPlanet;
			} else if (availableResourceCount > info.lessPopulatePlanet.population + GameUtil.getTravelNumTurn(myPlanets[0], info.lessPopulatePlanet) * Game.PLANET_GROWTH) {
				target = info.lessPopulatePlanet;
			}
			
			for (i in 0...myPlanets.length) 
			{
				if (target != null){
					var order = attack(myPlanets[i], target, info, true);
					if (order != null) {
						result.push(order);
					}
				}
			}
		} else {
			for (i in 0...myPlanets.length) 
			{
				var order = attack(myPlanets[i], info.biggestPlanet, info, true);
				if (order != null) {
					result.push(order);
				}
				
			}
		}
		*/
		return result;
	}
	
	private function attack(source:Planet, target:Planet, galaxyInfo:GalaxyInfo, forceAttack:Bool = false) : Order
	{
		
		var ratio = Math.round(source.size / galaxyInfo.myTotalSize);
		var availableUnits = (source.population - minPopulation) * ratio;
		var excessUnits = GameUtil.getTravelNumTurn(source, target) * Game.PLANET_GROWTH;
		var sendUnits = availableUnits + excessUnits; //Math.round((target.population + excessUnits) / myPlanetCount);
		
		var needUnits = target.population + excessUnits;
		
		if (source.population - minPopulation >= minPopulation) {
			return new Order(source.id, target.id, source.population - minPopulation);
		}
		
		//if (availableUnits > PlanetPopulation.getMaxPopulation(target.size)
		/*if (forceAttack && sendUnits > 0) {
			return new Order(source.id, target.id, sendUnits);
		} else if (source.population - minPopulation >= sendUnits + minPopulation){
			return new Order(source.id, target.id, sendUnits + minPopulation);
		}*/
		
		
		
		
		
		
		return null;
	}
	
	private function getNearestEnnemyPlanet( source:Planet, candidats:Array<Planet> ):Planet
	{
		var result:Planet = candidats[ 0 ];
		var currentDist:Float = GameUtil.getDistanceBetween( new Point( source.x, source.y ), new Point( result.x, result.y ) );
		for ( i in 0...candidats.length )
		{
			var element:Planet = candidats[ i ];
			if ( currentDist > GameUtil.getDistanceBetween( new Point( source.x, source.y ), new Point( element.x, element.y ) ) )
			{
				currentDist = GameUtil.getDistanceBetween( new Point( source.x, source.y ), new Point( element.x, element.y ) );
				result = element;
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
		var score = Math.round((target.population / target.size) + GameUtil.getTravelNumTurn(origin, target) * 5);
		return new Target(target, score);
	}
	
}
