package ;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.utils.GameUtil;

/**
 * ...
 * @author MiniKeb
 */
class GalaxyInfoBuilder {
	
	private var myPlanets : Array<Planet>;
	private var ennemyPlanets : Array<Planet>;
	
	public function new (myId:String, galaxy:Galaxy) {
		this.myPlanets = GameUtil.getPlayerPlanets(myId, galaxy);
		this.ennemyPlanets = GameUtil.getEnnemyPlanets(myId, galaxy);
	}
	
	public function build() : GalaxyInfo{
		var info = new GalaxyInfo();
		
		for (ennemyIndex in 0...this.ennemyPlanets.length) {
			var ennemyPlanet = this.ennemyPlanets[ennemyIndex];
			var ennemyDensity = getDensity(ennemyPlanet);
			
			var totalDistance = 0;
			var totalPopulation = 0;
			var totalSize = 0;
			var availableResource = 0;
			for (myIndex in 0...this.myPlanets.length) {
				var myPlanet = this.myPlanets[myIndex];
				var turnDistance = GameUtil.getTravelNumTurn(myPlanet, ennemyPlanet);
				totalDistance = totalDistance + turnDistance;
				totalPopulation = totalPopulation + myPlanet.population;
				totalSize = totalSize + myPlanet.size;
			}
			
			info.myTotalPopulation = totalPopulation;
			info.myTotalSize = totalSize;
			
			var meanDistance = totalDistance / this.myPlanets.length;
			
			if (info.bestRatio == null || getDensity(info.bestRatio.planet) + info.bestRatio.meanTravelTurnCount > ennemyDensity + meanDistance) {
				info.bestRatio = new Distance(ennemyPlanet, meanDistance);
			}
			
			if (info.closestPlanet == null || info.closestPlanet.meanTravelTurnCount > meanDistance) {
				info.closestPlanet = new Distance(ennemyPlanet, meanDistance);
			}
			
			if (info.farestPlanet == null || info.farestPlanet.meanTravelTurnCount < meanDistance) {
				info.farestPlanet = new Distance(ennemyPlanet, meanDistance);
			}
			
			// Prend la plus 1ère plus grosse planète.
			// Peut être amélioré en prenant la plus proche des plus grosses.
			if (info.biggestPlanet == null || info.biggestPlanet.size < ennemyPlanet.size) {
				info.biggestPlanet = ennemyPlanet;
			}
			
			// Prend la plus 1ère plus grosse planète.
			// Peut être amélioré en prenant la plus proche des moins peuplés.
			if (info.lessPopulatePlanet == null || info.lessPopulatePlanet.population > ennemyPlanet.population) {
				info.lessPopulatePlanet = ennemyPlanet;
			}
			
			if (info.sparsestPlanet == null || getDensity(info.sparsestPlanet) > ennemyDensity) {
				info.sparsestPlanet = ennemyPlanet;
			}
			
			if (info.densestPlanet == null || getDensity(info.densestPlanet) < ennemyDensity) {
				info.densestPlanet = ennemyPlanet;
			}
		}
		
		return info;
	}
	
	private function getDensity(planet:Planet) : Float {
		return planet.population / planet.size;
	}
	
	private function getDensityPercentage(planet:Planet) : Float {
		return planet.population / PlanetPopulation.getMaxPopulation(planet.size);
	}
}