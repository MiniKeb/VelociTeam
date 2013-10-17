package ;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;

/**
 * ...
 * @author MiniKeb
 */
class Logs
{
	private var logs : Array<Array<Order>>;

	public function new () {
		this.logs = new Array<Array<Order>>();
	}
	
	public function addOrders(orders:Array<Order>):Void {
		this.logs.push(orders);
	}
	
	public function containsOrderTo(planet:Planet):Bool {
		var contains = false;
		
		if(this.logs.length > 0) {
			for (i in 1...4) {
				var current = this.logs[this.logs.length - i];
				
				for (j in 0...current.length) {
					contains = contains || (current[j].targetID == planet.id);
				}
			}
		}
		
		return contains;
	}
	
}