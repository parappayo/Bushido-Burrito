
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
			this.done = !this.repeat;
			if (this.callback != null) {
				this.callback();
			}
			this.elapsed = 0;
		}
	}

	progress() :number {
		return Math.min(this.elapsed / this.duration, 1.0);
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

	private _riceCount :number = 1; // TODO: staring value configurable
	cookDuration :number = 10; // TODO: configurable
	private _cookTimer :Timer = new Timer();
	onCookingDone :TimerCallback;

	constructor()
	{
		this._cookTimer.callback = () => { this.handleCookingDone(this) };
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
		if (this.isIdle()) {
			this._cookTimer.start(this.cookDuration);
		}
	}

	cookingProgress()
	{
		return this._cookTimer.progress();
	}

	private handleCookingDone(barracks :Barracks)
	{
		if (barracks.onCookingDone) {
			barracks.onCookingDone();
		}
		barracks._riceCount = 0;
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

	private _harvestReady :boolean;
	public _growingFields :number;

	growthDuration :number = 5; // TODO: configurable
	private _growthTimer :Timer = new Timer();

	harvestDuration :number = 2; // TODO: configurable
	private _harvestTimer :Timer = new Timer();
	onHarvestDone :TimerCallback;

	constructor()
	{
		this._growthTimer.callback = () => { this.handleGrowthDone(this) };
		this._harvestTimer.callback = () => { this.handleHarvestDone(this) };

		this.grow();
	}

	private grow()
	{
		this._harvestReady = false;
		this._growingFields = this.fieldsWorked;
		this._growthTimer.start(this.growthDuration);
	}

	isGrowing() :boolean
	{
		return !this._growthTimer.done;
	}

	growingFields() :number
	{
		return this._growingFields;
	}

	growthProgress() :number
	{
		return this._growthTimer.progress();
	}

	canHarvest()
	{
		return !this.isGrowing() && !this.isHarvesting();
	}

	harvest()
	{
		if (!this.canHarvest()) {
			// TODO: throw error
			return;
		}

		this._harvestReady = false;
		this._harvestTimer.start(this.harvestDuration);
	}

	isHarvesting() :boolean
	{
		return !this._harvestReady && !this._harvestTimer.done;
	}

	harvestProgress() :number
	{
		return this._harvestTimer.progress();
	}

	tick()
	{
		this._growthTimer.update(1);
		this._harvestTimer.update(1);

		if (this.autoHarvest && this.canHarvest()) {
			this.harvest();
		}
	}

	private handleGrowthDone(farm :Farm)
	{
		farm._harvestReady = true;
	}

	private handleHarvestDone(farm :Farm)
	{
		if (farm.onHarvestDone) {
			farm.onHarvestDone();
		}
		farm.grow();
	}
}

export class Settlement
{
	population :Population = new Population();
	barracks :Barracks = new Barracks();
	farm :Farm = new Farm();

	constructor()
	{
		this.farm.onHarvestDone = () => { this.handleHarvestDone(this) };
		this.barracks.onCookingDone = () => { this.handleCookingDone(this) };
	}

	tick()
	{
		this.population.tick();
		this.barracks.tick();
		this.farm.tick();
	}

	handleHarvestDone(settlement :Settlement)
	{
		settlement.barracks.addRice(this.farm.growingFields());
	}

	handleCookingDone(settlement :Settlement)
	{
		settlement.population.add(this.barracks.riceCount());
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
