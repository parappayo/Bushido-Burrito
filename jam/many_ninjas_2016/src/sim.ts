
interface TimerCallback
{
	() :void;
}

export class Timer
{
	done :boolean = true;
	repeat: boolean = false;
	duration :number = 1;
	elapsed :number = 0;
	callback :TimerCallback = null;

	start(duration :number, repeat :boolean = false) {
		this.duration = duration;
		this.elapsed = 0;
		this.done = false;
	}

	update(elapsed :number) {
		if (this.done) {
			return;
		}
		this.elapsed += elapsed;

		if (this.elapsed >= this.duration) {
			if (this.callback != null) {
				this.callback();
			}
			this.elapsed = 0;
			this.done = !this.repeat;
		}
	}

	progress() :number {
		return Math.min(this.duration / this.elapsed, 1.0);	
	}
}

export class Population
{
	static NUM_RANKS :number = 12;

	ranks :Array<number>;

	constructor()
	{
		this.ranks = new Array<number>();
		for (var i :number = 0; i < Population.NUM_RANKS; i++) {
			this.ranks.push(0);
		}
	}

	add(quantity :number)
	{
		this.ranks[0] += quantity;
	}

	total() :number
	{
		var total :number = 0;
		for (var rank of this.ranks) {
			total += rank;
		}
		return total;
	}

	tick()
	{

	}
}

export class Barracks
{
	// upgrades
	level :number = 1;
	maxRiceStorageRanks :number = 0;
	cookSpeedRanks :number = 0;
	autoCook :boolean = false;

	private _riceCount :number = 0;
	cookDuration :number = 10; // TODO: configurable
	private _cookTimer :Timer = new Timer();
	onCookingDone :TimerCallback;

	constructor()
	{
		this._cookTimer.callback = this.handleCookingDone;
	}

	isIdle()
	{
		return this._cookTimer.done;
	}

	riceCount() :number
	{
		return this._riceCount;
	}

	maxRiceCount() :number
	{
		// TODO: upgradable
		return 1000;
	}

	addRice(count :number)
	{
		this._riceCount = Math.min(
			this._riceCount + count,
			this.maxRiceCount());
	}

	cook()
	{
		if (this.isIdle) {
			this._cookTimer.start(this.cookDuration);
		}
	}

	private handleCookingDone()
	{
		if (this.onCookingDone) {
			this.onCookingDone();
		}
		this._riceCount = 0;
	}

	tick()
	{
		this._cookTimer.update(1);
	}
}

export class Farm
{
	// upgrades
	level :number = 1;
	fieldsWorked :number = 1;
	autoHarvest :boolean = false;
	growthSpeedRanks :number = 0;
	harvestSpeedRanks :number = 0;
	cookingSpeedRanks :number = 0;

	isIdle() :boolean
	{
		// TODO: implement this
		return false;
	}

	harvest()
	{
		// TODO: implement this
	}

	tick()
	{

	}
}

export class Settlement
{
	population :Population = new Population();
	barracks :Barracks = new Barracks();
	farm :Farm = new Farm();

	constructor()
	{
		this.barracks.onCookingDone = this.handleCookingDone;
	}

	tick()
	{
		this.population.tick();
		this.farm.tick();
	}

	handleCookingDone()
	{
		this.population.add(this.barracks.riceCount());
	}
}

export class Sim
{
	settlements :Array<Settlement> = [];

	spawnSettlement() :Settlement
	{
		var settlement = new Settlement();
		this.settlements.push(settlement);
		return settlement;
	}

	tick()
	{
		for (var settlement of this.settlements) {
			settlement.tick();
		}
	}
}
